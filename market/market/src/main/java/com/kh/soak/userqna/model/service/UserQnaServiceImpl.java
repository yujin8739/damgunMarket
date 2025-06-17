package com.kh.soak.userqna.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.soak.userqna.model.dao.UserQnaDao;
import com.kh.soak.userqna.model.vo.UserQnaInfo;

@Service
public class UserQnaServiceImpl implements UserQnaService {
    
    @Autowired
    private UserQnaDao dao;
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    @Override
    public List<UserQnaInfo> selectUserQnaList() {
        return dao.selectUserQnaList(sqlSession);
    }
    
    @Override
    public UserQnaInfo selectUserQna(int userQnaNum) {
        return dao.selectUserQna(sqlSession, userQnaNum);
    }
    
    @Transactional
    @Override
    public int insertUserQna(UserQnaInfo userQna) {
        System.out.println("Service - insertUserQna 호출: " + userQna);
        int result = dao.insertUserQna(sqlSession, userQna);
        System.out.println("Service - insertUserQna 결과: " + result);
        return result;
    }
    
    @Transactional
    @Override
    public int updateUserQna(UserQnaInfo userQna) {
        return dao.updateUserQna(sqlSession, userQna);
    }
    
    @Transactional
    @Override
    public int deleteUserQna(int userQnaNum) {
        return dao.deleteUserQna(sqlSession, userQnaNum);
    }
    
    @Override
    public List<UserQnaInfo> selectUserQnaByUser(int userNo) {
        return dao.selectUserQnaByUser(sqlSession, userNo);
    }

    
    @Override
    public List<UserQnaInfo> searchUserQna(String keyword) {
        return dao.searchUserQna(sqlSession, keyword);
    }
    @Override
    public Integer selectLatestUserQnaNum(int userNo) {
        return dao.selectLatestUserQnaNum(sqlSession, userNo);
    }
}