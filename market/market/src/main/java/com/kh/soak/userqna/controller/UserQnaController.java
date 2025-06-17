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

import com.kh.soak.answer.model.service.AnswerService;
import com.kh.soak.answer.model.vo.AnswerInfo;
import com.kh.soak.member.model.vo.Member;
import com.kh.soak.userqna.model.service.UserQnaService;
import com.kh.soak.userqna.model.vo.UserQnaInfo;

@Controller
@RequestMapping("/userqna")
public class UserQnaController {
    
    @Autowired
    private UserQnaService userQnaService;
    
    @Autowired
    private AnswerService answerService;
    
    // 문의사항 목록 페이지
    @RequestMapping("list.uq")
    public String userQnaList(@RequestParam(value="keyword", required=false) String keyword, Model model) {
        
        List<UserQnaInfo> list;
        
        if(keyword != null && !keyword.trim().isEmpty()) {
            // 검색어가 있으면 검색 결과
            list = userQnaService.searchUserQna(keyword.trim());
            model.addAttribute("keyword", keyword);
        } else {
            // 검색어가 없으면 전체 목록
            list = userQnaService.selectUserQnaList();
        }
        
        // 각 문의사항에 대해 실제 답변이 있는지 확인하여 상태 업데이트
        for(UserQnaInfo qna : list) {
            AnswerInfo answer = answerService.selectAnswerByQnaNum(qna.getUserQnaNum());
            // 실제 답변이 있으면 true, 없으면 false로 설정
            qna.setStatus(answer != null);
        }
        
        model.addAttribute("list", list);
        return "userqna/userQnaListView";
    }
    
    // 문의사항 상세보기
    @RequestMapping("detail.uq")
    public String selectQna(@RequestParam("qno") int qno, Model model) {
        // 문의사항 조회
        UserQnaInfo userQna = userQnaService.selectUserQna(qno);
        
        // 답변 조회 추가
        AnswerInfo answer = answerService.selectAnswerByQnaNum(qno);
        
        // 실제 답변 존재 여부로 상태 업데이트
        if(userQna != null) {
            userQna.setStatus(answer != null);
        }
        
        model.addAttribute("userQna", userQna);
        model.addAttribute("answer", answer); // 답변 데이터 추가
        
        return "userqna/userQnaDetailView";
    }
    
    // 문의사항 작성 페이지 이동
    @GetMapping("enrollForm.uq")
    public String userQnaEnrollForm(HttpSession session, Model model) {
        
        Member loginUser = (Member) session.getAttribute("loginUser");
        if(loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "common/errorPage";
        }
        
        return "userqna/userQnaEnrollForm";
    }
    
