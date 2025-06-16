package com.kh.soak.history.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.soak.history.model.dao.TradeHistoryDao;
import com.kh.soak.history.model.vo.TradeHistory;
import com.kh.soak.product.model.vo.Product;

@Service
@Transactional
public class HistroyServiceImpl implements HistroyService {
	
	@Autowired
	private TradeHistoryDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<TradeHistory> myHistory(int user_No) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public TradeHistory selectHistory(int pd_Num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int insertMyHistory(TradeHistory t) {
		// TODO Auto-generated method stub
		return 0;
	} 
}
