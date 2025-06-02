package com.kh.soak.product.model.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.soak.product.model.dao.ProductDao;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {
	@Autowired
	private ProductDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public int tradeItem(int pdNum) {
		return dao.tradeItem(sqlSession, pdNum);
	}
	

}
