package com.kh.soak.chat.model.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kh.soak.chat.model.dao.ChatDAO;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private ChatDAO chatDAO;

    // 채팅방 관련
    @Override
    public int createChatRoom(ChatRoomVO room) {
        return chatDAO.insertChatRoom(room);
    }

    @Override
    public ChatRoomVO getChatRoomById(int roomNo) {
        return chatDAO.selectChatRoomById(roomNo);
    }

    @Override
    public List<ChatRoomVO> getChatRoomsByUserId(String userId) {
        return chatDAO.selectChatRoomsByUserId(userId);
    }

    @Override
    public int updateLastVisit(ChatRoomVO room) {
        return chatDAO.updateLastVisit(room);
    }

    @Override
    public int getNextChatRoomNo() {
        return chatDAO.getNextChatRoomNo(); // (중요) DAO에 추가할 메서드 호출
    }

    // 메시지 관련
    @Override
    public int saveMessage(MessageVO message) {
        return chatDAO.insertMessage(message);
    }

    @Override
    public List<MessageVO> getMessagesByRoomNo(int roomNo) {
        return chatDAO.selectMessagesByRoomNo(roomNo);
    }
}