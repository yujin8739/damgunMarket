package com.kh.soak.chat.controller;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kh.soak.chat.model.service.ChatService;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;
import com.kh.soak.member.model.vo.Member;

@Controller
public class ChatController {

    @Autowired
    private ChatService chatService;

    // 1. 채팅방 목록 화면 이동 및 조회
    @GetMapping("/chat/roomList")
    public String chatRoomList(HttpSession session, Model model) {
        Member loginUser = (Member)session.getAttribute("loginUser");
        String userId;
        if (loginUser == null) {
            System.out.println("로그인 유저 없음. 로그인 페이지로 리다이렉트.");
            return "redirect:/member/login"; // 로그인 페이지 URL
        } else {
            userId = loginUser.getUserId();
        }

        List<ChatRoomVO> chatRooms = chatService.getChatRoomsByUserId(userId);
        model.addAttribute("chatRooms", chatRooms);
        model.addAttribute("currentUserId", userId); // chatlist.jsp에서 사용하기 위해 추가
        return "chat/chatRoomList"; // chatRoomList.jsp로 이동
    }

    // 2. 채팅방 입장 (채팅 화면으로 이동 및 메시지 로드)
    @GetMapping("/chat/enterRoom/{roomNo}")
    public String enterChatRoom(@PathVariable("roomNo") int roomNo, HttpSession session, Model model) {
        Member loginUser = (Member)session.getAttribute("loginUser");
        String userId;
        if (loginUser == null) {
            System.out.println("로그인 유저 없음. 로그인 페이지로 리다이렉트.");
            return "redirect:/member/login";
        } else {
            userId = loginUser.getUserId();
        }

        ChatRoomVO chatRoom = chatService.getChatRoomById(roomNo);
        List<MessageVO> messages = chatService.getMessagesByRoomNo(roomNo);

        // (선택 사항) 채팅방에 입장하면서 해당 유저의 마지막 방문 시간 업데이트
        // 주의: CHAT_ROOM 테이블의 USER_ID가 단일 PK인 ROOM_NO와 함께 사용되지 않으므로,
        // 이 lastVisit 업데이트는 해당 roomNo의 단일 레코드를 업데이트합니다.
        // 즉, roomNo에 매핑된 CHAT_ROOM.USER_ID가 누구든 상관없이 업데이트됩니다.
        // 이는 1:1 채팅에서 각 유저별 마지막 방문 시간을 저장하는 방식과는 다릅니다.
        // 이 부분은 팀원들과 CHAT_ROOM 테이블 설계에 대해 다시 논의하는 것이 좋습니다.
        // 현재 DB 스키마에 맞춰 USER_ID는 DB에서 KEY로 쓰이지 않으므로 업데이트 시 큰 의미가 없을 수 있습니다.
        // 그럼에도 불구하고, '0' 대신 SYSDATE로 DB에 저장하도록 lastVisit을 Date 타입으로 넘깁니다.
        ChatRoomVO updateRoom = new ChatRoomVO();
        updateRoom.setRoomNo(roomNo);
        updateRoom.setUserId(userId); // 현재 로그인 유저 ID를 넘겨줍니다. (매퍼 쿼리에 따라 활용)
        updateRoom.setLastVisit(new Date()); // 현재 시간을 Date 객체로 설정
        chatService.updateLastVisit(updateRoom); // DAO/Mapper에서 SYSDATE로 DB에 저장될 것입니다.

        model.addAttribute("chatRoom", chatRoom);
        model.addAttribute("messages", messages);
        model.addAttribute("currentUserId", userId);

        return "chat/chatRoom"; // chatRoom.jsp로 이동
    }
    
