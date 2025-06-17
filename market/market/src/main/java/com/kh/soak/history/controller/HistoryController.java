package com.kh.soak.history.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.soak.history.model.service.HistroyService;
import com.kh.soak.history.model.vo.TradeHistory;

@Controller 
public class HistoryController {
	
	@Autowired  
	private HistroyService service;
//	USER_NO
//	PD_NUM
//	PD_TITLE
//	PD_PRICE
//	FILED
//	PD_IMAGE
	@PostMapping("trade-end")
	public String tradeEnd(int userNo
						 , int pdNum
						 , String pdTitle
						 , int pdPrice
						 , String filed
						 , String pdImage
						 , HttpSession session) {
		
		TradeHistory t = new TradeHistory(userNo, pdNum, pdTitle, pdPrice, filed, pdImage);
		//서비스에 전달 및 요청
//		int result = service.insertMyHistory(t);
//		
//		if(result>0) {
//			session.setAttribute("alertMsg","거래가 완료 되었습니다.");
//		}else {
//			session.setAttribute("alertMsg", "거래가 실패 했습니다.");
//		}
		return "/";
		
	}
}
