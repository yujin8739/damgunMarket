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

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.soak.chat.model.service.ChatService;
import com.kh.soak.chat.model.vo.MessageVO;
import com.kh.soak.member.model.vo.Member;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ChatWebSocketHandler extends TextWebSocketHandler {

    private static final Logger logger = LoggerFactory.getLogger(ChatWebSocketHandler.class);

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ChatService chatService;

    private Map<Integer, Set<WebSocketSession>> roomSessions = Collections.synchronizedMap(new HashMap<>());
    private Map<String, Integer> sessionRoomMap = Collections.synchronizedMap(new HashMap<>());

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        logger.info("WebSocket 연결 성공: {}", session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        logger.debug("수신 메시지 (RAW): {}", payload);

        try {
            MessageVO receivedMessage = objectMapper.readValue(payload, MessageVO.class);
            logger.debug("파싱된 메시지: {}", receivedMessage);

            int roomNo = receivedMessage.getRoomNo();
            String userId = receivedMessage.getUserId();
            String messageType = receivedMessage.getType();

            Map<String, Object> sessionAttrs = session.getAttributes();
            Member loginUser = (Member) sessionAttrs.get("loginUser");

            if (loginUser == null || !loginUser.getUserId().equals(userId)) {
                logger.warn("비정상적인 메시지: 세션 유저({}/{})와 메시지 유저({}) 불일치 또는 비로그인",
                            loginUser != null ? loginUser.getUserId() : "null", session.getId());
                session.sendMessage(new TextMessage("{\"status\":\"error\", \"message\":\"Invalid user session or user ID mismatch.\"}"));
                return;
            }

            switch (messageType) {
                case "enter":
                    Integer oldRoomNo = sessionRoomMap.get(session.getId());
                    if (oldRoomNo != null && !oldRoomNo.equals(roomNo)) {
                        Set<WebSocketSession> oldRoom = roomSessions.get(oldRoomNo);
                        if (oldRoom != null) {
                            oldRoom.remove(session);
                            logger.info("세션 {}가 방 {}에서 제거되었습니다.", session.getId(), oldRoomNo);
                            if (oldRoom.isEmpty()) {
                                roomSessions.remove(oldRoomNo);
                            }
                        }
                    }

                    roomSessions.computeIfAbsent(roomNo, k -> Collections.synchronizedSet(new HashSet<>())).add(session);
                    sessionRoomMap.put(session.getId(), roomNo);
                    logger.info("세션 {}가 방 {}에 입장했습니다. (User: {})", session.getId(), roomNo);
                    break;

                case "chat":
                case "image":
                    receivedMessage.setSendTime(new Date());
                    receivedMessage.setType(messageType);

                    try {
                        int result = chatService.insertMessage(receivedMessage);
                        if (result > 0) {
                            logger.info("메시지 DB 저장 성공: RoomNo={}, UserId={}, Message={}", roomNo, userId);
                        } else {
                            logger.error("메시지 DB 저장 실패: RoomNo={}, UserId={}, Message={}", roomNo, userId);
                        }
                    } catch (Exception e) {
                        // logger.error 호출 형식 수정: 예외 객체를 마지막 인자로 전달
                        logger.error("메시지 DB 저장 중 예외 발생: RoomNo={}, UserId={}, Message={}");
                        session.sendMessage(new TextMessage("{\"status\":\"error\", \"message\":\"Failed to save message to DB.\"}"));
                        return;
                    }

                    broadcastMessageToRoom(roomNo, receivedMessage);
                    break;

                case "leave":
                    Set<WebSocketSession> sessionsInRoom = roomSessions.get(roomNo);
                    if (sessionsInRoom != null) {
                        sessionsInRoom.remove(session);
                        sessionRoomMap.remove(session.getId());
                        logger.info("세션 {}가 방 {}에서 퇴장했습니다. (User: {})", session.getId(), roomNo);
                        if (sessionsInRoom.isEmpty()) {
                            roomSessions.remove(roomNo);
                        }
                    }
                    break;

                default:
                    logger.warn("알 수 없는 메시지 타입: {} (Payload: {})", messageType, payload);
                    session.sendMessage(new TextMessage("{\"status\":\"error\", \"message\":\"Unknown message type.\"}"));
            }

        } catch (IOException e) {
            // logger.error 호출 형식 수정: 예외 객체를 마지막 인자로 전달
            logger.error("JSON 파싱/처리 중 IOException 발생: Payload={}", payload, e);
            session.sendMessage(new TextMessage("{\"status\":\"error\", \"message\":\"Invalid message format.\"}"));
        } catch (Exception e) {
            // logger.error 호출 형식 수정: 예외 객체를 마지막 인자로 전달
            logger.error("메시지 처리 중 알 수 없는 오류 발생: Payload={}", payload, e);
            session.sendMessage(new TextMessage("{\"status\":\"error\", \"message\":\"Internal server error.\"}"));
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        logger.info("WebSocket 연결 종료: {} 상태: {}", session.getId(), status.getCode());

        Integer roomNo = sessionRoomMap.remove(session.getId());
        if (roomNo != null) {
            Set<WebSocketSession> sessionsInRoom = roomSessions.get(roomNo);
            if (sessionsInRoom != null) {
                sessionsInRoom.remove(session);
                if (sessionsInRoom.isEmpty()) {
                    roomSessions.remove(roomNo);
                }
                logger.info("연결 종료로 인해 세션 {}가 방 {}에서 제거되었습니다.", session.getId(), roomNo);
            }
        }
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        // logger.error 호출 형식 수정: 예외 객체를 마지막 인자로 전달
        logger.error("WebSocket 전송 오류: SessionId={}", session.getId(), exception);
        afterConnectionClosed(session, CloseStatus.SERVER_ERROR);
    }

    private void broadcastMessageToRoom(int roomNo, MessageVO message) {
        Set<WebSocketSession> sessions = roomSessions.get(roomNo);
        if (sessions != null) {
            String jsonMessage;
            try {
                jsonMessage = objectMapper.writeValueAsString(message);
            } catch (IOException e) {
                // logger.error 호출 형식 수정: 예외 객체를 마지막 인자로 전달
                logger.error("메시지 객체를 JSON으로 변환 중 오류 발생: Message={}", message, e);
                return;
            }

            TextMessage textMessage = new TextMessage(jsonMessage);

            for (WebSocketSession s : new HashSet<>(sessions)) {
                if (s.isOpen()) {
                    try {
                        s.sendMessage(textMessage);
                    } catch (IOException e) {
                        // logger.error 호출 형식 수정: 예외 객체를 마지막 인자로 전달
                        logger.error("세션 {}로 메시지 전송 중 오류 발생", s.getId(), e);
                        try {
                            s.close(CloseStatus.SERVER_ERROR.withReason("Message sending error"));
                        } catch (IOException closeEx) {
                            logger.error("오류 발생 세션 {} 닫기 실패: {}", s.getId(), closeEx.getMessage());
                        }
                    }
                } else {
                    sessions.remove(s);
                    sessionRoomMap.remove(s.getId());
                    logger.info("닫힌 세션 {}를 방 {}에서 제거했습니다.", s.getId(), roomNo);
                }
            }
        }
    }
}