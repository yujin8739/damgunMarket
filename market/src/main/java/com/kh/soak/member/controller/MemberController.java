package com.kh.soak.member.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.soak.member.model.service.MemberService;
import com.kh.soak.member.model.vo.Member;
import com.kh.soak.product.model.vo.Product;

@Controller //Controller 타입의 어노테이션을 부여하면 spring이 bean scan을 통해 Controller bean으로 등록해준다.
public class MemberController {
	
	//사용할 Service객체를 선언해놓고 스프링이 관리할 수 있도록 처리하기
	//기존 방식
	//private MemberService service = new MemberService();
	/*
	 * 기존 객체 생성 방식
	 * 객체간의 결합도가 높다.(소스코드의 수정이 일어날 경우 직접 찾아서 변경해야함)
	 * 서비스가 동시에 많은 횟수가 요청될 경우 그만큼 객체 생성이 발생됨 
	 * 
	 * Spring에선 DI(Dependency Injection)을 이용한 방식으로 
	 * 객체를 생성시켜 주입한다. (객체간의 결합도를 낮춰준다)
	 * new 라는 키워드없이 선언문만 사용하고 @Autowired라는 어노테이션을 부여해서 
	 * 스프링이 직접 bean을 관리 할 수 있도록 등록한다.
	 * 
	 * @Autowired : 스프링이 bean을 자동 주입할 수 있도록 하는 어노테이션
	 * 
	 * */
	
	@Autowired
	private MemberService service;
	
	//암호처리할 Bcrypt 등록
	@Autowired
	private BCryptPasswordEncoder bcrypt;
	
	
	
	@RequestMapping("login.me")
	public String loginMember(Member m
							 ,HttpSession session
							 ,Model model) {
		
		//사용자가 입력한 아이디만 가지고 일치한 회원 정보 조회
		Member loginUser = service.loginMember(m);
		//해당 정보에서 비밀번호를 추출(암호문)하여 사용자가 입력한 비밀번호(평문)과 판별하는 메소드를 이용하기
		//BcryptPasswordEncoder는 암호문을 복호화 하여 평문으로 되돌려주지 않는다.
		//대신 암호문을 복호화했을때 나오는 평문과 일치하는지 비교해주는 판멸 메소드는 제공해줌
		//bcrypt.matches(평문,암호문) : 평문과 암호문을 비교해주는 메소드 : true / false 반환
//		System.out.println("사용자가 입력한 비밀번호 : "+m.getUserPwd());
//		System.out.println("평문에 대한 암호문 : "+bcrypt.encode(m.getUserPwd()));
		
		
		//성공 실패 처리 
		if(loginUser != null && bcrypt.matches(m.getPassWord(), loginUser.getPassWord())) { //성공시 
			session.setAttribute("alertMsg", "로그인 성공!");
			session.setAttribute("loginUser", loginUser);
			
			//메인페이지로 재요청
			return "redirect:/";
			
		}else {//실패시
			//오류메시지를 model에 담아서 에러페이지로 포워딩 해보기 
			model.addAttribute("errorMsg","로그인 실패!!");
			
			//viewResolver가 WEB-INF/views/ 와 .jsp를 붙여서 경로를 완성해준다
			return "common/errorPage";
			
		}
	}
	
	//로그아웃
	@RequestMapping("logout.me")
	public String logoutMember(HttpSession session) {
		
		//loginUser 정보 세션에서 삭제하기 
		session.removeAttribute("loginUser");
		
		//메인페이지로 보내기
		return "redirect:/";
	}
	
	
	//@RequestMapping은 get,post 요청 상관없이 처리한다. 
	//get과 post를 따로 처리하고자 한다면 
	//1.@RequestMapping에 method 속성 추가
	//2.@PostMapping,@GetMapping 어노테이션 사용 
	
	//회원가입 페이지로 이동
	//@RequestMapping(value="insert.me",method = RequestMethod.GET)
	@GetMapping("insert.me")
	public String insertMember() {
		
		
		//회원가입 페이지로 포워딩처리 
		//경로 : /WEB-INF/views/member/memberEnrollForm.jsp 
		return "member/memberEnrollForm";
	}
	
