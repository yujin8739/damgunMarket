package com.kh.soak.history.model.service;

import java.util.List;
import com.kh.soak.history.model.vo.TradeHistory;

public interface HistroyService {

	List<TradeHistory> myHistory(int user_No);

	TradeHistory selectHistory(int pd_Num);

	int insertMyHistory(TradeHistory t);

}
