package com.kh.soak.answer.controller;

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

import com.kh.soak.answer.model.service.AnswerService;
import com.kh.soak.answer.model.vo.AnswerInfo;

@Controller
@RequestMapping("/answer")
public class AnswerController {
    
    @Autowired
    private AnswerService service;
    
    // 답변 목록 페이지
    @RequestMapping("list.an")
    public String answerList(Model model) {
        
        List<AnswerInfo> list = service.selectAnswerList();
        
        model.addAttribute("list", list);
        return "answer/answerListView";
    }
    
    // 답변 상세보기
    @RequestMapping("detail.an")
    public String answerDetail(@RequestParam("qno") int userQnaNum, Model model) {
        
        AnswerInfo answer = service.selectAnswer(userQnaNum);
        
        model.addAttribute("answer", answer);
        return "answer/answerDetailView";
    }
    
    // 답변 작성 페이지 이동
    @GetMapping("enrollForm.an")
    public String answerEnrollForm(@RequestParam("qno") int userQnaNum, Model model) {
        
        model.addAttribute("userQnaNum", userQnaNum);
        return "answer/answerEnrollForm";
    }
    
    // 답변 작성 처리
    @PostMapping("insert.an")
    public String insertAnswer(AnswerInfo answer, HttpSession session, Model model) {
        
        System.out.println("답변 작성 시도: " + answer);
        
        int result = service.insertAnswer(answer);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "답변이 성공적으로 등록되었습니다.");
            return "redirect:/answer/list.an";
        } else {
            model.addAttribute("errorMsg", "답변 등록에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // 답변 수정 페이지 이동
    @GetMapping("updateForm.an")
    public String answerUpdateForm(@RequestParam("qno") int userQnaNum, Model model) {
        
        AnswerInfo answer = service.selectAnswer(userQnaNum);
        
        model.addAttribute("answer", answer);
        return "answer/answerUpdateForm";
    }
    
    // 답변 수정 처리
    @PostMapping("update.an")
    public String updateAnswer(AnswerInfo answer, HttpSession session, Model model) {
        
        int result = service.updateAnswer(answer);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "답변이 성공적으로 수정되었습니다.");
            return "redirect:/answer/detail.an?qno=" + answer.getUserQnaNum();
        } else {
            model.addAttribute("errorMsg", "답변 수정에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // 답변 삭제 처리
    @PostMapping("delete.an")
    public String deleteAnswer(@RequestParam("qno") int userQnaNum, HttpSession session, Model model) {
        
        int result = service.deleteAnswer(userQnaNum);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "답변이 성공적으로 삭제되었습니다.");
            return "redirect:/answer/list.an";
        } else {
            model.addAttribute("errorMsg", "답변 삭제에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // 유저별 답변 목록 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value="userAnswers.an", produces = "application/json;charset=UTF-8")
    public List<AnswerInfo> getUserAnswers(@RequestParam("userNo") int userNo) {
        
        List<AnswerInfo> userAnswers = service.selectAnswersByUser(userNo);
        
        return userAnswers;
    }
}