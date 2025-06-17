package com.kh.soak.board.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Board {
    private int noticeNum;      // NOTICE_NUM NUMBER(11) - 공지번호
    private String noticeTitle; // NOTICE_TITLE VARCHAR2(255) - 공지제목
    private String notice;      // NOTICE CLOB - 공지내용
    private Date createdate;    // CREATEDATE DATE - 작성일 
}