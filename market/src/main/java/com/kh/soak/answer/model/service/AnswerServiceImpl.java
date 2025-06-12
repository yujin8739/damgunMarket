package com.kh.soak.answer.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.soak.answer.model.dao.AnswerDao;
import com.kh.soak.answer.model.vo.AnswerInfo;

@Service
public class AnswerServiceImpl implements AnswerService {
    
    @Autowired
    private AnswerDao dao;
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    @Override
    public List<AnswerInfo> selectAnswerList() {
        return dao.selectAnswerList(sqlSession);
    }
    
    @Override
    public AnswerInfo selectAnswer(int userQnaNum) {
        return dao.selectAnswer(sqlSession, userQnaNum);
    }
    
    @Override
    public int insertAnswer(AnswerInfo answer) {
        return dao.insertAnswer(sqlSession, answer);
    }
    
    @Override
    public int updateAnswer(AnswerInfo answer) {
        return dao.updateAnswer(sqlSession, answer);
    }
    
    @Override
    public int deleteAnswer(int userQnaNum) {
        return dao.deleteAnswer(sqlSession, userQnaNum);
    }
    
    @Override
    public List<AnswerInfo> selectAnswersByUser(int userNo) {
        return dao.selectAnswersByUser(sqlSession, userNo);
    }
    
    @Override
    public List<AnswerInfo> selectAnswersByProduct(int productNum) {
        return dao.selectAnswersByProduct(sqlSession, productNum);
    }
}