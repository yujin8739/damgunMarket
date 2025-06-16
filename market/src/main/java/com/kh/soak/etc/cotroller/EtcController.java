package com.kh.soak.etc.cotroller;

import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.kh.soak.admin.model.vo.Admin;
import com.kh.soak.etc.model.service.EtcService;
import com.kh.soak.etc.model.vo.Station;
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
    
    @RequestMapping(value = "Station/pd-regit",produces = "application/json;charset=UTF-8")
    @ResponseBody
    public List<Station> getNearbyStations(@RequestParam double lat, @RequestParam double lng) {
        return service.selectNearStations(lat,lng);
    }
    
    @SuppressWarnings("unchecked")
	@RequestMapping(value = "Gecoding", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, String> getAddressFromGeoCoding(@RequestParam double longitude, @RequestParam double latitude) {

        String apiKey = "9CCC82B0-DC21-3BD4-BDE5-417062C44EAD";
        String url = String.format(
            "https://api.vworld.kr/req/address?service=address&request=getAddress&version=2.0" +
            "&crs=epsg:4326&point=%s,%s&format=json&type=both&zipcode=true&simple=false&key=%s",
            longitude, latitude, apiKey
        );

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<Map> response = restTemplate.getForEntity(url, Map.class);

        Map<String, Object> body = response.getBody();
        Map<String, Object> responseMap = (Map<String, Object>) body.get("response");
        List<Map<String, Object>> results = (List<Map<String, Object>>) responseMap.get("result");

        String parcelAddr = "";
        String roadAddr = "";

        for (Map<String, Object> result : results) {
            String type = (String) result.get("type");
            String text = (String) result.get("text");

            if ("parcel".equals(type)) parcelAddr = text;
            if ("road".equals(type)) roadAddr = text;
        }

        Map<String, String> addressMap = new HashMap<>();
        addressMap.put("parcel", parcelAddr);
        addressMap.put("road", roadAddr);

        return addressMap;
    }
    
	 @RequestMapping(value = "etc/chargePoint", produces = "application/json;charset=UTF-8")
	 @ResponseBody  // → AJAX 응답을 직접 돌려줄 경우 반드시 필요!
	 public int chargePoint(@RequestParam("userId") String userId,
	                           @RequestParam("point") int point,
	                           HttpSession session) {
		 Admin admin = (Admin) session.getAttribute("loginAdmin");
		 if(admin!=null&&admin.getAdminId()!=null&&!admin.getAdminId().equals("")) {
			 return service.chargePoint(userId, point);
		 } else { 
			 return -1;
		 }
	 }


}
