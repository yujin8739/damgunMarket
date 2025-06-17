package com.kh.soak.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.soak.admin.model.vo.Admin;

public class AdminInterceptor implements HandlerInterceptor {
    
    @Override
    public boolean preHandle(HttpServletRequest request, 
                           HttpServletResponse response, 
                           Object handler) throws Exception {
        
        HttpSession session = request.getSession();
        Admin loginAdmin = (Admin) session.getAttribute("loginAdmin");
        
        // 관리자가 로그인되어 있지 않은 경우
        if (loginAdmin == null) {
            session.setAttribute("alertMsg", "관리자 로그인이 필요한 서비스입니다.");
            response.sendRedirect(request.getContextPath() + "/admin/loginForm.ad");
            return false; // 요청 처리 중단
        }
        
        return true; // 요청 계속 진행
    }
}