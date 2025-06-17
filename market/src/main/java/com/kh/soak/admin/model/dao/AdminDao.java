package com.kh.soak.admin.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.soak.admin.model.vo.Admin;

@Repository
public class AdminDao {
    
    // 관리자 로그인
    public Admin loginAdmin(SqlSessionTemplate sqlSession, Admin admin) {
    	
        return sqlSession.selectOne("adminMapper.loginAdmin", admin);
    }
    /*
    // 관리자 정보 수정
    public int updateAdmin(SqlSessionTemplate sqlSession, Admin admin) {
        return sqlSession.update("adminMapper.updateAdmin", admin);
    }
    */
    // 관리자 삭제
    public int deleteAdmin(SqlSessionTemplate sqlSession, Admin admin) {
        return sqlSession.delete("adminMapper.deleteAdmin", admin);
    }
    /*
    // 관리자 아이디 중복 확인
    public int idCheck(SqlSessionTemplate sqlSession, String adminId) {
        return sqlSession.selectOne("adminMapper.idCheck", adminId);
    }
    */
    // 관리자 번호로 조회
    public Admin selectAdminByNum(SqlSessionTemplate sqlSession, int adminNum) {
        return sqlSession.selectOne("adminMapper.selectAdminByNum", adminNum);
    }
}