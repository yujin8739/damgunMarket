package com.kh.soak.product.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.soak.product.model.vo.PdFile;
import com.kh.soak.product.model.vo.Product;


@Repository
public class ProductDao {
	

	public Product selectProduct(SqlSessionTemplate sqlSession, int userNo, int pdNum) {
		return null;
	}

	public int tradeItem(SqlSessionTemplate sqlSession, int pdNum) {
		return sqlSession.update("productMapper.upDateStatus",pdNum);
	}

	public List<Product> selectAllProdectList(SqlSessionTemplate sqlSession, RowBounds rowBounds) {
		return sqlSession.selectList("productMapper.selectAllProducts", null, rowBounds);
	}

	public List<Product> selectProducts(SqlSessionTemplate sqlSession, RowBounds rowBounds, String keyword) {
		return sqlSession.selectList("productMapper.selectProducts", keyword, rowBounds);
	}

	public Product selectOneProduct(SqlSessionTemplate sqlSession, int pdNum, int userNo) {
		//selectOne은 하나의 파라미터만 전달 가능하기 때문에 HashMap으로 묶어서 전달
	    Map<String, Object> param = new HashMap<>();
	    param.put("pdNum", pdNum);
	    param.put("userNo", userNo);
		return sqlSession.selectOne("productMapper.selectOneProduct",param);
	}
	
	public List<String> selectFiles(SqlSession sqlSession, int pdNum, int userNo) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("pdNum", pdNum);
	    param.put("userNo", userNo);
		return sqlSession.selectList("productMapper.selectFileList", param);
	}

	public int insertProduct(SqlSessionTemplate sqlSession, Product product) {
		return sqlSession.insert("productMapper.insertProduct", product);
	}
	
	public int insertPdFiles(SqlSessionTemplate sqlSession, PdFile pdFile) {
		return sqlSession.insert("productMapper.insertProductFile", pdFile);
	}

	public int insertPdStation(SqlSessionTemplate sqlSession, int userNo, int pdNum, int stationNo) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("pdNum", pdNum);
		param.put("stationNo", stationNo);
		return sqlSession.insert("productMapper.insertPdStation", param);
	}
}
