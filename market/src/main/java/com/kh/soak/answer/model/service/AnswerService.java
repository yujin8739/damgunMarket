package com.kh.soak.answer.model.service;

import java.util.List;

import com.kh.soak.answer.model.vo.AnswerInfo;

public interface AnswerService {
    
    // 답변 전체 목록 조회
    List<AnswerInfo> selectAnswerList();
    
    // 답변 상세 조회
    AnswerInfo selectAnswer(int userQnaNum);
    
    // 답변 등록
    int insertAnswer(AnswerInfo answer);
    
    // 답변 수정
    int updateAnswer(AnswerInfo answer);
    
    // 답변 삭제
    int deleteAnswer(int userQnaNum);
    
    // 유저별 답변 목록 조회
    List<AnswerInfo> selectAnswersByUser(int userNo);
    
    // 상품별 답변 목록 조회 (pdNum 사용)
    List<AnswerInfo> selectAnswersByProduct(int pdNum);
    
    // 답변 존재 여부 확인
    boolean hasAnswer(int userQnaNum);
    
}