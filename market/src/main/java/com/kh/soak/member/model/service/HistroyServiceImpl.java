package com.kh.soak.member.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

import com.kh.soak.member.model.dao.TradeHistoryDao;
import com.kh.soak.member.model.vo.TradeHistory;

public class HistroyServiceImpl implements HistroyService {
	
	@Autowired
	private TradeHistoryDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession; 
	
	@Override
	public List<TradeHistory> myHistory(int user_No) {
		return dao.myHistory(sqlSession, user_No);
	}
	
	@Override
	public TradeHistory selectHistory(int pd_Num) {
		return dao.selectHistory(sqlSession, pd_Num);
	}

}
