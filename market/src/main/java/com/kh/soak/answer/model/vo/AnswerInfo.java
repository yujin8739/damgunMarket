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
    private String answerQna;   // ANSWER_QNA CLOB - 답변내용
    private String adminName;   // ADMIN_NAME VARCHAR2(20) - 관리자이름
    
    // 문의사항 정보도 함께 담기 위한 필드들 (JOIN 시 사용)
    private String userQnaTitle; // USERQNA_TITLE VARCHAR2(255) - 문의제목
    private String userQna;      // USERQNA CLOB - 문의내용
    private String userQnaImg;   // USERQNA_IMG VARCHAR2(255) - 문의이미지
//    private int exuserNum;  // EXUSER_NUM
//    private int pdNum;      // PD_NUM
}