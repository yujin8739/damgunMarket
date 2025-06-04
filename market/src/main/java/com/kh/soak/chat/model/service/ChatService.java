package com.kh.soak.chat.model.service;

import java.util.List;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;

public interface ChatService {

    // 채팅방
    int createChatRoom(ChatRoomVO room);
    ChatRoomVO getChatRoomById(int roomNo);
    List<ChatRoomVO> getChatRoomsByUserId(String userId);

    // 메시지
    int saveMessage(MessageVO message);
    List<MessageVO> getMessagesByRoomNo(int roomNo);
}
