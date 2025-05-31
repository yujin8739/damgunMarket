package com.kh.soak.history.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.soak.member.model.vo.Member;
import com.kh.soak.history.model.vo.TradeHistory;

@Repository

public class TradeHistoryDao {
	// 내 기록 찾기
	public List<TradeHistory> myHistory(SqlSessionTemplate sqlSession, int userNo) {
		List<TradeHistory> tradeHistory = sqlSession.selectList("historyMapper.myHistory",userNo);
		return tradeHistory; 
		
	}
	// 원하는 상품 보기
	public TradeHistory selectHistory(SqlSessionTemplate sqlSession, int pdNum) {
		TradeHistory tradeHistory = sqlSession.selectOne("historyMapper.selectHistory",pdNum);
		return tradeHistory; 
	}
	
	public int insertHistory(SqlSessionTemplate sqlSession, TradeHistory t) {
		return sqlSession.insert("historyMapper.insertHistory", t);
	}
}
