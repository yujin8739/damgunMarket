package com.kh.soak.etc.cotroller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class EtcController {
	
	@GetMapping("/error-403")
	public String errorNotAllow(HttpSession session) {
		return "unAllow";
		
	}

}