    // 문의사항 작성 처리
    @PostMapping("insert.uq")
    public String insertUserQna(UserQnaInfo userQna, 
                               @RequestParam(value="upfile", required=false) MultipartFile upfile,
                               HttpSession session, 
                               Model model,
                               HttpServletRequest request) {
        
        System.out.println("=== insertUserQna 시작 ===");
        System.out.println("받은 데이터: " + userQna);
        System.out.println("파일 정보: " + (upfile != null ? upfile.getOriginalFilename() : "null"));
        
        Member loginUser = (Member) session.getAttribute("loginUser");
        
        if(loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "common/errorPage";
        }
        
        // VO에 있는 userNo 필드에 로그인 사용자 번호 설정
        userQna.setUserNo(loginUser.getUserNo());
        
        // 새로 작성하는 문의사항은 답변 상태를 false로 설정
        userQna.setStatus(false);
        
        // 파일 업로드 처리
        if(upfile != null && !upfile.isEmpty()) {
            try {
                String savedFileName = saveFile(upfile, request);
                userQna.setUserQnaImg(savedFileName);
                System.out.println("파일 업로드 성공: " + savedFileName);
            } catch (Exception e) {
                System.out.println("파일 업로드 실패: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        try {
            int result = userQnaService.insertUserQna(userQna);
            System.out.println("DB 삽입 결과: " + result);
            
            if(result > 0) {
                session.setAttribute("alertMsg", "문의사항이 성공적으로 등록되었습니다.");
                return "redirect:/userqna/list.uq";
            } else {
                model.addAttribute("errorMsg", "문의사항 등록에 실패하였습니다.");
                return "common/errorPage";
            }
        } catch (Exception e) {
            System.out.println("문의사항 등록 중 오류: " + e.getMessage());
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
        
        UserQnaInfo userQna = userQnaService.selectUserQna(userQnaNum);
        
        if(userQna == null) {
            model.addAttribute("errorMsg", "존재하지 않는 문의사항입니다.");
            return "common/errorPage";
        }
        
        // 작성자 본인만 수정 가능
        if(userQna.getUserNo() != loginUser.getUserNo()) {
            model.addAttribute("errorMsg", "본인이 작성한 문의사항만 수정할 수 있습니다.");
            return "common/errorPage";
        }
        
        model.addAttribute("userQna", userQna);
        return "userqna/userQnaUpdateForm";
    }
    
    // 문의사항 수정 처리
    @PostMapping("update.uq")
    public String updateUserQna(UserQnaInfo userQna, 
                               @RequestParam(value="upfile", required=false) MultipartFile upfile,
                               HttpSession session, 
                               Model model,
                               HttpServletRequest request) {
        
        Member loginUser = (Member) session.getAttribute("loginUser");
        if(loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "common/errorPage";
        }
        
        // 기존 문의사항 정보 가져오기
        UserQnaInfo existingQna = userQnaService.selectUserQna(userQna.getUserQnaNum());
        
        if(existingQna == null) {
            model.addAttribute("errorMsg", "존재하지 않는 문의사항입니다.");
            return "common/errorPage";
        }
        
        // 작성자 본인만 수정 가능
        if(existingQna.getUserNo() != loginUser.getUserNo()) {
            model.addAttribute("errorMsg", "본인이 작성한 문의사항만 수정할 수 있습니다.");
            return "common/errorPage";
        }
        
        // userNo 설정 (VO의 필드)
        userQna.setUserNo(loginUser.getUserNo());
        
        // 기존 답변 상태 유지 (수정 시에는 답변 상태를 변경하지 않음)
        userQna.setStatus(existingQna.isStatus());
        
        // 파일 업로드 처리
        if(upfile != null && !upfile.isEmpty()) {
            try {
                // 기존 파일이 있다면 삭제
                if(existingQna.getUserQnaImg() != null && !existingQna.getUserQnaImg().isEmpty()) {
                    String oldFilePath = request.getSession().getServletContext().getRealPath("/resources/uploadFiles/" + existingQna.getUserQnaImg());
                    File oldFile = new File(oldFilePath);
                    if(oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                
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
            int result = userQnaService.updateUserQna(userQna);
            
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
    
    // 문의사항 삭제 처리
    @PostMapping("delete.uq")
    public String deleteUserQna(@RequestParam("qno") int userQnaNum, HttpSession session, Model model, HttpServletRequest request) {
        
        Member loginUser = (Member) session.getAttribute("loginUser");
        if(loginUser == null) {
            model.addAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "common/errorPage";
        }
        
        UserQnaInfo userQna = userQnaService.selectUserQna(userQnaNum);
        
        if(userQna == null) {
            model.addAttribute("errorMsg", "존재하지 않는 문의사항입니다.");
            return "common/errorPage";
        }
        
        // 작성자 본인만 삭제 가능
        if(userQna.getUserNo() != loginUser.getUserNo()) {
            model.addAttribute("errorMsg", "본인이 작성한 문의사항만 삭제할 수 있습니다.");
            return "common/errorPage";
        }
        
        try {
            // 첨부파일이 있다면 삭제
            if(userQna.getUserQnaImg() != null && !userQna.getUserQnaImg().isEmpty()) {
                String filePath = request.getSession().getServletContext().getRealPath("/resources/uploadFiles/" + userQna.getUserQnaImg());
                File file = new File(filePath);
                if(file.exists()) {
                    file.delete();
                }
            }
            
            int result = userQnaService.deleteUserQna(userQnaNum);
            
            if(result > 0) {
                session.setAttribute("alertMsg", "문의사항이 성공적으로 삭제되었습니다.");
                return "redirect:/userqna/list.uq";
            } else {
                model.addAttribute("errorMsg", "문의사항 삭제에 실패하였습니다.");
                return "common/errorPage";
            }
        } catch (Exception e) {
            System.out.println("문의사항 삭제 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("errorMsg", "문의사항 삭제 중 오류가 발생했습니다: " + e.getMessage());
            return "common/errorPage";
        }
    }
    
    // 내 문의사항 조회 (AJAX)
    @ResponseBody
    @RequestMapping(value="myQna.uq", produces = "application/json;charset=UTF-8")
    public List<UserQnaInfo> getMyQna(@RequestParam("userNo") int userNo) {
        List<UserQnaInfo> list = userQnaService.selectUserQnaByUser(userNo);
        
        // 각 문의사항에 대해 실제 답변이 있는지 확인하여 상태 업데이트
        for(UserQnaInfo qna : list) {
            AnswerInfo answer = answerService.selectAnswerByQnaNum(qna.getUserQnaNum());
            qna.setStatus(answer != null);
        }
        
        return list;
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