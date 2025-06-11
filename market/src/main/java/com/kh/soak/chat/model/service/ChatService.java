package com.kh.soak.chat.model.service;

import java.util.List;
import java.util.Map;

import com.kh.soak.chat.model.vo.ChatParticipantVO;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;

public interface ChatService {

    // 1. 1:1 채팅방 생성 또는 입장
    // - 이미 방이 있으면 기존 방 리턴, 없으면 새로 생성 후 리턴
    ChatRoomVO getOrCreateChatRoom(String user1Id, String user2Id);

    // 2. 특정 유저가 참여하는 채팅방 목록 조회
    List<ChatRoomVO> getChatRoomsByUserId(String userId);

    // 3. 채팅방 입장 시 마지막 방문 시간 업데이트
    int updateLastVisit(ChatParticipantVO participant);

    // 4. 특정 채팅방의 메시지 목록 조회
    List<MessageVO> getMessagesByRoomNo(int roomNo);

    // 5. 메시지 전송
    int insertMessage(MessageVO message); // MessageVO 객체 안에 fileType 필드가 포함되어 넘어옴

    // 6. 특정 채팅방 정보 조회
    ChatRoomVO getChatRoomByRoomNo(int roomNo);

    // 7. 특정 채팅방에서 특정 유저가 읽지 않은 메시지 수 조회
    int getUnreadMessageCount(int roomNo, String userId);
    
    // 새롭게 추가된 메서드들: Controller에서 직접 DAO를 호출하는 대신 Service를 통해 호출
    String selectOtherParticipantId(Map<String, Object> params);
    String selectUserNameByUserId(String userId);
}