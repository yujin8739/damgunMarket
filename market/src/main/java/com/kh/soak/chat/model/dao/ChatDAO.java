package com.kh.soak.chat.model.dao;

import java.util.List;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;

public interface ChatDAO {

    // 채팅방
    int insertChatRoom(ChatRoomVO room);
    ChatRoomVO selectChatRoomById(int roomNo);
    List<ChatRoomVO> selectChatRoomsByUserId(String userId);
    
    // 메시지
    int insertMessage(MessageVO message);
    List<MessageVO> selectMessagesByRoomNo(int roomNo);
}
