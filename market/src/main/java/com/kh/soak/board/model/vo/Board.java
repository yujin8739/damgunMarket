package com.kh.soak.board.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Board {
    private int noticeNum;      // NOTICE_NUM NUMBER(11) - 공지번호
    private String noticeTitle; // NOTICE_TITLE VARCHAR2(255) - 공지제목
    private String noticeContent; // NOTICE_CONTENT CLOB - 공지내용
    private String noticeImg;   // NOTICE_IMG VARCHAR2(255) - 공지이미지
}