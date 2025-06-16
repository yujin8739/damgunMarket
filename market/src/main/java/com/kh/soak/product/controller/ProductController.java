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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kh.soak.etc.model.service.EtcService;
import com.kh.soak.etc.model.vo.Station;
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
    	    @RequestParam(required = false) String keyword,
    	    @RequestParam(required = false) String category,
    	    @RequestParam double latitude,
    	    @RequestParam double longitude
    	) {
        RowBounds rowBounds = new RowBounds(offset, limit);
        if((keyword==null || keyword.equals("")) && (category==null || category.equals(""))) {
        	return service.searchAllProduct(rowBounds, latitude, longitude);
        } else if(keyword==null || keyword.equals("")) {
        	return service.searchCategory(rowBounds,category, latitude, longitude);
        } else if(category==null || category.equals("")) {
        	return service.searchProduct(rowBounds,keyword, latitude, longitude);
        } else { 
        	return service.searchProduct(rowBounds,keyword,category, latitude, longitude); 
        }
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
	
	@RequestMapping(value = "product/delete", method = RequestMethod.POST)
    public String deleteProduct(
            @RequestParam("pdNum") int pdNum, @RequestParam("userNo") int userNo,
            HttpSession session
    		) {
        Member loginMember = (Member) session.getAttribute("loginUser");
      //  int userNo = (int) loginMember.getUserNo();
        
        if(loginMember == null || loginMember.getUserNo() != userNo) {
            // 권한이 없으면 에러 페이지나 권한 없음 페이지 리턴
            return "error-403";
        }

        int result = service.deleteProduct(pdNum, userNo);

        if (result > 0) {
        	return "redirect:/"; // 삭제 후 상품 리스트 페이지 등으로 이동
        } else {
            return "errorPage";
        }
    }
	

	/*김진우 추가*/
	@GetMapping("product/edit")
    public String showEditPage(@RequestParam("pdNum") int pdNum, HttpSession session, Model model) {
        Member loginUser = (Member) session.getAttribute("loginUser");

        if (loginUser == null) {
            return "redirect:/login";
        }

        Product product = service.editProduct(pdNum); // → 다음 단계에서 구현할 서비스 메서드

        if (product == null || product.getUserNo() != loginUser.getUserNo()) {
            return "error-403";
        }

        model.addAttribute("product", product);
        model.addAttribute("bigCategoryList", eService.selectBigCateList());

        return "product/pd-edit"; // 수정 JSP
  }
	
	@RequestMapping(value = "product/get-station", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public List<Station> favoriteList(@RequestParam("pdNum") int pdNum,
            						 @RequestParam("userNo") int userNo){
		
		return eService.selectPdStationList(pdNum,userNo);
	}
	
	@RequestMapping(value = "product/favoriteList",produces = "application/json;charset=UTF-8")
	@ResponseBody
	public List<Object> favoriteList(@RequestParam int offset,
						    	     @RequestParam int limit,
									 @RequestParam(required = false) int userNo) {
		RowBounds rowBounds = new RowBounds(offset, limit);
	    return service.favoriteList(userNo,rowBounds);        
	}
	
	public String getServerUrl(HttpServletRequest request) {
	    String scheme = request.getScheme(); // http 또는 https
	    String serverName = request.getServerName(); // 서버ip
	    int serverPort = request.getServerPort(); // 포트 번호
	    String contextPath = request.getContextPath();

	    return scheme + "://" + serverName + ":" + serverPort + contextPath;
	}
		
	//사용자가 폼에 작성한 내용을 받아서 DB에 업데이트하고 상세보기 페이지로 리다이렉트
	@PostMapping("product/edit")
	public String submitEditProduct(@ModelAttribute Product product,
									HttpSession session,
									RedirectAttributes redirectAttributes) {
		Member loginUser = (Member) session.getAttribute("loginUser");
		if (loginUser == null || loginUser.getUserNo() != product.getUserNo()) {
			return "error-403";
		}

		int result = service.updateProductByPdNumUserNo(product);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "수정 성공");
			return "redirect:/product/view?pdNum=" + product.getPdNum() + "&userNo=" + product.getUserNo();
		} else {
			redirectAttributes.addFlashAttribute("msg", "수정 실패");
			return "redirect:/product/edit?pdNum=" + product.getPdNum() + "&userNo=" + product.getUserNo();
		}
	}
		
	@RequestMapping(value = "product/myPdList",produces = "application/json;charset=UTF-8")
	@ResponseBody
	public List<Object> selectMyPdList(@RequestParam int offset,
						    	     @RequestParam int limit,
									 @RequestParam(required = false) int userNo) {
		RowBounds rowBounds = new RowBounds(offset, limit);
		return service.selectMyPdList(rowBounds, userNo);
	} 
	
	@GetMapping("product/pd-view")
	public String showMyPdList() {
		return "product/myPdListView";
	}
	
	/**
	 *  전부 있을때는 거래 신청 진행
	 * @param pdNum
	 * @param userNo  이것만 없을때는 거래신청중인지 확인
	 * @param enrollNo 없을때는 처음 조회
	 * @param status
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "product/trade-enroll", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String tradeEnroll(@RequestParam int pdNum
							 ,@RequestParam int userNo
							 ,@RequestParam(required = false) String enrollNo
							 ,@RequestParam(required = false) String status 
						   	 ,HttpSession session) {
		
		if(enrollNo == null||enrollNo.equals("")){
			//로그인 한 회원 없을때 조회
			return service.checkPdEnroll(pdNum, userNo);
		} else { 		
			int numEnroll = Integer.parseInt(enrollNo);
			if(status == null || status.equals("")) {	
				/* 로그인한 회원 있을때는 상품에 연결된 거래 내역에서 예약중, 판매완료가 있으면 가져오고
				   없으면 로그인한 아이디와 일치하는 거래 신청이 있나 확인후 있으면 거래 신청 가져옴 
				   만약 모두 없으면 판매중 반환 */
				return service.checkMyEnroll(pdNum, userNo, numEnroll);
			} else if (status.equals("거래신청")) {
				//거래 신청하는 용도로 사용
				int cResult = service.tradeEnroll(pdNum, userNo, numEnroll, status);
				if(cResult<0) {
					return "신청실패";
				} else {
					return status;
				}
			} else if (status.equals("예약중")) {
				int cResult = service.tradeEnroll(pdNum, userNo, numEnroll, status);
				if(cResult<0) {
					return "예약실패";
				} else {
					return status;
				}
			} else if (status.equals("판매완료")) {
				int cResult = service.tradeEnroll(pdNum, userNo, numEnroll, status);
				if(cResult<0) {
					return "예약실패";
				} else {
					return status;
				}
			} else {
				return "신청실패";
			}
		}
	}
	
	@RequestMapping(value = "product/HistoryList",produces = "application/json;charset=UTF-8")
	@ResponseBody
	public List<Product> selectHistoryList(@RequestParam int offset
   	     								  ,@RequestParam int limit
   	     								  ,@RequestParam int userNo
   	     								  ,@RequestParam String status) {
		RowBounds rowBounds = new RowBounds(offset, limit);
		return service.selectHistoryList(userNo, status, rowBounds);
	}
	
	@RequestMapping(value = "product/HistoryMyList",produces = "application/json;charset=UTF-8")
	@ResponseBody
	public List<Product> selectMyHistoryList(@RequestParam int offset
   	     								  ,@RequestParam int limit
   	     								  ,@RequestParam int userNo
   	     								  ,@RequestParam String status) {
		RowBounds rowBounds = new RowBounds(offset, limit);
		return service.selectMyHistoryList(userNo, status, rowBounds);
	}
	
	@RequestMapping(value = "product/History-update",produces = "application/json;charset=UTF-8")
	@ResponseBody
	public int selectHistoryUpdate(@RequestParam int pdNum
			 					  ,@RequestParam int userNo
			 					  ,@RequestParam(required = false) String enrollNo
			 					  ,@RequestParam String status) {
		
		int result = service.selectHistoryUpdate(pdNum, userNo, enrollNo, status);
		
//		if(result>0) {
//			int pResult = eService.insertPoint(userNo,10);
//		}
		
		return result;
	}
	
	@GetMapping("product/History-view")
	public String showMyHistoryList(@RequestParam("role") String role) {
		if(role.equals("buyer")) {
			return "product/myHistoryView";
		} else {
			return "product/pdHistoryView";
		}
	}
	
}