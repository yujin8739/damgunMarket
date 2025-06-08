package com.kh.soak.chat.model.vo;

import java.util.Date; // Date 필드를 위해 import 필요

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class MessageVO {
    private int no;            // 메시지 번호 (ROOMNO와 복합 PK)
    private int roomNo;        // 채팅방 번호 (FK)
    private String message;    // 메시지 내용
    private String imageUrl;   // 이미지 URL (NULL 허용)
    private String userId;     // 메시지를 보낸 유저 아이디 (FK)
    private Date sendTime;     // 보낸 시간 (DB: DATE)
    private String type;       // 메시지 타입 (e.g., "enter", "chat", "image") <--- 이 필드 추가
}