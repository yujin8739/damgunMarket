package com.kh.soak.product.model.service;

import java.util.List;

import org.apache.ibatis.session.RowBounds;

import com.kh.soak.product.model.vo.Product;

public interface ProductService {

	int tradeItem(int pdNum);

	List<Product> searchAllProduct(RowBounds rowBounds);
	List<Product> searchProduct(RowBounds rowBounds, String keyword);

}
