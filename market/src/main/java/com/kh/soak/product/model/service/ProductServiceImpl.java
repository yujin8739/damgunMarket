package com.kh.soak.product.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.soak.product.model.dao.ProductDao;
import com.kh.soak.product.model.vo.PdFile;
import com.kh.soak.product.model.vo.Product;

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

	@Override
	public List<Product> searchAllProduct(RowBounds rowBounds) {
		return dao.selectAllProdectList(sqlSession,rowBounds);
	}

	@Override
	public List<Product> searchProduct(RowBounds rowBounds, String keyword) {
		return dao.selectProducts(sqlSession, rowBounds, keyword);
	}

	@Override
	public Product selectOneProduct(int pdNum, int userNo) {
		return dao.selectOneProduct(sqlSession, pdNum,userNo);
	}

	@Override
	public List<String> selectFiles(int pdNum, int userNo) {
		return dao.selectFiles(sqlSession, pdNum, userNo);
	}

	@Override
	public int insertProduct(Product product) {
		return dao.insertProduct(sqlSession, product);
	}

	@Override
	public int insertPdFiles(PdFile pdFiles) {
		return dao.insertPdFiles(sqlSession,pdFiles);
	}

	@Override
	public int insertPdStation(int userNo, int pdNum, int stationNo) {
		return dao.insertPdStation(sqlSession,userNo,pdNum,stationNo);
	}

	@Override
	public List<Object> favoriteList(int userNo, RowBounds rowBounds) {
		return dao.favoriteList(sqlSession, userNo, rowBounds);
	}

}
