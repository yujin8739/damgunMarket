package com.kh.soak.chat.model.dao;

import com.kh.soak.chat.model.vo.ChatParticipantVO;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.Date; // Date import 추가

@Repository
public class ChatDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    // 1. 채팅방 생성
    public int insertChatRoom(ChatRoomVO chatRoom) {
        return sqlSession.insert("chatMapper.insertChatRoom", chatRoom);
    }

    // 2. 채팅방 참여자 추가 (방 생성 후)
    public int insertChatParticipant(ChatParticipantVO participant) {
        return sqlSession.insert("chatMapper.insertChatParticipant", participant);
    }

    // 3. 1:1 채팅방 존재 여부 확인 (두 유저 ID로 검색)
    public ChatRoomVO selectChatRoomByParticipants(Map<String, String> userIds) {
        return sqlSession.selectOne("chatMapper.selectChatRoomByParticipants", userIds);
    }

    // 4. 특정 유저가 참여하는 채팅방 목록 조회
    public List<ChatRoomVO> selectChatRoomsByUserId(String userId) {
        return sqlSession.selectList("chatMapper.selectChatRoomsByUserId", userId);
    }

    // 5. 채팅방 입장 시 마지막 방문 시간 업데이트
    public int updateLastVisit(ChatParticipantVO participant) {
        return sqlSession.update("chatMapper.updateLastVisit", participant);
    }

    // 6. 특정 채팅방의 메시지 목록 조회
    public List<MessageVO> selectMessagesByRoomNo(int roomNo) {
        return sqlSession.selectList("chatMapper.selectMessagesByRoomNo", roomNo);
    }

    // 7. 메시지 전송 (삽입)
    public int insertMessage(MessageVO message) {
        return sqlSession.insert("chatMapper.insertMessage", message);
    }

    // 8. 특정 채팅방 정보 조회 (ROOMNO로)
    public ChatRoomVO selectChatRoomByRoomNo(int roomNo) {
        return sqlSession.selectOne("chatMapper.selectChatRoomByRoomNo", roomNo);
    }

    // 9. 채팅방 내 특정 유저의 마지막 방문 시간 조회
    public Date selectLastVisitTime(ChatParticipantVO participant) {
        return sqlSession.selectOne("chatMapper.selectLastVisitTime", participant);
    }

    // 10. 특정 채팅방에서 특정 유저가 읽지 않은 메시지 수 조회
    public int selectUnreadMessageCount(Map<String, Object> params) {
        return sqlSession.selectOne("chatMapper.selectUnreadMessageCount", params);
    }

    // **추가된 메서드:** 다른 유저 ID 조회
    public String selectOtherParticipantId(Map<String, Object> params) {
        return sqlSession.selectOne("chatMapper.selectOtherParticipantId", params);
    }

    // **추가된 메서드:** 유저 이름 조회
    public String selectUserNameByUserId(String userId) {
        return sqlSession.selectOne("chatMapper.selectUserNameByUserId", userId);
    }
}