//package com.kh.soak.chat.controller; // 테스트용으로 분리된 패키지
//
//import com.kh.soak.member.model.vo.Member; // Member VO 임포트
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import javax.servlet.http.HttpSession;
//
//@Controller
//public class DummyLoginController {
//
//    // 이 URL로 접근하면 세션에 더미 유저 정보를 넣어줍니다.
//    // http://localhost:8088/soak/dummyLogin?userId=testUser01
//    // 또는 http://localhost:8088/soak/dummyLogin?userId=testUser02
//    @GetMapping("/dummyLogin")
//    public String dummyLogin(@RequestParam(value = "userId", defaultValue = "user01") String userId, HttpSession session) {
//    	System.out.println("오냐?");
//        // 더미 Member 객체 생성 (실제 DB에 있는 ID와 일치시켜도 좋습니다)
//        // user01, user02 등 DB에 미리 넣어둔 유저 ID를 활용하면 됩니다.
//        Member dummyMember = new Member();
//        dummyMember.setUserId(userId);
//        dummyMember.setUserName(userId + "님"); // 예시로 이름도 설정
//
//        // 세션에 "loginUser"라는 이름으로 Member 객체 저장 (ChatController에서 사용되는 세션 속성명과 동일하게)
//        session.setAttribute("loginUser", dummyMember);
//        System.out.println("오냐?");
//        System.out.println("세션에 더미 로그인 유저 추가됨: " + dummyMember.getUserId());
//
//        // 더미 로그인 후 채팅방 목록 페이지로 리다이렉트
//        return "redirect:/chat/roomList";
//    }
//
//    // 세션에서 로그인 유저를 제거하는 로그아웃 (테스트용)
//    @GetMapping("/dummyLogout")
//    public String dummyLogout(HttpSession session) {
//        session.invalidate(); // 세션 무효화
//        System.out.println("더미 로그인 세션 제거됨.");
//        return "redirect:/"; // 홈 또는 로그인 페이지로 리다이렉트
//    }
//}