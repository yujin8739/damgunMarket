package com.kh.soak.chat.handler;

import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper; // Jackson 라이브러리 임포트
import com.kh.soak.chat.model.service.ChatService;
import com.kh.soak.chat.model.vo.MessageVO;
import com.kh.soak.member.model.vo.Member; // Member DTO 임포트

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ChatWebSocketHandler extends TextWebSocketHandler {

	@Autowired
	private ObjectMapper objectMapper; // JSON 직렬화/역직렬화를 위한 ObjectMapper 주입

	@Autowired
	private ChatService chatService; // 채팅 메시지 저장 서비스 주입

	// 현재 연결된 모든 WebSocket 세션을 저장합니다. (동기화된 Set 사용)
	// Map<Integer, Set<WebSocketSession>>: roomNo -> Set of sessions in that room
	private Map<Integer, Set<WebSocketSession>> roomSessions = Collections
			.synchronizedMap(new HashMap<Integer, Set<WebSocketSession>>());

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("WebSocket 연결 성공: " + session.getId());
		// 초기에는 어떤 방에도 할당되지 않습니다.
		// 클라이언트에서 "enter" 메시지를 보낼 때 방에 할당됩니다.
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// 클라이언트로부터 JSON 형태의 메시지를 수신합니다.
		String payload = message.getPayload();
		System.out.println("수신 메시지 (RAW): " + payload);

		try {
			// JSON 문자열을 MessageVO 객체로 변환
			MessageVO receivedMessage = objectMapper.readValue(payload, MessageVO.class);
			System.out.println("파싱된 메시지: " + receivedMessage);

			int roomNo = receivedMessage.getRoomNo();
			String userId = receivedMessage.getUserId(); // 메시지를 보낸 유저 ID
			String msgContent = receivedMessage.getMessage();
			String imageUrl = receivedMessage.getImageUrl();
			String messageType = receivedMessage.getType(); // 메시지 타입 (enter, chat, image 등)

			// 세션에서 로그인된 유저 정보 가져오기 (HttpSessionHandshakeInterceptor 덕분에 가능)
			Map<String, Object> sessionAttrs = session.getAttributes();
			Member loginUser = (Member) sessionAttrs.get("loginUser");

			// 로그인 유저가 없을 경우 처리 (선택 사항, 로그인 필터에서 처리될 수도 있음)
			if (loginUser == null || !loginUser.getUserId().equals(userId)) {
				System.err.println("비정상적인 메시지: 세션 유저와 메시지 유저 불일치 또는 비로그인");
				session.sendMessage(new TextMessage("{\"status\":\"error\", \"message\":\"Invalid user session.\"}"));
				return;
			}

			// 메시지 타입에 따른 처리
			if ("enter".equals(messageType)) {
				// 입장 메시지 처리: 해당 방의 세션 목록에 현재 세션 추가
				roomSessions.computeIfAbsent(roomNo, k -> Collections.synchronizedSet(new HashSet<>())).add(session);
				System.out.println("세션 " + session.getId() + "가 방 " + roomNo + "에 입장했습니다.");
				// 입장 메시지는 보통 클라이언트에 다시 브로드캐스트하지 않습니다.
				// 또는 입장 알림 메시지를 방에 있는 다른 유저들에게 보낼 수도 있습니다.
				// 예시: broadcastMessageToRoom(roomNo, receivedMessage);
			} else if ("chat".equals(messageType)) {
				// 채팅 메시지 처리: DB에 저장 후 해당 방의 모든 세션에 브로드캐스트
				// 메시지 객체에 보낸 시간 설정 (DB에 저장될 시간)
				receivedMessage.setSendTime(new Date());
				receivedMessage.setType("chat"); // 혹시나 해서 다시 설정

				// 1. 메시지 DB 저장
				int result = chatService.saveMessage(receivedMessage);
				if (result > 0) {
					System.out.println("메시지 DB 저장 성공: " + receivedMessage.getMessage());
				} else {
					System.err.println("메시지 DB 저장 실패: " + receivedMessage.getMessage());
				}

				// 2. 해당 방의 모든 세션에 메시지 브로드캐스트
				broadcastMessageToRoom(roomNo, receivedMessage);
			} else if ("image".equals(messageType)) {
				// 이미지 메시지는 이미지가 HTTP로 업로드되어 URL만 넘어오므로,
				// 일반 채팅 메시지처럼 처리하고 IMAGEURL을 활용합니다.
				// (Controller에서 이미지를 업로드하고 URL을 반환받아 웹소켓으로 보냈을 때의 처리)
				receivedMessage.setSendTime(new Date());
				receivedMessage.setType("image"); // 메시지 타입은 'image'로 명확히

				// 1. 메시지 DB 저장 (imageUrl 포함)
				int result = chatService.saveMessage(receivedMessage);
				if (result > 0) {
					System.out.println("이미지 메시지 DB 저장 성공: " + receivedMessage.getImageUrl());
				} else {
					System.err.println("이미지 메시지 DB 저장 실패: " + receivedMessage.getImageUrl());
				}

				// 2. 해당 방의 모든 세션에 이미지 메시지 브로드캐스트
				broadcastMessageToRoom(roomNo, receivedMessage);

			} else {
				System.err.println("알 수 없는 메시지 타입: " + messageType);
			}

		} catch (Exception e) {
			System.err.println("메시지 처리 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
			// 오류 발생 시 클라이언트에게 에러 메시지 전송 (선택 사항)
			session.sendMessage(new TextMessage("{\"status\":\"error\", \"message\":\"Failed to process message.\"}"));
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println("WebSocket 연결 종료: " + session.getId() + " 상태: " + status.getCode());
		// 세션이 닫힐 때, 모든 방에서 해당 세션을 제거합니다.
		for (Set<WebSocketSession> sessionsInRoom : roomSessions.values()) {
			sessionsInRoom.remove(session);
		}
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		System.err.println("WebSocket 전송 오류: " + session.getId() + " 에러: " + exception.getMessage());
		exception.printStackTrace();
	}

	/**
	 * 특정 채팅방의 모든 세션에 메시지를 브로드캐스트합니다.
	 * 
	 * @param roomNo  브로드캐스트할 채팅방 번호
	 * @param message 전송할 메시지 객체
	 * @throws IOException
	 */
	private void broadcastMessageToRoom(int roomNo, MessageVO message) throws IOException {
		Set<WebSocketSession> sessions = roomSessions.get(roomNo);
		if (sessions != null) {
			// MessageVO 객체를 JSON 문자열로 변환
			TextMessage textMessage = new TextMessage(objectMapper.writeValueAsString(message));

			for (WebSocketSession s : sessions) {
				if (s.isOpen()) {
					s.sendMessage(textMessage);
				}
			}
		}
	}
}