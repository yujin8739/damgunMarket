package com.kh.soak.product.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

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
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.soak.etc.model.service.EtcService;
import com.kh.soak.product.model.vo.PdFile;
import com.kh.soak.member.model.vo.Member;
import com.kh.soak.product.model.service.ProductService;
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

    // AJAX濡� �긽�뭹 紐⑸줉 媛��졇�삤湲� (臾댄븳 �뒪�겕濡�)
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
	    String fileListJson = mapper.writeValueAsString(fileList); // JSON 臾몄옄�뿴濡� 蹂��솚

	    model.addAttribute("product", product);
	    model.addAttribute("fileListJson", fileListJson); // 臾몄옄�뿴 洹몃�濡� �쟾�떖
	    return "product/view";
	}
	
	@GetMapping("product/regist")
	public String showRegist(Model model) {
		
		List<String> bigCategoryList = eService.selectBigCateList();
		
		model.addAttribute("bigCategoryList",bigCategoryList);
		
		return "product/pd-regist";
	}
	
	
	@RequestMapping(value = "product/insert", method = RequestMethod.POST)
	public String insertProduct(
	        @ModelAttribute Product product,
	        @RequestParam("uploadFile") MultipartFile[] uploadFiles,
	        @RequestParam(value = "station", required = false) List<String> stations,
	        HttpSession session,
	        HttpServletRequest request) throws Exception {

	    int result = service.insertProduct(product);

	    if (result > 0) {
	        int pdNum = product.getpdNum();
	        Member loginMember = (Member) session.getAttribute("loginUser");
	        int userNo = (int) loginMember.getUserNo();

	        String savePath = "C:\\damgunUpload\\files\\product\\";
	        File dir = new File(savePath);
	        if (!dir.exists()) dir.mkdirs();

	        
	        for (int i = 0; i < uploadFiles.length && i < 5; i++) {
	            MultipartFile uploadFile = uploadFiles[i];
	            if (!uploadFile.isEmpty()) {
	                String originalFilename = uploadFile.getOriginalFilename();
	                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
	                String renamedFilename = UUID.randomUUID().toString() + extension;

	                
	                File dest = new File(savePath + renamedFilename);
	                uploadFile.transferTo(dest);

	                
	                PdFile pdFile = new PdFile();
	                pdFile.setUserNo(userNo);
	                pdFile.setPdNum(pdNum);  
	                pdFile.setFileNo(i);
	                pdFile.setPdUrl(getServerUrl(request)+"/file/view?types=product&fileName=" + renamedFilename);
	                pdFile.setFileType("IMG");
	                pdFile.setIsThumbnail(i == 0 ? "Y" : "N"); //
	                pdFile.setIsSub("N");

	                // 
	                int fileUpResult = service.insertPdFiles(pdFile);
	                if (fileUpResult <= 0) {
	                    return "errorPage";
	                }
	            }
	        }

	        return "redirect:/product/view?pdNum=" + pdNum + "&userNo=" + userNo;
	    } else {
	        return "errorPage";
	    }
	}
	
	@RequestMapping(value = "product/delete", method = RequestMethod.POST)
    public String deleteProduct(
            @RequestParam("pdNum") int pdNum, @RequestParam("userNo") int userNo,
            HttpSession session
    		) {
        Member loginMember = (Member) session.getAttribute("loginUser");
      //  int userNo = (int) loginMember.getUserNo();

        int result = service.deleteProduct(pdNum, userNo);

        if (result > 0) {
            return "redirect:/product/list"; // 삭제 후 상품 리스트 페이지 등으로 이동
        } else {
            return "errorPage";
        }
    }
	
	public String getServerUrl(HttpServletRequest request) {
	    String scheme = request.getScheme();
	    String serverName = request.getServerName(); 
	    int serverPort = request.getServerPort(); 
	    String contextPath = request.getContextPath();

	    return scheme + "://" + serverName + ":" + serverPort + contextPath;
	}


   
}
