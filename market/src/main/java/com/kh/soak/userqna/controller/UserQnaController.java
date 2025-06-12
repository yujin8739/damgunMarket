package com.kh.soak.userqna.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.soak.userqna.model.service.UserQnaService;
import com.kh.soak.userqna.model.vo.UserQnaInfo;

@Controller
@RequestMapping("/userqna")
public class UserQnaController {
    
    @Autowired
    private UserQnaService service;
    
    // 문의사항 목록 페이지
    @RequestMapping("list.uq")
    public String userQnaList(Model model) {
        
        List<UserQnaInfo> list = service.selectUserQnaList();
        
        model.addAttribute("list", list);
        return "userqna/userQnaListView";
    }
    
    // 문의사항 상세보기
    @RequestMapping("detail.uq")
    public String userQnaDetail(@RequestParam("qno") int userQnaNum, Model model) {
        
        UserQnaInfo userQna = service.selectUserQna(userQnaNum);
        
        model.addAttribute("userQna", userQna);
        return "userqna/userQnaDetailView";
    }
    
    // 문의사항 작성 페이지 이동
    @GetMapping("enrollForm.uq")
    public String userQnaEnrollForm() {
        return "userqna/userQnaEnrollForm";
    }
    
    // 문의사항 작성 처리
    @PostMapping("insert.uq")
    public String insertUserQna(UserQnaInfo userQna, HttpSession session, Model model) {
        
        System.out.println("문의사항 작성 시도: " + userQna);
        
        int result = service.insertUserQna(userQna);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "문의사항이 성공적으로 등록되었습니다.");
            return "redirect:/userqna/list.uq";
        } else {
            model.addAttribute("errorMsg", "문의사항 등록에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // 문의사항 수정 페이지 이동
    @GetMapping("updateForm.uq")
    public String userQnaUpdateForm(@RequestParam("qno") int userQnaNum, Model model) {
        
        UserQnaInfo userQna = service.selectUserQna(userQnaNum);
        
        model.addAttribute("userQna", userQna);
        return "userqna/userQnaUpdateForm";
    }
    
    // 문의사항 수정 처리
    @PostMapping("update.uq")
    public String updateUserQna(UserQnaInfo userQna, HttpSession session, Model model) {
        
        int result = service.updateUserQna(userQna);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "문의사항이 성공적으로 수정되었습니다.");
            return "redirect:/userqna/detail.uq?qno=" + userQna.getUserQnaNum();
        } else {
            model.addAttribute("errorMsg", "문의사항 수정에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // 문의사항 삭제 처리
    @PostMapping("delete.uq")
    public String deleteUserQna(@RequestParam("qno") int userQnaNum, HttpSession session, Model model) {
        
        int result = service.deleteUserQna(userQnaNum);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "문의사항이 성공적으로 삭제되었습니다.");
            return "redirect:/userqna/list.uq";
        } else {
            model.addAttribute("errorMsg", "문의사항 삭제에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // 내 문의사항 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value="myQna.uq", produces = "application/json;charset=UTF-8")
    public List<UserQnaInfo> getMyQna(@RequestParam("userNo") int userNo) {
        
        List<UserQnaInfo> myQnaList = service.selectUserQnaByUser(userNo);
        
        return myQnaList;
    }
    
    // 신고 문의사항 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value="reportQna.uq", produces = "application/json;charset=UTF-8")
    public List<UserQnaInfo> getReportQna(@RequestParam("douserNum") int douserNum) {
        
        List<UserQnaInfo> reportQnaList = service.selectReportQna(douserNum);
        
        return reportQnaList;
    }
}