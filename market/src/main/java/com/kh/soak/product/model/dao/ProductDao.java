package com.kh.soak.product.model.dao;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

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
}
