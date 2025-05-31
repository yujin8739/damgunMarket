package com.kh.soak.chat.model.vo;

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
public class ChatRoomVO {
    private int roomNo;           // 채팅방번호
    private String userId;        // 유저아이디
    private String lastVisit;     // 마지막 방문 (형식: ABC123(날짜)@TEST123(날짜))
    private String chatType;      // 채팅타입 (예: TEXT, IMAGE 등)
    
//    컬럼타입      		   널에이블   컬럼아이디  	코멘트
    
//    NUMBER(11,0)			No		1			채팅방번호
//    VARCHAR2(255 BYTE)	No		2			유저 ID(ABC123@TEST123)
//    VARCHAR2(255 BYTE)	No		3			마지막방문 EX)ABC123(날짜시간)@TEST123(날짜시간)
//    VARCHAR2(20 BYTE)		No		4			채팅타입(이미지 채팅인지 일반 채팅인지)
//    
}
