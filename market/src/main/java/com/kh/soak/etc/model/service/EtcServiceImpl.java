package com.kh.soak.etc.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.soak.etc.model.dao.EtcDao;
import com.kh.soak.etc.model.vo.Station;
import com.kh.soak.product.model.vo.Product;

@Transactional
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
	
	@Override
	public List<Station> selectPdStationList(int pdNum, int userNo) {
		return dao.selectPdStationList(sqlSession, pdNum, userNo);
	}
	
	@Override
	public int insertPoint(int userNo, int point) {
		return dao.insertPoint(sqlSession, userNo, point);
	}

	@Override
	public int chargePoint(String userId, int point) {
		return dao.chargePoint(sqlSession, userId, point);
	}

}
