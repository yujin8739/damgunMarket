package com.kh.soak.userqna.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kh.soak.member.model.vo.Member;
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
    public String insertUserQna(UserQnaInfo userQna, 
                               @RequestParam("upfile") MultipartFile upfile,
                               HttpSession session, 
                               Model model,
                               HttpServletRequest request) {
        
        Member loginUser = (Member) session.getAttribute("loginUser");
        
        if(loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "common/errorPage";
        }
        
        userQna.setUserNo(loginUser.getUserNo());
        
        // 파일 업로드 처리
        String savedFileName = null;
        if(!upfile.isEmpty()) {
            try {
                savedFileName = saveFile(upfile, request);
                userQna.setUserQnaImg(savedFileName);
            } catch (Exception e) {
                System.out.println("파일 업로드 실패: " + e.getMessage());
                e.printStackTrace();
                // 파일 업로드 실패해도 문의사항은 등록되도록 처리
            }
        }
        
        System.out.println("문의사항 작성 시도: " + userQna);
        
        try {
            int result = service.insertUserQna(userQna);
            
            if(result > 0) {
                session.setAttribute("alertMsg", "문의사항이 성공적으로 등록되었습니다.");
                return "redirect:/userqna/list.uq";
            } else {
                model.addAttribute("errorMsg", "문의사항 등록에 실패하였습니다.");
                return "common/errorPage";
            }
        } catch (Exception e) {
            System.out.println("문의사항 등록 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("errorMsg", "문의사항 등록 중 오류가 발생했습니다: " + e.getMessage());
            return "common/errorPage";
        }
    }
    
    // 문의사항 수정 페이지 이동
    @GetMapping("updateForm.uq")
    public String userQnaUpdateForm(@RequestParam("qno") int userQnaNum, HttpSession session, Model model) {
        
        Member loginUser = (Member) session.getAttribute("loginUser");
        if(loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "common/errorPage";
        }
        
        UserQnaInfo userQna = service.selectUserQna(userQnaNum);
        
        // 작성자 본인만 수정 가능
        if(userQna.getUserNo() != loginUser.getUserNo()) {
            model.addAttribute("errorMsg", "본인이 작성한 문의사항만 수정할 수 있습니다.");
            return "common/errorPage";
        }
        
        model.addAttribute("userQna", userQna);
        return "userqna/userQnaUpdateForm";
    }
    
    // 문의사항 수정 처리 (파일 업로드 처리 추가)
    @PostMapping("update.uq")
    public String updateUserQna(UserQnaInfo userQna, 
                               @RequestParam("upfile") MultipartFile upfile,
                               HttpSession session, 
                               Model model,
                               HttpServletRequest request) {
        
        Member loginUser = (Member) session.getAttribute("loginUser");
        if(loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "common/errorPage";
        }
        
        // 기존 문의사항 정보 가져오기
        UserQnaInfo existingQna = service.selectUserQna(userQna.getUserQnaNum());
        
        // 작성자 본인만 수정 가능
        if(existingQna.getUserNo() != loginUser.getUserNo()) {
            model.addAttribute("errorMsg", "본인이 작성한 문의사항만 수정할 수 있습니다.");
            return "common/errorPage";
        }
        
        // 파일 업로드 처리
        if(!upfile.isEmpty()) {
            try {
                String savedFileName = saveFile(upfile, request);
                userQna.setUserQnaImg(savedFileName);
            } catch (Exception e) {
                System.out.println("파일 업로드 실패: " + e.getMessage());
                e.printStackTrace();
                // 기존 파일 유지
                userQna.setUserQnaImg(existingQna.getUserQnaImg());
            }
        } else {
            // 새로운 파일이 없으면 기존 파일 유지
            userQna.setUserQnaImg(existingQna.getUserQnaImg());
        }
        
        try {
            int result = service.updateUserQna(userQna);
            
            if(result > 0) {
                session.setAttribute("alertMsg", "문의사항이 성공적으로 수정되었습니다.");
                return "redirect:/userqna/detail.uq?qno=" + userQna.getUserQnaNum();
            } else {
                model.addAttribute("errorMsg", "문의사항 수정에 실패하였습니다.");
                return "common/errorPage";
            }
        } catch (Exception e) {
            System.out.println("문의사항 수정 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("errorMsg", "문의사항 수정 중 오류가 발생했습니다: " + e.getMessage());
            return "common/errorPage";
        }
    }
    
    @PostMapping("delete.uq")
    public String deleteUserQna(@RequestParam("qno") int userQnaNum, HttpSession session, Model model) {
        
        Member loginUser = (Member) session.getAttribute("loginUser");
        if(loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "common/errorPage";
        }
        
        UserQnaInfo userQna = service.selectUserQna(userQnaNum);
        
        // 작성자 본인만 삭제 가능
        if(userQna.getUserNo() != loginUser.getUserNo()) {
            model.addAttribute("errorMsg", "본인이 작성한 문의사항만 삭제할 수 있습니다.");
            return "common/errorPage";
        }
        
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
    public List<UserQnaInfo> getReportQna(@RequestParam("exuserNum") int exuserNum) {
        
        List<UserQnaInfo> reportQnaList = service.selectReportQna(exuserNum);
        
        return reportQnaList;
    }
    
    // 파일 저장 메소드
    private String saveFile(MultipartFile upfile, HttpServletRequest request) throws IOException {
        String savePath = request.getSession().getServletContext().getRealPath("/resources/uploadFiles/");
        
        // 디렉토리가 없으면 생성
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        String originalFileName = upfile.getOriginalFilename();
        String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
        String savedFileName = System.currentTimeMillis() + ext;
        
        File saveFile = new File(savePath + savedFileName);
        upfile.transferTo(saveFile);
        
        System.out.println("파일 저장 완료: " + saveFile.getAbsolutePath());
        
        return savedFileName;
    }
}