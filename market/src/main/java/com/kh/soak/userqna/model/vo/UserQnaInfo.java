package com.kh.soak.userqna.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class UserQnaInfo {
    private int userQnaNum;     // USERQNA_NUM NUMBER(11) - 문의번호
    private int userNo;         // USER_NO NUMBER(11) - 유저번호
    private String userQnaTitle; // USERQNA_TITLE VARCHAR2(255) - 문의제목
    private String userQna;     // USERQNA CLOB - 문의내용
    private String userQnaImg;  // USERQNA_IMG VARCHAR2(255) - 문의이미지
    private String status; // STATUS - 답변여부
}