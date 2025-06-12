package com.kh.soak.answer.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AnswerInfo {
    private int userQnaNum;     // USERQNA_NUM NUMBER(11) - 유저문의번호
    private int userNo;         // USER_NO NUMBER(11) - 유저번호
    private String answerTitle; // ANSWER_TITLE VARCHAR2(255) - 답변제목
    private String answerQna; // ANSWER_CNA CLOB - 답변내용
    private String answerImg;   // ANSWER_IMG VARCHAR2(255) - 답변이미지
    private int productNum;     // PRODUCT_NUM NUMBER(11) - 상품번호
    private String adminName;   // ADMIN_NAME VARCHAR2(20) - 관리자이름
}