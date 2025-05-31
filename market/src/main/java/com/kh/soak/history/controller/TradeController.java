package com.kh.soak.history.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class TradeController {

	@PostMapping("/trade-end")
	public String tradeEnd(int sellerNo, int buyerNo, Model model) {
		return null;
	
		
	}
}
