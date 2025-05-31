package com.kh.soak.member.model.service;

import java.util.List;

import com.kh.soak.member.model.vo.TradeHistory;

public interface HistroyService {

	List<TradeHistory> myHistory(int user_No);

	TradeHistory selectHistory(int pd_Num);

}