	//회원가입 등록요청
	//@RequestMapping(value="insert.me",method = RequestMethod.POST)
	@PostMapping("insert.me")
	public String insertMember(Member m
							  ,HttpSession session
							  ,Model model) {
		//나이를 입력하지 않은 경우 int 자료형인 age필드에 "" 빈문자열이 들어가려고 하기 때문에
		//오류가 발생한다. 400번 에러 (잘못된요청)
		//Member VO의 age필드를 String으로 변경한다 이때 lombok을 이용하여 손쉽게 처리하기.
		
		//비밀번호가 사용자가 입력한 그대로 저장되는것을 방지하기
		//Bcrypt 암호화 방식을 이용하여 암호문을 저장하여 보안성을 유지하기
		//1)스프링 시큐리티 모듈에서 제공하는 DI 추가하기
		//2)BCryptPasswordEncoder 클래스 bean 추가하기
		//3)web.xml에 spring-security.xml 파일을 로딩할 수 있도록 추가하기.
		
		//bcrypt.encode(평문) : 평문을 암호화한 값을 반환해준다.
		
		//비밀번호는 암호문으로 변경하여 m 에 담고 데이터베이스에 등록작업하기 
		
		String encPwd = bcrypt.encode(m.getPassWord());//평문 암호문으로 변경 

		m.setPassWord(encPwd);//객체에 암호문 비밀번호 넣기
		
		//서비스에 회원가입 메소드 호출 및 전달
		int result = service.insertMember(m);
		//mybatis 메소드는 sqlSession.insert() 를 사용하시면 됩니다.
		
		//mapper에 resultMap 또는 resultType 작성 X  parameterType만 작성
		//회원가입 성공시 - 회원가입을 환영합니다. 메시지와 함께 메인 페이지로 보내기(재요청)
		if(result>0) {
			session.setAttribute("alertMsg", "회원가입을 환영합니다.");
			return "redirect:/";
		}else {
			//회원가입 실패시 - 회원가입에 실패하였습니다. 메시지와 함께 에러페이지로 포워딩(위임) - model 객체 이용
			model.addAttribute("errorMsg","회원가입에 실패하였습니다.");
			
			return "common/errorPage";
		}
	}
	
	//마이페이지 이동 메소드
	@RequestMapping("mypage.me")
	public String myPage() {
		
		return "member/mypage";
	}
	
	
	//정보수정 메소드 
	@RequestMapping("update.me")
	public String updateMember(Member m
							  ,HttpSession session
							  ,Model model) {
		
		int result = service.updateMember(m);
		
		if(result>0) { //성공시
			
			session.setAttribute("alertMsg", "정보수정 성공!");
			
			//변경된 정보 갱신시키기 위해서 회원정보 조회해오기(로그인메소드 재사용)
			Member updateMember = service.loginMember(m);
			
			session.setAttribute("loginUser", updateMember);//로그인정보 갱신
			
			return "redirect:/mypage.me"; //마이페이지 재요청
		}else {//실패
			
			model.addAttribute("errorMsg","정보수정 실패!");
			
			return "common/errorPage";//에러페이지로 위임
			
		}
		
		
	}
	
	
	@RequestMapping("delete.me")
	public String deleteMember(Member m 
							  ,HttpSession session) {
		
		Member loginUser = service.loginMember(m);
		
		//평문과 암호문을 비교하여 판별하는 mathches 메소드 이용하기.
		
		if(bcrypt.matches(m.getPassWord(), loginUser.getPassWord())) {
			//비밀번호를 제대로 입력한 경우
			
			int result = service.deleteMember(m);
			
			if(result>0) {//회원탈퇴처리 성공시
				session.setAttribute("alertMsg", "회원 탈퇴 성공");
				
				//로그인된 정보 삭제
				session.removeAttribute("loginUser");
				
				return "redirect:/";//메인페이지로
				
			}else {//실패시 
				session.setAttribute("alertMsg", "회원 탈퇴 실패");
				
				return "redirect:/mypage.me";//마이페이지로
			}
			
		}else {//입력한 비밀번호가 등록된 비밀번호와 다를때 
			
			session.setAttribute("alertMsg", "비밀번호를 잘못입력하셨습니다.");
			return "redirect:/mypage.me";
		}
		
		
		
	}
	
	//문자열 데이터로 응답처리
	@ResponseBody
	@RequestMapping(value="idCheck.me",produces = "text/html;charset=UTF-8")
	public String idCheck(String userId) {
		
		//전달받은 userId와 같은 회원정보가 있는지 조회후 
		//있다면 NNNNN을 없다면 NNNNY를 반환하기 
		
		int count = service.idCheck(userId);
		
		if(count>0) {//중복 
			return "NNNNN";
		}else {//사용가능		
			return "NNNNY";
		}
	}
	
	
	 // AJAX로 상품 목록 가져오기 (무한 스크롤)
	@RequestMapping(value = "user/saveFavorite",produces = "text/html;charset=UTF-8")
	@ResponseBody
	public int saveFavorite(@RequestParam(required = false) int userNo 
			                        , @RequestParam(required = false) int pdNum) {
	        return service.saveFavorite(userNo,pdNum);        
	}
	
	// AJAX로 상품 목록 가져오기 (무한 스크롤)
	@RequestMapping(value = "user/deleteFavorite",produces = "text/html;charset=UTF-8")
	@ResponseBody
	public int deleteFavorite(@RequestParam(required = false) int userNo 
			                        , @RequestParam(required = false) int pdNum) {
	        return service.deleteFavorite(userNo,pdNum);        
	}
	
	
	
	
	
	

}
