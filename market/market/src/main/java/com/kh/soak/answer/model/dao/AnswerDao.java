package com.kh.soak.answer.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.soak.answer.model.vo.AnswerInfo;

@Repository
public class AnswerDao {
    
    // 답변 전체 목록 조회
    public List<AnswerInfo> selectAnswerList(SqlSessionTemplate sqlSession) {
        return sqlSession.selectList("answerMapper.selectAnswerList");
    }
    
    // 답변 상세 조회
    public AnswerInfo selectAnswer(SqlSessionTemplate sqlSession, int userQnaNum) {
        return sqlSession.selectOne("answerMapper.selectAnswer", userQnaNum);
    }
    
    // 답변 등록
    public int insertAnswer(SqlSessionTemplate sqlSession, AnswerInfo answer) {
        return sqlSession.insert("answerMapper.insertAnswer", answer);
    }
    
    // 답변 수정
    public int updateAnswer(SqlSessionTemplate sqlSession, AnswerInfo answer) {
        return sqlSession.update("answerMapper.updateAnswer", answer);
    }
    
    // 답변 삭제
    public int deleteAnswer(SqlSessionTemplate sqlSession, int userQnaNum) {
        return sqlSession.delete("answerMapper.deleteAnswer", userQnaNum);
    }
    
    // 유저별 답변 목록 조회
    public List<AnswerInfo> selectAnswersByUser(SqlSessionTemplate sqlSession, int userNo) {
        return sqlSession.selectList("answerMapper.selectAnswersByUser", userNo);
    }
    
    // 답변 존재 여부 확인
    public boolean hasAnswer(SqlSessionTemplate sqlSession, int userQnaNum) {
        Integer count = sqlSession.selectOne("answerMapper.hasAnswer", userQnaNum);
        return count != null && count > 0;
    }
    
    // QNA 번호로 답변 조회
    public AnswerInfo selectAnswerByQnaNum(SqlSessionTemplate sqlSession, int userQnaNum) {
        return sqlSession.selectOne("answerMapper.selectAnswerByQnaNum", userQnaNum);
    }
}