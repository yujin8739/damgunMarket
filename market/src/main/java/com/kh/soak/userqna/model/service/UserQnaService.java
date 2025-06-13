package com.kh.soak.userqna.model.service;

import java.util.List;

import com.kh.soak.userqna.model.vo.UserQnaInfo;

public interface UserQnaService {
    
    // 문의사항 전체 목록 조회
    List<UserQnaInfo> selectUserQnaList();
    
    // 문의사항 상세 조회
    UserQnaInfo selectUserQna(int userQnaNum);
    
    // 문의사항 등록
    int insertUserQna(UserQnaInfo userQna);
    
    // 문의사항 수정
    int updateUserQna(UserQnaInfo userQna);
    
    // 문의사항 삭제
    int deleteUserQna(int userQnaNum);
    
    // 특정 유저의 문의사항 목록 조회
    List<UserQnaInfo> selectUserQnaByUser(int userNo);
    
    // 신고 문의사항 목록 조회
    List<UserQnaInfo> selectReportQna(int exuserNum);
    
    // 문의사항 검색
    List<UserQnaInfo> searchUserQna(String keyword);
    
    // 사용자의 최근 문의번호 조회
    Integer selectLatestUserQnaNum(int userNo);
}