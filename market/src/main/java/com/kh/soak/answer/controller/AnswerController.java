package com.kh.soak.answer.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.kh.soak.userqna.model.service.UserQnaService;
import com.kh.soak.userqna.model.vo.UserQnaInfo;

@Controller
@RequestMapping("/answer")
public class AnswerController {
    
    @Autowired
    private AnswerService answerService;
    
    @Autowired
    private UserQnaService userQnaService;
    
    // 답변 목록 페이지 - 모든 문의사항을 보여줌
    @RequestMapping("list.an")
    public String answerList(Model model) {
        
        // UserQna에서 모든 문의사항을 가져옴
        List<UserQnaInfo> userQnaList = userQnaService.selectUserQnaList();
        
        // 각 문의사항에 대해 Answer 테이블에서 실제 답변 존재 여부 확인
        for(UserQnaInfo qna : userQnaList) {
            AnswerInfo answer = answerService.selectAnswerByQnaNum(qna.getUserQnaNum());
            qna.setStatus(answer != null);
        }
        
        model.addAttribute("list", userQnaList);
        return "answer/answerListView";
    }
    
    // 답변 상세보기 - 문의사항과 답변을 함께 보여줌
    @RequestMapping("detail.an")
    public String answerDetail(@RequestParam("qno") int userQnaNum, Model model) {
        
        // 문의사항 정보 조회
        UserQnaInfo userQna = userQnaService.selectUserQna(userQnaNum);
        
        // 답변 정보 조회
        AnswerInfo answer = answerService.selectAnswer(userQnaNum);
        
        // Answer 테이블에서 실제 답변 존재 여부로 상태 설정
        if(userQna != null) {
            userQna.setStatus(answer != null);
        }
        
        model.addAttribute("userQna", userQna);
        model.addAttribute("answer", answer);
        return "answer/answerDetailView";
    }
    
    // 답변 작성 페이지 이동
    @GetMapping("enrollForm.an")
    public String answerEnrollForm(@RequestParam("qno") int userQnaNum, Model model) {
        
        // 문의사항 정보도 함께 전달
        UserQnaInfo userQna = userQnaService.selectUserQna(userQnaNum);
        
        model.addAttribute("userQna", userQna);
        model.addAttribute("userQnaNum", userQnaNum);
        return "answer/answerEnrollForm";
    }
    
    @PostMapping("insert.an")
    public String insertAnswer(AnswerInfo answer, HttpSession session, Model model) {
        
        System.out.println("답변 작성 시도: " + answer);
        
        int result = answerService.insertAnswer(answer);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "답변이 성공적으로 등록되었습니다.");
            return "redirect:/answer/list.an";
        } else {
            model.addAttribute("errorMsg", "답변 등록에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    @GetMapping("updateForm.an")
    public String answerUpdateForm(@RequestParam("qno") int userQnaNum, Model model) {
        
        UserQnaInfo userQna = userQnaService.selectUserQna(userQnaNum);
        AnswerInfo answer = answerService.selectAnswer(userQnaNum);
        
        model.addAttribute("userQna", userQna);
        model.addAttribute("answer", answer);
        return "answer/answerUpdateForm";
    }
    
    @PostMapping("update.an")
    public String updateAnswer(AnswerInfo answer, HttpSession session, Model model) {
        
        int result = answerService.updateAnswer(answer);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "답변이 성공적으로 수정되었습니다.");
            return "redirect:/answer/detail.an?qno=" + answer.getUserQnaNum();
        } else {
            model.addAttribute("errorMsg", "답변 수정에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    @PostMapping("delete.an")
    public String deleteAnswer(@RequestParam("qno") int userQnaNum, HttpSession session, Model model) {
        
        int result = answerService.deleteAnswer(userQnaNum);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "답변이 성공적으로 삭제되었습니다.");
            return "redirect:/answer/list.an";
        } else {
            model.addAttribute("errorMsg", "답변 삭제에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    @ResponseBody
    @RequestMapping(value="userAnswers.an", produces = "application/json;charset=UTF-8")
    public List<AnswerInfo> getUserAnswers(@RequestParam("userNo") int userNo) {
        
        List<AnswerInfo> userAnswers = answerService.selectAnswersByUser(userNo);
        
        return userAnswers;
    }
    
    @ResponseBody
    @RequestMapping("checkAnswer.an")
    public Map<String, Boolean> checkAnswer(@RequestParam("qno") int userQnaNum) {
        Map<String, Boolean> result = new HashMap<>();
        
        // Answer 테이블에서 직접 확인
        AnswerInfo answer = answerService.selectAnswerByQnaNum(userQnaNum);
        result.put("hasAnswer", answer != null);
        
        return result;
    }
}