package com.kh.soak.chat.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;

@Repository
public class ChatDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    // 채팅방 생성
    public int insertChatRoom(ChatRoomVO room) {
        return sqlSession.insert("chatMapper.insertChatRoom", room);
    }

    // 특정 채팅방 정보 조회 (방 번호로)
    public ChatRoomVO selectChatRoomById(int roomNo) {
        return sqlSession.selectOne("chatMapper.selectChatRoomById", roomNo);
    }

    // 특정 유저가 참여한 채팅방 목록 조회
    public List<ChatRoomVO> selectChatRoomsByUserId(String userId){
        return sqlSession.selectList("chatMapper.selectChatRoomsByUserId", userId);
    }
    
    // 채팅방 마지막 방문 시간 업데이트
    public int updateLastVisit(ChatRoomVO room) {
        return sqlSession.update("chatMapper.updateLastVisit", room);
    }

    // 메시지 저장
    public int insertMessage(MessageVO message) {
        return sqlSession.insert("chatMapper.insertMessage", message);
    }

    // 특정 채팅방의 메시지 목록 조회
    public List<MessageVO> selectMessagesByRoomNo(int roomNo) {
        return sqlSession.selectList("chatMapper.selectMessagesByRoomNo", roomNo);
    }

    // (중요) CHAT_ROOM_SEQ의 다음 번호 가져오기
    public int getNextChatRoomNo() {
        return sqlSession.selectOne("chatMapper.getNextChatRoomNo");
    }
}