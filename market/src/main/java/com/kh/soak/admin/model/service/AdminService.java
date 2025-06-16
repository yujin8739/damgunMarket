package com.kh.soak.admin.model.service;

import com.kh.soak.admin.model.vo.Admin;

public interface AdminService {
    
    // 관리자 로그인
    Admin loginAdmin(Admin admin);
    
    // 관리자 정보 수정
    int updateAdmin(Admin admin);
    
    // 관리자 삭제
    int deleteAdmin(Admin admin);
    
    // 관리자 아이디 중복 확인
    int idCheck(String adminId);
    
    // 관리자 번호로 조회
    Admin selectAdminByNum(int adminNum);
}