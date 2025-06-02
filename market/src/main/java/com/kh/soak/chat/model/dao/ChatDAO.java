package com.kh.soak.chat.model.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;

@Repository
public class ChatDAO {

    // 채팅방
    public int insertChatRoom(ChatRoomVO room) {
		return 0;
    	
    }
    public ChatRoomVO selectChatRoomById(int roomNo) {
		return null;
    	
    }
    public List<ChatRoomVO> selectChatRoomsByUserId(String userId){
		return null;
    	
    }
    
    // 메시지
    public int insertMessage(MessageVO message) {
		return 0;
    	
    }
    public List<MessageVO> selectMessagesByRoomNo(int roomNo) {
		return null;
    	
    }
}
