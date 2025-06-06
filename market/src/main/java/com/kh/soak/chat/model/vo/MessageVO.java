package com.kh.soak.chat.model.vo;

import java.util.Date; // java.sql.Timestamp 대신 java.util.Date 사용 (JSON 직렬화/역직렬화에 더 용이)

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
    private int no;            // 메시지 번호 (CHAT_MESSAGE_SEQ)
    private int roomNo;        // 채팅방 번호 (FK)
    private String message;    // 메시지 내용
    private String imageUrl;   // 이미지 URL (이미지 메시지일 경우)
    private String userId;     // 보낸 유저 아이디
    private Date sendTime;     // 보낸 시간 (DB는 SYSDATE, Java는 Date 객체)
    private String type;       // 메시지 타입 (예: "enter", "chat", "image")
}