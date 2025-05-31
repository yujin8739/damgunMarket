package com.kh.soak.history.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import com.kh.soak.history.model.dao.TradeHistoryDao;
import com.kh.soak.history.model.vo.TradeHistory;


public class HistroyServiceImpl implements HistroyService {
	
	@Autowired
	private TradeHistoryDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession; 
	
	@Override
	public List<TradeHistory> myHistory(int userNo) {
		return dao.myHistory(sqlSession, userNo);
	}
	
	@Override
	public TradeHistory selectHistory(int pdNum) {
		return dao.selectHistory(sqlSession, pdNum);
	}
	
	@Override
	public int insertMyHistory(TradeHistory t) {
		return dao.insertHistory(sqlSession, t);
	}

}
