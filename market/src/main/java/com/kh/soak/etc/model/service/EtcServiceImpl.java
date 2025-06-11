package com.kh.soak.etc.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.soak.etc.model.dao.EtcDao;
import com.kh.soak.etc.model.vo.Station;
import com.kh.soak.product.model.vo.Product;

@Service
public class EtcServiceImpl implements EtcService {

	@Autowired
	private EtcDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<String> selectBigCateList() {   
		return dao.selectBigCateList(sqlSession);
	}

	@Override
	public List<Product> selectMidCateList(String bigCate) {
		return dao.selectMidCateList(sqlSession,bigCate);
	}

	@Override
	public List<Product> selectSmallCateList(String bigCate, String midCate) {
		return dao.selectSmallCateList(sqlSession, bigCate, midCate);
	}

	@Override
	public List<Station> selectNearStations(double lat, double lng) {
		return dao.selectNearStations(sqlSession, lat, lng);
	}
	

}
