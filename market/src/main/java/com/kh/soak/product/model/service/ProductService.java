package com.kh.soak.product.model.service;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;

import com.kh.soak.product.model.vo.PdFile;
import com.kh.soak.product.model.vo.Product;

public interface ProductService {

	int tradeItem(int pdNum);
	List<Product> searchAllProduct(RowBounds rowBounds);
	List<Product> searchProduct(RowBounds rowBounds, String keyword);
	Product selectOneProduct(int pdNum, int userNo);
	List<String> selectFiles(int pdNum, int userNo);
	int insertProduct(Product product);
	int insertPdFiles(PdFile pdFiles);
}
