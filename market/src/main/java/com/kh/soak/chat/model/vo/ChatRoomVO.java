package com.kh.soak.chat.model.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.Date; // Date 타입 추가

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class ChatRoomVO {
    private int roomNo;        // 채팅방번호 (CHAT_ROOM_SEQ)
    // DB에서 ROOM_NO만 PK이므로, 이 userId는 방의 특정 대표 유저 (예: 개설자)를 의미할 수 있습니다.
    // 1:1 채팅방의 경우, 이 테이블만으로는 상대방을 직접 알 수 없으므로,
    // Message 테이블을 JOIN하여 참여자를 유추하거나 별도의 참여자 테이블이 필요할 수 있습니다.
    private String userId;     // 유저아이디 (예: 방 생성자 또는 해당 방의 주요 참가자)
    private Date lastVisit;    // 마지막 방문 (DB는 VARCHAR2지만 Java에서는 Date로 관리 권장)
    private String chatType;   // 채팅타입 (예: TEXT, IMAGE 등)

    // DB의 VARCHAR2 타입 LASTVISIT을 Date로 매핑하기 위한 오버로드된 생성자 (선택 사항)
    // MyBatis에서 직접 Date로 매핑해줄 수 있다면 필요 없을 수도 있습니다.
    // public ChatRoomVO(int roomNo, String userId, String lastVisitString, String chatType) {
    //     this.roomNo = roomNo;
    //     this.userId = userId;
    //     this.chatType = chatType;
    //     try {
    //         if (lastVisitString != null && !lastVisitString.equals("0")) { // '0'은 초기값으로 보임
    //             SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
    //             this.lastVisit = sdf.parse(lastVisitString);
    //         } else {
    //             this.lastVisit = null; // 또는 new Date(); 등 적절한 초기값
    //         }
    //     } catch (ParseException e) {
    //         e.printStackTrace(); // 날짜 파싱 오류 처리
    //         this.lastVisit = null;
    //     }
    // }
}