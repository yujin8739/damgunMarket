package com.kh.soak.chat.model.vo;

import java.util.Date;

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
    private int no;               // 메시지 번호
    private int roomNo;           // 채팅방 번호 (FK)
    private String message;       // 메시지 내용
    private String imageUrl;      // 이미지 URL
    private String userId;        // 보낸 유저 아이디
    private Date sendTime;        // 보낸 시간
//    컬럼타입      		   널에이블   컬럼아이디  	코멘트
    
//    NUMBER(11,0)			No		1			채팅방번호
//    NUMBER(11,0)			No		2			메시지번호
//    CLOB					No		3			메시지내용
//    VARCHAR2(255 BYTE)	No		4			이미지URL
//    VARCHAR2(255 BYTE)	No		5			보낸사람아이디
//    DATE					No		6			보낸 시간
}
