package com.kh.soak.product.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.soak.etc.model.service.EtcService;
import com.kh.soak.member.model.vo.Member;
import com.kh.soak.product.model.service.ProductService;
import com.kh.soak.product.model.service.ProductServiceImpl;
import com.kh.soak.product.model.vo.PdFile;
import com.kh.soak.product.model.vo.Product;

@Controller
public class ProductController {
	
	@Autowired
	private ProductService service;
	
	@Autowired
	private EtcService eService;
	
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
	    if (product == null) return "errorPage";

	    List<String> fileList = service.selectFiles(pdNum, userNo);
	    ObjectMapper mapper = new ObjectMapper();
	    String fileListJson = mapper.writeValueAsString(fileList); // JSON 문자열로 변환

	    model.addAttribute("product", product);
	    model.addAttribute("fileListJson", fileListJson); // 문자열 그대로 전달
	    return "product/view";
	}
	
	@GetMapping("product/regist")
	public String showRegist(Model model,HttpSession session) {
		
		List<String> bigCategoryList = eService.selectBigCateList();
		
		model.addAttribute("bigCategoryList",bigCategoryList);
		
		return "product/pd-regist";
	}
	
	
	@RequestMapping(value = "product/insert", method = RequestMethod.POST)
	public String insertProduct(
	        @ModelAttribute Product product,
	        @RequestParam("uploadFile") MultipartFile[] uploadFiles,
	        @RequestParam(value = "station", required = false) List<Integer> stations,
	        HttpSession session,
	        HttpServletRequest request) throws Exception {
		
        Member loginMember = (Member) session.getAttribute("loginUser");
        int userNo = (int) loginMember.getUserNo();
        product.setUserNo(userNo);
        
	    int result = service.insertProduct(product);

	    if (result > 0) {
	    	
	    	for(int stationNo :stations) {
	    		int sResult = service.insertPdStation(userNo,product.getPdNum(),stationNo);
	    		if(sResult<=0) {
	    			 return "errorPage";
	    		}
	    	}
	    	
	        int pdNum = product.getPdNum();

	        // 저장 경로 설정
	        String savePath = "C:\\damgunUpload\\files\\product\\";
	        File dir = new File(savePath);
	        if (!dir.exists()) dir.mkdirs();

	        // 파일 5개까지 처리
	        for (int i = 0; i < uploadFiles.length && i < 5; i++) {
	            MultipartFile uploadFile = uploadFiles[i];
	            if (!uploadFile.isEmpty()) {
	                String originalFilename = uploadFile.getOriginalFilename();
	                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
	                String renamedFilename = UUID.randomUUID().toString() + extension;

	                // 파일 저장
	                File dest = new File(savePath + renamedFilename);
	                uploadFile.transferTo(dest);

	                // PdFile 객체 생성 및 세팅
	                PdFile pdFile = new PdFile();
	                pdFile.setUserNo(userNo);
	                pdFile.setPdNum(pdNum);
	                pdFile.setFileNo(i);
	                pdFile.setPdUrl(getServerUrl(request)+"/file/view?types=product&fileName=" + renamedFilename);
	                pdFile.setFileType("IMG");
	                pdFile.setIsThumbnail(i == 0 ? "Y" : "N"); // 첫번째만 썸네일로 예시
	                pdFile.setIsSub("N");

	                // DB 저장 (서비스에서 batch처리 메서드 있다면 변경 가능)
	                int fResult = service.insertPdFiles(pdFile);
	                if (fResult <= 0) {
	                    return "errorPage";
	                }
	            }
	        }

	        return "redirect:/product/view?pdNum=" + pdNum + "&userNo=" + userNo;
	    } else {
	        return "errorPage";
	    }
	}
	
	public String getServerUrl(HttpServletRequest request) {
	    String scheme = request.getScheme(); // http 또는 https
	    String serverName = request.getServerName(); // 서버ip
	    int serverPort = request.getServerPort(); // 포트 번호
	    String contextPath = request.getContextPath();

	    return scheme + "://" + serverName + ":" + serverPort + contextPath;
	}


   
}
