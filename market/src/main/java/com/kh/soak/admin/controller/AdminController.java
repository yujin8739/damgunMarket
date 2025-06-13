package com.kh.soak.admin.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.soak.admin.model.service.AdminService;
import com.kh.soak.admin.model.vo.Admin;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private AdminService service;
    
    @Autowired
    private BCryptPasswordEncoder bcrypt;
    
    // 관리자 로그인 페이지 이동
    @GetMapping("loginForm.ad")
    public String adminLoginForm() {
        return "admin/adminLoginForm";
    }
    
    
    // 관리자 로그인 처리
    @RequestMapping("login.ad")
    public String loginAdmin(Admin admin, HttpSession session, Model model) {
        
        System.out.println("관리자 로그인 시도 - ID: " + admin.getAdminId());
        
        Admin loginAdmin = service.loginAdmin(admin);
        
        System.out.println("DB에서 조회된 사용자: " + loginAdmin);
        System.out.println("사용자가 입력한 비밀번호 : " + admin.getAdminPw());
        System.out.println("DB의 암호화된 비밀번호: " + (loginAdmin != null ? loginAdmin.getAdminPw() : "null"));
        
        // 비밀번호 매칭 테스트
        if(loginAdmin != null) {
            boolean passwordMatch = bcrypt.matches(admin.getAdminPw(), loginAdmin.getAdminPw());
            System.out.println("비밀번호 매칭 결과: " + passwordMatch);
        }
        
        if(loginAdmin != null && bcrypt.matches(admin.getAdminPw(), loginAdmin.getAdminPw())) {
            session.setAttribute("alertMsg", "관리자 로그인 성공!");
            session.setAttribute("loginAdmin", loginAdmin);
            return "redirect:/";
        } else {
            model.addAttribute("errorMsg", "관리자 아이디 또는 비밀번호가 일치하지 않습니다.");
            return "common/errorPage";
        }
    }
 
  
    
    // 관리자 로그아웃
    @RequestMapping("logout.ad")
    public String logoutAdmin(HttpSession session) {
        session.removeAttribute("loginAdmin");
        return "redirect:/";
    }
    
    // 관리자 메인 페이지
    @RequestMapping("main.ad")
    public String adminMain() {
        return "admin/adminMain";
    }
    
    // 관리자 등록 처리
    @PostMapping("insert.ad")
    public String insertAdmin(Admin admin, HttpSession session, Model model) {
        
        System.out.println("관리자 등록 시도: " + admin);
        
        // 비밀번호 암호화
        String encPwd = bcrypt.encode(admin.getAdminPw());
        admin.setAdminPw(encPwd);
        
        int result = service.insertAdmin(admin);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "관리자 등록이 완료되었습니다.");
            return "redirect:/admin/main.ad";
        } else {
            model.addAttribute("errorMsg", "관리자 등록에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // 관리자 정보 수정
    @PostMapping("update.ad")
    public String updateAdmin(Admin admin, HttpSession session, Model model) {
        
        int result = service.updateAdmin(admin);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "관리자 정보 수정 성공!");
            
            // 변경된 정보 갱신
            Admin updateAdmin = service.loginAdmin(admin);
            session.setAttribute("loginAdmin", updateAdmin);
            
            return "redirect:/admin/main.ad";
        } else {
            model.addAttribute("errorMsg", "관리자 정보 수정 실패!");
            return "common/errorPage";
        }
    }
    
    // 관리자 삭제
    @PostMapping("delete.ad")
    public String deleteAdmin(Admin admin, HttpSession session, Model model) {
        
        Admin loginAdmin = service.loginAdmin(admin);
        
        if(loginAdmin != null && bcrypt.matches(admin.getAdminPw(), loginAdmin.getAdminPw())) {
            
            int result = service.deleteAdmin(admin);
            
            if(result > 0) {
                session.setAttribute("alertMsg", "관리자 삭제 성공");
                session.removeAttribute("loginAdmin");
                return "redirect:/";
            } else {
                session.setAttribute("alertMsg", "관리자 삭제 실패");
                return "redirect:/admin/main.ad";
            }
        } else {
            session.setAttribute("alertMsg", "비밀번호를 잘못입력하셨습니다.");
            return "redirect:/admin/main.ad";
        }
    }
    
    // 관리자 아이디 중복체크
    @ResponseBody
    @RequestMapping(value="idCheck.ad", produces = "text/html;charset=UTF-8")
    public String idCheck(String adminId) {
        
        int count = service.idCheck(adminId);
        
        if(count > 0) {
            return "NNNNN"; // 중복
        } else {
            return "NNNNY"; // 사용가능
        }
    }
}