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
		//selectOn
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

	
	public int deleteProduct(SqlSessionTemplate sqlSession, int pdNum, int userNo) {
		
	    //(deleteProductFilesByPdNumUserNo, deleteProductByPdNumUserNo)
	    int fileDeleteCount = sqlSession.delete("productMapper.deleteProductFilesByPdNumUserNo", Map.of("pdNum", pdNum, "userNo", userNo));
	    int productDeleteCount = sqlSession.delete("productMapper.deleteProductByPdNumUserNo", Map.of("pdNum", pdNum, "userNo", userNo));
	    
	    return productDeleteCount > 0 ? 1 : 0;
	}
	


	public int insertPdStation(SqlSessionTemplate sqlSession, int userNo, int pdNum, int stationNo) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("pdNum", pdNum);
		param.put("stationNo", stationNo);
		return sqlSession.insert("productMapper.insertPdStation", param);
	}
	
	public int updateProductByPdNumUserNo(SqlSessionTemplate sqlSession, Product product) {
		return sqlSession.update("productMapper.updateProductByPdNumUserNo", product);
	}

	public List<Object> favoriteList(SqlSessionTemplate sqlSession, int userNo,RowBounds rowBounds) {
		return sqlSession.selectList("productMapper.selectFavoriteList", userNo, rowBounds);
	}

	public List<Object> selectMyPdList(SqlSessionTemplate sqlSession, RowBounds rowBounds, int userNo) {
		return sqlSession.selectList("productMapper.selectMyPdList", userNo, rowBounds);
	}
	
	public String checkPdEnroll(SqlSessionTemplate sqlSession, int pdNum, int userNo) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("pdNum", pdNum);
		return sqlSession.selectOne("productMapper.checkPdEnroll",param);
	}
	
	public String checkMyEnroll(SqlSessionTemplate sqlSession, int pdNum, int userNo, int enrollNo) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("pdNum", pdNum);
		param.put("enrollNo", enrollNo);
		return sqlSession.selectOne("productMapper.checkMyEnroll",param);
	}

	public int tradeEnroll(SqlSessionTemplate sqlSession, int pdNum, int userNo, int enrollNo, String status) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("pdNum", pdNum);
		param.put("enrollNo", enrollNo);
		param.put("status", status);
		return sqlSession.insert("productMapper.tradeEnroll",param);
	}
	
	public List<Product> selectHistoryList(SqlSessionTemplate sqlSession, int userNo, String status, RowBounds rowBounds){
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("status", status);
		return sqlSession.selectList("productMapper.selectHistoryList", param, rowBounds);
	}

	public int selectHistoryUpdate(SqlSessionTemplate sqlSession, int pdNum, int userNo, String enrollNo, String status) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("pdNum", pdNum);
		param.put("enrollNo", enrollNo);
		param.put("status", status);
		return sqlSession.update("productMapper.selectHistoryUpdate",param);
	}
}
