package com.kh.soak.etc.model.service;

import java.util.List;

import com.kh.soak.etc.model.vo.Station;
import com.kh.soak.product.model.vo.Product;

public interface EtcService {

	List<String> selectBigCateList();

	List<Product> selectMidCateList(String bigCate);

	List<Product> selectSmallCateList(String bigCate, String midCate);

	List<Station> selectNearStations(double lat, double lng);

}
