package com.kh.soak.product.model.service;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;

import com.kh.soak.product.model.vo.PdFile;
import com.kh.soak.product.model.vo.Product;

public interface ProductService {

	int tradeItem(int pdNum);
	List<Product> searchAllProduct(RowBounds rowBounds, double latitude, double longitude);
	List<Product> searchProduct(RowBounds rowBounds, String keyword, double latitude, double longitude);
	List<Product> searchCategory(RowBounds rowBounds, String category, double latitude, double longitude);
	List<Product> searchProduct(RowBounds rowBounds, String keyword, String category, double latitude, double longitude);
	Product selectOneProduct(int pdNum, int userNo);
	List<String> selectFiles(int pdNum, int userNo);
	int insertProduct(Product product);
	int insertPdFiles(PdFile pdFiles);

	
	int deleteProduct(int pdNum, int userNo);

	int insertPdStation(int userNo, int pdNum, int stationNo);

	//Product selectOneProduct(int pdNum, int userNo);
	int updateProductByPdNumUserNo(Product product);

	List<Object> favoriteList(int userNo, RowBounds rowBounds);
	Product editProduct(int pdNum);

	List<Object> selectMyPdList(RowBounds rowBounds, int List);
	
	String checkPdEnroll(int pdNum, int userNo);
	String checkEnroll(int pdNum, int userNo);
	String checkMyEnroll(int pdNum, int userNo, int enrollNo);
	int tradeEnroll(int pdNum, int userNo, int enrollNo, String status);
	List<Product> selectHistoryList(int userNo, String status, RowBounds rowBounds);
	List<Product> selectMyHistoryList(int userNo, String status, RowBounds rowBounds);
	int selectHistoryUpdate(int pdNum, int userNo, String enrollNo, String status);
    int deletePdFiles(int userNo, int pdNum);
	int increaseProductRank(int pdNum, int points);
}