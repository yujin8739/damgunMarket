package com.kh.soak.etc.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.soak.etc.model.vo.Station;
import com.kh.soak.product.model.vo.Product;

@Repository
public class EtcDao {

	public List<String> selectBigCateList(SqlSessionTemplate sqlSession) {
		return sqlSession.selectList("etcMapper.bigCateList");
	}

	public List<Product> selectMidCateList(SqlSessionTemplate sqlSession, String bigCate) {
		return sqlSession.selectList("etcMapper.midCateList", bigCate);
	}

	public List<Product> selectSmallCateList(SqlSessionTemplate sqlSession, String bigCate, String midCate) {
		Map<String, Object> param = new HashMap<>();
		param.put("midCate", midCate);
		param.put("bigCate", bigCate);
		return sqlSession.selectList("etcMapper.smallCateList", param);
	}

	public List<Station> selectNearStations(SqlSessionTemplate sqlSession, double lat, double lng) {
		Map<String, Object> param = new HashMap<>();
		param.put("lat", lat);
		param.put("lng", lng);
		return sqlSession.selectList("etcMapper.selectNearStations", param);
	}
	
	public List<Station> selectPdStationList(SqlSessionTemplate sqlSession, int pdNum, int userNo) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("pdNum", pdNum);
		return sqlSession.selectList("etcMapper.selectPdStationList", param);
	}

	public int insertPoint(SqlSessionTemplate sqlSession, int userNo, int point) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNo", userNo);
		param.put("point", point);
		return sqlSession.update("memberMapper.insertPoint",param);
	}

	public int chargePoint(SqlSessionTemplate sqlSession, String userId, int point) {
		Map<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("point", point);
		return sqlSession.update("memberMapper.chargePoint",param);
	}
}
