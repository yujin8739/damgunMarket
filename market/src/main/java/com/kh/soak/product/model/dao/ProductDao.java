package com.kh.soak.product.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.soak.product.model.vo.Product;





@Repository
public class ProductDao {
	

	public Product selectProduct(SqlSessionTemplate sqlSession, int userNo, int pdNum) {
		return null;
	}
}
