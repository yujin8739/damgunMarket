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
public class ChatParticipantVO {
    private int roomNo;        // 채팅방 번호 (FK, PK)
    private String userId;     // 참여 유저 ID (FK, PK)
    private Date lastVisitTime; // 각 유저가 해당 방을 마지막으로 방문한 시간
}