    // 3. 채팅방 생성 (예시) - 실제로는 상품 구매/판매 시 자동 생성될 수 있음
    @PostMapping("/chat/createRoom")
    @ResponseBody // AJAX 요청에 대한 JSON 응답을 위해
    public Map<String, Object> createChatRoom(@RequestParam("user1") String user1, 
                                     @RequestParam("user2") String user2) {
        Map<String, Object> response = new HashMap<String, Object>();
        try {
            // (중요) CHAT_ROOM_SEQ를 사용하여 새로운 방 번호 가져오기
            int newRoomNo = chatService.getNextChatRoomNo(); 

            // TODO: 실제 1대1 채팅방 생성 로직 강화 필요
            // - 두 유저의 조합으로 기존 채팅방이 있는지 먼저 확인하고, 있다면 기존 방 번호 반환
            // - 없다면 새로운 방 번호를 부여하고, CHAT_ROOM 테이블에 하나의 방 레코드를 삽입합니다.
            // 현재 DB 스키마(ROOM_NO만 PK)에서는 1개의 ROOM_NO에 1개의 USER_ID만 매핑됩니다.
            // 따라서 user1, user2 각각에 대한 ChatRoomVO 레코드를 삽입하는 것은 오류가 발생합니다.
            // ChatRoomVO roomUser1 = new ChatRoomVO(newRoomNo, user1, "0", "TEXT"); // 이전 코드
            // ChatRoomVO roomUser2 = new ChatRoomVO(newRoomNo, user2, "0", "TEXT"); // 이전 코드 (PK 중복 오류 발생)

            // 해결 방안: CHAT_ROOM 테이블에는 방 자체의 정보만 저장하고,
            // USER_ID 컬럼에는 방을 생성한 유저 또는 대표 유저의 ID를 저장합니다.
            ChatRoomVO newRoom = new ChatRoomVO();
            newRoom.setRoomNo(newRoomNo);
            newRoom.setUserId(user1); // user1을 방의 대표 유저로 설정
            newRoom.setLastVisit(new Date()); // 현재 시간으로 초기화
            newRoom.setChatType("TEXT"); // 기본 채팅 타입

            chatService.createChatRoom(newRoom); // 하나의 방 레코드만 삽입

            response.put("status", "success");
            response.put("roomNo", newRoomNo);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "fail");
            response.put("message", "채팅방 생성 중 오류 발생: " + e.getMessage());
        }
        return response;
    }

    // 4. 이미지 업로드 처리 (Ajax 요청으로 파일 업로드 후 URL 반환)
    @PostMapping("/uploadImage")
    @ResponseBody // JSON 응답
    public Map<String, String> uploadImage(@RequestParam("uploadFile") MultipartFile uploadFile,
                                           HttpSession session) {
        Map<String, String> result = new HashMap<String, String>();

        if (uploadFile.isEmpty()) {
            result.put("status", "error");
            result.put("message", "파일이 비어있습니다.");
            return result;
        }

        // 실제 파일이 저장될 서버 경로 설정 (web 경로 기준)
        String rootPath = session.getServletContext().getRealPath("resources");
        String savePath = rootPath + File.separator + "upload" + File.separator + "chat_images";

        File folder = new File(savePath);
        if (!folder.exists()) { // 폴더 없으면 생성
            folder.mkdirs();
        }

        String originalFileName = uploadFile.getOriginalFilename();
        String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String renameFileName = UUID.randomUUID().toString() + extension; // UUID로 고유한 파일명 생성

        try {
            File targetFile = new File(savePath, renameFileName);
            uploadFile.transferTo(targetFile); // 파일 저장

            // 클라이언트로 보낼 이미지 URL (웹 접근 경로)
            // (중요) /soak는 ContextPath입니다. 실제 프로젝트의 Context Path에 맞게 수정하세요.
            String imageUrl = session.getServletContext().getContextPath() + "/resources/upload/chat_images/" + renameFileName; // ContextPath 동적으로 가져오기
            result.put("status", "success");
            result.put("imageUrl", imageUrl);

        } catch (IOException e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "파일 업로드 중 오류 발생: " + e.getMessage());
        }
        return result;
    }
}