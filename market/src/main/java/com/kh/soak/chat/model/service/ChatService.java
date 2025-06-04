package com.kh.soak.chat.model.service;

import java.util.List;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;

public interface ChatService {

    // 채팅방 관련
    int createChatRoom(ChatRoomVO room);
    ChatRoomVO getChatRoomById(int roomNo);
    List<ChatRoomVO> getChatRoomsByUserId(String userId);
    int updateLastVisit(ChatRoomVO room); 
    int getNextChatRoomNo(); // (중요) 새로운 시퀀스 번호를 가져오는 메서드 추가

    // 메시지 관련
    int saveMessage(MessageVO message);
    List<MessageVO> getMessagesByRoomNo(int roomNo);
}