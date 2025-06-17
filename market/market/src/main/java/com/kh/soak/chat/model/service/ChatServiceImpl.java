package com.kh.soak.chat.model.service;

import com.kh.soak.chat.model.dao.ChatDAO;
import com.kh.soak.chat.model.vo.ChatParticipantVO;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private ChatDAO chatDAO;

    @Override
    @Transactional
    public ChatRoomVO getOrCreateChatRoom(String user1Id, String user2Id) {
        String smallerId = user1Id.compareTo(user2Id) < 0 ? user1Id : user2Id;
        String largerId = user1Id.compareTo(user2Id) < 0 ? user2Id : user1Id;

        Map<String, String> userIds = new HashMap<>();
        userIds.put("userId1", smallerId);
        userIds.put("userId2", largerId);

        ChatRoomVO chatRoom = chatDAO.selectChatRoomByParticipants(userIds);

        if (chatRoom == null) {
            chatRoom = new ChatRoomVO();
            chatRoom.setChatType("TEXT");
            chatRoom.setCreatedDate(new Date());

            int result = chatDAO.insertChatRoom(chatRoom);

            if (result > 0) {
                ChatParticipantVO participant1 = new ChatParticipantVO(chatRoom.getRoomNo(), user1Id, new Date());
                ChatParticipantVO participant2 = new ChatParticipantVO(chatRoom.getRoomNo(), user2Id, new Date());

                chatDAO.insertChatParticipant(participant1);
                chatDAO.insertChatParticipant(participant2);

                chatRoom.setOtherUserId(user2Id);
                chatRoom.setOtherUserName(chatDAO.selectUserNameByUserId(user2Id));
            } else {
                throw new RuntimeException("채팅방 생성 실패");
            }
        } else {
            Map<String, Object> roomUserParams = new HashMap<>();
            roomUserParams.put("roomNo", chatRoom.getRoomNo());
            roomUserParams.put("currentUserId", user1Id);
            // Service 내부에서 DAO를 호출하는 것은 괜찮습니다.
            String existingOtherUserId = chatDAO.selectOtherParticipantId(roomUserParams);
            chatRoom.setOtherUserId(existingOtherUserId);
            chatRoom.setOtherUserName(chatDAO.selectUserNameByUserId(existingOtherUserId));
        }
        return chatRoom;
    }

    @Override
    public List<ChatRoomVO> getChatRoomsByUserId(String userId) {
        List<ChatRoomVO> roomList = chatDAO.selectChatRoomsByUserId(userId);

        for (ChatRoomVO room : roomList) {
            Map<String, Object> params = new HashMap<>();
            params.put("roomNo", room.getRoomNo());
            params.put("userId", userId);
            params.put("lastVisitTime", room.getLastVisit());

            int unreadCount = chatDAO.selectUnreadMessageCount(params);
            // room.setUnreadMessageCount(unreadCount); // ChatRoomVO에 필드 추가 시 사용
        }
        return roomList;
    }

    @Override
    public int updateLastVisit(ChatParticipantVO participant) {
        return chatDAO.updateLastVisit(participant);
    }

    @Override
    public List<MessageVO> getMessagesByRoomNo(int roomNo) {
        return chatDAO.selectMessagesByRoomNo(roomNo);
    }

    @Override
    @Transactional
    public int insertMessage(MessageVO message) {
        return chatDAO.insertMessage(message);
    }

    @Override
    public ChatRoomVO getChatRoomByRoomNo(int roomNo) {
        return chatDAO.selectChatRoomByRoomNo(roomNo);
    }

    @Override
    public int getUnreadMessageCount(int roomNo, String userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("roomNo", roomNo);
        params.put("userId", userId);

        ChatParticipantVO participant = new ChatParticipantVO();
        participant.setRoomNo(roomNo);
        participant.setUserId(userId);
        Date lastVisitTime = chatDAO.selectLastVisitTime(participant);

        if (lastVisitTime == null) {
            lastVisitTime = new Date(0);
        }

        params.put("lastVisitTime", lastVisitTime);

        return chatDAO.selectUnreadMessageCount(params);
    }

    // ChatService 인터페이스에 추가된 메서드 구현
    @Override
    public String selectOtherParticipantId(Map<String, Object> params) {
        return chatDAO.selectOtherParticipantId(params);
    }

    @Override
    public String selectUserNameByUserId(String userId) {
        return chatDAO.selectUserNameByUserId(userId);
    }
    @Override
    public String getUserIdByUserNo(int userNo) {
        return chatDAO.selectUserIdByUserNo(userNo);
    }
}