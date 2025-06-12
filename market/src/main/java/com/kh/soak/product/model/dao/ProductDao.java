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
		//selectOne�� �븯�굹�쓽 �뙆�씪誘명꽣留� �쟾�떖 媛��뒫�븯湲� �븣臾몄뿉 HashMap�쑝濡� 臾띠뼱�꽌 �쟾�떖
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
	
}
