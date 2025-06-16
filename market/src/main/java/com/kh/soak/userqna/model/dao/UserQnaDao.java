package com.kh.soak.userqna.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.soak.userqna.model.vo.UserQnaInfo;

@Repository
public class UserQnaDao {
    
    // 문의사항 전체 목록 조회
    public List<UserQnaInfo> selectUserQnaList(SqlSessionTemplate sqlSession) {
        return sqlSession.selectList("userQnaMapper.selectUserQnaList");
    }
    
    // 문의사항 상세 조회
    public UserQnaInfo selectUserQna(SqlSessionTemplate sqlSession, int userQnaNum) {
        return sqlSession.selectOne("userQnaMapper.selectUserQna", userQnaNum);
    }
    
    // 문의사항 등록
    public int insertUserQna(SqlSessionTemplate sqlSession, UserQnaInfo userQna) {
        return sqlSession.insert("userQnaMapper.insertUserQna", userQna);
    }
    
    // 문의사항 수정
    public int updateUserQna(SqlSessionTemplate sqlSession, UserQnaInfo userQna) {
        return sqlSession.update("userQnaMapper.updateUserQna", userQna);
    }
    
    // 문의사항 삭제 - 파라미터를 int로 받음
    public int deleteUserQna(SqlSessionTemplate sqlSession, int userQnaNum) {
        return sqlSession.delete("userQnaMapper.deleteUserQna", userQnaNum);
    }
    
    // 특정 유저의 문의사항 목록 조회
    public List<UserQnaInfo> selectUserQnaByUser(SqlSessionTemplate sqlSession, int userNo) {
        return sqlSession.selectList("userQnaMapper.selectUserQnaByUser", userNo);
    }
    
    // 문의사항 검색
    public List<UserQnaInfo> searchUserQna(SqlSessionTemplate sqlSession, String keyword) {
        return sqlSession.selectList("userQnaMapper.searchUserQna", keyword);
    }
    
    // 사용자의 최근 문의번호 조회
    public Integer selectLatestUserQnaNum(SqlSessionTemplate sqlSession, int userNo) {
        return sqlSession.selectOne("userQnaMapper.selectLatestUserQnaNum", userNo);
    }
}