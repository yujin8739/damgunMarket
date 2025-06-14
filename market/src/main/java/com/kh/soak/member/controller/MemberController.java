package com.kh.soak.member.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

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

@Controller 
public class MemberController {
	
	@Autowired
	private MemberService service;
	
	//암호처리할 Bcrypt 등록
	@Autowired
	private BCryptPasswordEncoder bcrypt;
	
	@RequestMapping("login.me")
	public String loginMember(Member m, HttpSession session, Model model) {
		
		System.out.println("로그인 시도 - 사용자 입력 ID: " + m.getUserId());
		
		//사용자가 입력한 아이디만 가지고 일치한 회원 정보 조회
		Member loginUser = service.loginMember(m);
		
		System.out.println("DB에서 조회된 사용자: " + loginUser);
//		bcrypt.matches(평문,암호문) : 평문과 암호문을 비교해주는 메소드 : true / false 반환
		System.out.println("사용자가 입력한 비밀번호 : "+m.getPassWord());
		System.out.println("평문에 대한 암호문 : "+bcrypt.encode(m.getPassWord()));
		//성공 실패 처리 
		if(loginUser != null && bcrypt.matches(m.getPassWord(), loginUser.getPassWord())) { 
	
			session.setAttribute("alertMsg", "로그인 성공!");
			session.setAttribute("loginUser", loginUser);
			return "redirect:/";
		} else {
			model.addAttribute("errorMsg","아이디 또는 비밀번호가 일치하지 않습니다.");
			return "common/errorPage";
		}
	}
	
	//로그아웃
	@RequestMapping("logout.me")
	public String logoutMember(HttpSession session) {
		session.removeAttribute("loginUser");
		return "redirect:/";
	}
	
	//회원가입 페이지로 이동
	@GetMapping("insert.me")
	public String insertMember() {
		return "member/memberEnrollForm";
	}
	
	//회원가입 등록요청
	@PostMapping("insert.me")
	public String insertMember(Member m, HttpSession session, Model model) {
		
		System.out.println("회원가입 시도: " + m);
		
		//비밀번호 암호화
		String encPwd = bcrypt.encode(m.getPassWord());
		m.setPassWord(encPwd);
		
		//서비스에 회원가입 메소드 호출
		int result = service.insertMember(m);
		
		if(result > 0) {
			session.setAttribute("alertMsg", "회원가입을 환영합니다.");
			return "redirect:/";
		} else {
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
	public String updateMember(Member m, HttpSession session, Model model) {
		
		int result = service.updateMember(m);
		
		if(result > 0) {
			session.setAttribute("alertMsg", "정보수정 성공!");
			
			//변경된 정보 갱신
			Member updateMember = service.loginMember(m);
			session.setAttribute("loginUser", updateMember);
			
			return "redirect:/mypage.me";
		} else {
			model.addAttribute("errorMsg","정보수정 실패!");
			return "common/errorPage";
		}
	}
	
	@RequestMapping("delete.me")
	public String deleteMember(Member m, HttpSession session) {
		
		Member loginUser = service.loginMember(m);
		
		if(loginUser != null && bcrypt.matches(m.getPassWord(), loginUser.getPassWord())) {
			
			int result = service.deleteMember(m);
			
			if(result > 0) {
				session.setAttribute("alertMsg", "회원 탈퇴 성공");
				session.removeAttribute("loginUser");
				return "redirect:/";
			} else {
				session.setAttribute("alertMsg", "회원 탈퇴 실패");
				return "redirect:/mypage.me";
			}
		} else {
			session.setAttribute("alertMsg", "비밀번호를 잘못입력하셨습니다.");
			return "redirect:/mypage.me";
		}
	}
	
	//아이디 중복체크
	@ResponseBody
	@RequestMapping(value="idCheck.me", produces = "text/html;charset=UTF-8")
	public String idCheck(String userId) {
		
		int count = service.idCheck(userId);
		
		if(count > 0) {
			return "NNNNN"; //중복
		} else {
			return "NNNNY"; //사용가능
		}
	}
	
	//상품 조회시 찜여부 가져오기
	@ResponseBody
	@RequestMapping(value="user/selectFavorite", produces = "application/json;charset=UTF-8")
	public int selectFavorite(@RequestParam(required = false) int userNo, 
            				  @RequestParam(required = false) int pdNum) {
	    //찜여부 가져오기
//	    Member loginMember = (Member) session.getAttribute("loginUser");
//	    int userNo = loginMember.getUserNo();
	    
		return service.selectFavorite(userNo,pdNum);
	    
	}
	
	@RequestMapping(value = "user/saveFavorite", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public int saveFavorite(@RequestParam(required = false) int userNo, 
	                        @RequestParam(required = false) int pdNum) {
	    return service.saveFavorite(userNo, pdNum);
	}
	
	@RequestMapping(value = "user/deleteFavorite",produces = "application/json;charset=UTF-8")
	@ResponseBody
	public int deleteFavorite(@RequestParam(required = false) int userNo 
			                , @RequestParam(required = false) int pdNum) {
	    return service.deleteFavorite(userNo,pdNum);        
	}

	@GetMapping("user/FavoriteList")
	public String showFavoriteList() {
		return "member/favorView";
	}
	
	@RequestMapping(value = "user/e-list",produces = "application/json;charset=UTF-8")
	@ResponseBody
	public List<Member> selectEnrollMemberList(@RequestParam int userNo 
			                				 , @RequestParam int pdNum
			                				 , @RequestParam String status) {
	    return service.selectEnrollMemberList(userNo,pdNum,status);        
	}
}
