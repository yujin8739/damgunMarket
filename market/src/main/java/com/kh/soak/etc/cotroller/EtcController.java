package com.kh.soak.etc.cotroller;

import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.soak.etc.model.service.EtcService;
import com.kh.soak.product.model.vo.Product;

@Controller
public class EtcController {
	
	@Autowired
	private EtcService service;
	
	@GetMapping("/error-403")
	public String errorNotAllow(HttpSession session) {
		return "unAllow";
	}
	
	
	@RequestMapping(value = "category/mid",produces = "application/json;charset=UTF-8")
    @ResponseBody
    public List<Product> loadMidCate(@RequestParam(required = false) String bigCate) {
		return service.selectMidCateList(bigCate);
		
	}
	
	@RequestMapping(value = "category/small",produces = "application/json;charset=UTF-8")
    @ResponseBody
    public List<Product> loadSmallCate(@RequestParam(required = false) String bigCate, @RequestParam(required = false) String midCate) {
		return service.selectSmallCateList(bigCate,midCate);
	}

	/**
	 * 2025-06-10 장유진 
	 * 상품 페이지
	 * @param types (조회할 파일이 상품 파일인지 유저 파일인지 확인하는 용도)
	 * @param fileName
	 * @param session
	 * @return
	 */
    @GetMapping("/file/view")
    public ResponseEntity<Resource> serveFile(@RequestParam("types") String types,@RequestParam("fileName") String fileName, HttpSession session) {
    	try {
            String rootPath = "C:\\damgunUpload\\";
            Path file = Paths.get(rootPath + "files\\"+types+"\\").resolve(fileName).normalize();

            Resource resource = new UrlResource(file.toUri());
            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.notFound().build();
            }

            String contentType = Files.probeContentType(file);
            if (contentType == null) contentType = "application/octet-stream";

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_TYPE, contentType)
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
