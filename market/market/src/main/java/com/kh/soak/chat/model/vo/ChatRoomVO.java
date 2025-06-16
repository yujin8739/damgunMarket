package com.kh.soak.chat.model.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class ChatRoomVO {
    private int roomNo;        // 채팅방번호 (PK)
    private String chatType;    // 채팅타입 (TEXT, IMAGE 등)
    private Date createdDate;   // 방 생성일시 (DB: DATE 타입)
    private Date lastVisit;     // 현재 로그인한 유저의 이 방 마지막 방문 시간 (채팅방 목록 조회 시 사용)
    private String otherUserId; // 1:1 채팅 시 상대방 ID (편의상 추가, DB 컬럼 아님)
    private String otherUserName; // 1:1 채팅 시 상대방 이름 (편의상 추가, DB 컬럼 아님)
    // private int unreadMessageCount; // 필요하다면 추가 (JSP에서 사용)
}