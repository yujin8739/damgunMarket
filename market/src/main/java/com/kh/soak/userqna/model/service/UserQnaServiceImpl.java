package com.kh.soak.userqna.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
    
    @Override
    public int insertUserQna(UserQnaInfo userQna) {
        return dao.insertUserQna(sqlSession, userQna);
    }
    
    @Override
    public int updateUserQna(UserQnaInfo userQna) {
        return dao.updateUserQna(sqlSession, userQna);
    }
    
    @Override
    public int deleteUserQna(int userQnaNum) {
        return dao.deleteUserQna(sqlSession, userQnaNum);
    }
    
    @Override
    public List<UserQnaInfo> selectUserQnaByUser(int userNo) {
        return dao.selectUserQnaByUser(sqlSession, userNo);
    }
    
    @Override
    public List<UserQnaInfo> selectReportQna(int douserNum) {
        return dao.selectReportQna(sqlSession, douserNum);
    }
    
    @Override
    public List<UserQnaInfo> searchUserQna(String keyword) {
        return dao.searchUserQna(sqlSession, keyword);
    }
}