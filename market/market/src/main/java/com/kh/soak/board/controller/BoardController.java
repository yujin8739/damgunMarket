package com.kh.soak.board.controller;

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

import com.kh.soak.board.model.service.BoardService;
import com.kh.soak.board.model.vo.Board;

@Controller
@RequestMapping("/board")
public class BoardController {
    
    @Autowired
    private BoardService service;
    
    // 공지사항 목록 페이지 (모든 사용자 접근 가능)
    @RequestMapping("list.bo")
    public String boardList(Model model) {
        List<Board> list = service.selectBoardList();
        model.addAttribute("list", list);
        return "board/boardListView";
    }
    
    // 공지사항 상세보기 (모든 사용자 접근 가능)
    @RequestMapping("detail.bo")
    public String boardDetail(@RequestParam("bno") int noticeNum, Model model) {
        Board board = service.selectBoard(noticeNum);
        model.addAttribute("board", board);
        return "board/boardDetailView";
    }
    
    // 공지사항 작성 페이지 이동 (관리자만)
    @GetMapping("enrollForm.bo")
    public String boardEnrollForm(HttpSession session, Model model) {
        // 관리자 권한 체크
        if(session.getAttribute("loginAdmin") == null) {
            model.addAttribute("errorMsg", "관리자만 접근 가능합니다.");
            return "common/errorPage";
        }
        return "board/boardEnrollForm";
    }
    
    // 공지사항 작성 처리 (관리자만)
    @PostMapping("insert.bo")
    public String insertBoard(Board board, HttpSession session, Model model) {
        // 관리자 권한 체크
        if(session.getAttribute("loginAdmin") == null) {
            model.addAttribute("errorMsg", "관리자만 접근 가능합니다.");
            return "common/errorPage";
        }
        
        int result = service.insertBoard(board);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "공지사항이 성공적으로 등록되었습니다.");
            return "redirect:/board/list.bo";
        } else {
            model.addAttribute("errorMsg", "공지사항 등록에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // 공지사항 수정 페이지 이동 (관리자만)
    @GetMapping("updateForm.bo")
    public String boardUpdateForm(@RequestParam("bno") int noticeNum, HttpSession session, Model model) {
        // 관리자 권한 체크
        if(session.getAttribute("loginAdmin") == null) {
            model.addAttribute("errorMsg", "관리자만 접근 가능합니다.");
            return "common/errorPage";
        }
        
        Board board = service.selectBoard(noticeNum);
        model.addAttribute("board", board);
        return "board/boardUpdateForm";
    }
    
    // 공지사항 수정 처리 (관리자만)
    @PostMapping("update.bo")
    public String updateBoard(Board board, HttpSession session, Model model) {
        // 관리자 권한 체크
        if(session.getAttribute("loginAdmin") == null) {
            model.addAttribute("errorMsg", "관리자만 접근 가능합니다.");
            return "common/errorPage";
        }
        
        int result = service.updateBoard(board);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "공지사항이 성공적으로 수정되었습니다.");
            return "redirect:/board/detail.bo?bno=" + board.getNoticeNum();
        } else {
            model.addAttribute("errorMsg", "공지사항 수정에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // 공지사항 삭제 처리 (관리자만)
    @PostMapping("delete.bo")
    public String deleteBoard(@RequestParam("bno") int noticeNum, HttpSession session, Model model) {
        // 관리자 권한 체크
        if(session.getAttribute("loginAdmin") == null) {
            model.addAttribute("errorMsg", "관리자만 접근 가능합니다.");
            return "common/errorPage";
        }
        
        int result = service.deleteBoard(noticeNum);
        
        if(result > 0) {
            session.setAttribute("alertMsg", "공지사항이 성공적으로 삭제되었습니다.");
            return "redirect:/board/list.bo";
        } else {
            model.addAttribute("errorMsg", "공지사항 삭제에 실패하였습니다.");
            return "common/errorPage";
        }
    }
    
    // AJAX로 공지사항 검색 (모든 사용자)
    @ResponseBody
    @RequestMapping(value="search.bo", produces = "application/json;charset=UTF-8")
    public List<Board> searchBoard(@RequestParam("keyword") String keyword) {
        return service.searchBoard(keyword);
    }
}