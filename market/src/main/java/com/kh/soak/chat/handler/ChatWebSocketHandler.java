package com.kh.soak.chat.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.soak.chat.model.service.ChatService;
import com.kh.soak.chat.model.vo.MessageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class ChatWebSocketHandler extends TextWebSocketHandler {

    @Autowired
    private ChatService chatService;

    private Map<Integer, Map<String, WebSocketSession>> roomSessions = new ConcurrentHashMap<>();

    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("WebSocket 연결 성공: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        System.out.println("Received payload: " + payload);

        MessageVO receivedMessage = objectMapper.readValue(payload, MessageVO.class);

        if ("enter".equals(receivedMessage.getType())) {
            int roomNo = receivedMessage.getRoomNo();
            String userId = receivedMessage.getUserId();

            roomSessions.computeIfAbsent(roomNo, k -> new ConcurrentHashMap<>()).put(userId, session);
            System.out.println("세션 " + session.getId() + "가 방 " + roomNo + "에 입장했습니다. (User: " + userId + ")");

        } else if ("chat".equals(receivedMessage.getType()) || "image".equals(receivedMessage.getType())) {
            receivedMessage.setSendTime(new Date()); 

            int result = chatService.insertMessage(receivedMessage);
            if (result > 0) {
                System.out.println("메시지 DB 저장 성공: RoomNo=" + receivedMessage.getRoomNo() + ", UserId=" + receivedMessage.getUserId() + ", Message=" + receivedMessage.getMessage());
            } else {
                System.out.println("메시지 DB 저장 실패: " + receivedMessage);
            }

            int roomNo = receivedMessage.getRoomNo();
            if (roomSessions.containsKey(roomNo)) {
                String broadcastPayload = objectMapper.writeValueAsString(receivedMessage);
                System.out.println("Broadcasting message: " + broadcastPayload);
                for (WebSocketSession s : roomSessions.get(roomNo).values()) {
                    if (s.isOpen()) {
                        s.sendMessage(new TextMessage(broadcastPayload));
                    }
                }
            }
        } else {
            System.out.println("Unknown message type received: " + receivedMessage.getType());
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        System.out.println("WebSocket 연결 종료: " + session.getId() + " (Status: " + status.getCode() + ")");

        for (Map.Entry<Integer, Map<String, WebSocketSession>> roomEntry : roomSessions.entrySet()) {
            roomEntry.getValue().entrySet().removeIf(entry -> entry.getValue().equals(session));
            if (roomEntry.getValue().isEmpty()) {
                roomSessions.remove(roomEntry.getKey());
            }
        }
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        System.err.println("WebSocket 전송 오류: " + exception.getMessage() + " (Session ID: " + session.getId() + ")");
        exception.printStackTrace();
    }
}