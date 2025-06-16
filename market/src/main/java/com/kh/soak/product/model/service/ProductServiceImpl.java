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
	public List<Product> searchAllProduct(RowBounds rowBounds, double latitude, double longitude) {
		return dao.selectAllProductList(sqlSession,rowBounds, latitude, longitude);
	}

	@Override
	public List<Product> searchProduct(RowBounds rowBounds, String keyword, double latitude, double longitude) {
		return dao.selectProducts(sqlSession, rowBounds, keyword, latitude, longitude);
	}

	@Override
	public List<Product> searchCategory(RowBounds rowBounds, String category, double latitude, double longitude) {
		return dao.searchCategory(sqlSession, rowBounds, category, latitude, longitude);
	}

	@Override
	public List<Product> searchProduct(RowBounds rowBounds, String keyword, String category, double latitude, double longitude) {
		return dao.selectProducts(sqlSession, rowBounds, keyword, category, latitude, longitude);
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
	public int updateProductByPdNumUserNo(Product product) {
		return dao.updateProductByPdNumUserNo(sqlSession, product);
	}

	@Override
	public List<Object> favoriteList(int userNo, RowBounds rowBounds) {
		return dao.favoriteList(sqlSession, userNo, rowBounds);
	}
	
	
	@Override
	public int deleteProduct(int pdNum, int userNo) {
	    dao.deleteTradeStation(sqlSession, pdNum, userNo); // Dao 통해 처리
	    return dao.deleteProduct(sqlSession, pdNum, userNo); // 기존 삭제 로직 그대로 유지
	}
	
	@Override
	public Product editProduct(int pdNum) {
	    return dao.editProduct(sqlSession, pdNum);
	}
	
	
	

	@Override
	public List<Object> selectMyPdList(RowBounds rowBounds, int userNo) {
		return dao.selectMyPdList(sqlSession, rowBounds, userNo);
	}

	@Override
	public String checkPdEnroll(int pdNum, int userNo) {
		return dao.checkPdEnroll(sqlSession, pdNum, userNo);
	}

	@Override
	public String checkEnroll(int pdNum, int userNo) {
		return null;
	}
	
	@Override
	public String checkMyEnroll(int pdNum, int userNo, int enrollNo) {
		return dao.checkMyEnroll(sqlSession, pdNum, userNo, enrollNo);
	}

	@Override
	public int tradeEnroll(int pdNum, int userNo, int enrollNo, String status) {
		return dao.tradeEnroll(sqlSession, pdNum, userNo, enrollNo, status);
	}
	
	@Override
	public List<Product> selectHistoryList(int userNo, String status, RowBounds rowBounds){
		return dao.selectHistoryList(sqlSession, userNo, status, rowBounds);
	}

	@Override
	public int selectHistoryUpdate(int pdNum, int userNo, String enrollNo, String status) {
		return dao.selectHistoryUpdate(sqlSession, pdNum, userNo, enrollNo, status);
	}

	@Override
	public List<Product> selectMyHistoryList(int userNo, String status, RowBounds rowBounds) {
		return dao.selectyMyHistoryList(sqlSession, userNo, status, rowBounds);
	}

}
