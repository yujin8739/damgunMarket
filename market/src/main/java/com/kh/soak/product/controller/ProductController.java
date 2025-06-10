package com.kh.soak.product.controller;

import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.soak.product.model.service.ProductService;
import com.kh.soak.product.model.service.ProductServiceImpl;
import com.kh.soak.product.model.vo.Product;

@Controller
public class ProductController {
	
	@Autowired
	private ProductService service;
	
	@PostMapping("status-change.do") 
	public String pdStatusChange(int pdNum, HttpSession session) {
		int result = service.tradeItem(pdNum);
		if(result > 0) {
			return "trade-end";
		} 
		return "error-403";
	}

    // AJAX로 상품 목록 가져오기 (무한 스크롤)
	@RequestMapping(value = "product/load",produces = "application/json;charset=UTF-8")
    @ResponseBody
    public List<Product> loadProducts(
    	    @RequestParam int offset,
    	    @RequestParam int limit,
    	    @RequestParam(required = false) String keyword
    	) {
        RowBounds rowBounds = new RowBounds(offset, limit);
        if(keyword==null || keyword=="") {
        	return service.searchAllProduct(rowBounds);
        } 
        return service.searchProduct(rowBounds,keyword);
    }

    
	@RequestMapping(value = "product/view", produces = "text/html;charset=UTF-8")
	public String viewProduct(@RequestParam("pdNum") int pdNum,
	                          @RequestParam("userNo") int userNo,
	                          Model model) throws Exception {
	    Product product = service.selectOneProduct(pdNum, userNo);
	    if (product == null) return "error/404";

	    List<String> fileList = service.selectFiles(pdNum, userNo);
	    ObjectMapper mapper = new ObjectMapper();
	    String fileListJson = mapper.writeValueAsString(fileList); // JSON 문자열로 변환

	    model.addAttribute("product", product);
	    model.addAttribute("fileListJson", fileListJson); // 문자열 그대로 전달
	    return "product/view";
	}
	
	@GetMapping
	public String showRegist() {
		return "product/pd-regist";
	}
   

}
