package com.kh.soak.chat.controller;

import com.kh.soak.chat.model.service.ChatService;
import com.kh.soak.chat.model.vo.ChatParticipantVO;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;
import com.kh.soak.member.model.vo.Member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger; // 추가
import org.slf4j.LoggerFactory; // 추가

@Controller
@RequestMapping("/chat")
public class ChatController {
	private static final Logger logger = LoggerFactory.getLogger(ChatController.class); // 추가


	@Autowired
	private ChatService chatService;

	@GetMapping("/roomList")
	public String chatRoomList(HttpSession session, Model model) {
		Member loginUser = (Member) session.getAttribute("loginUser");

		if (loginUser == null) {
			return "redirect:/";
		}

		String userId = loginUser.getUserId();
		model.addAttribute("currentUserId", userId);

		List<ChatRoomVO> chatRooms = chatService.getChatRoomsByUserId(userId);

		model.addAttribute("chatRooms", chatRooms);
		return "chat/chatRoomList";
	}

	@PostMapping("/createRoom")
	@ResponseBody
	public Map<String, Object> createChatRoom(@RequestParam("user1") String user1Id,
			@RequestParam("user2") String user2Id, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		Member loginUser = (Member) session.getAttribute("loginUser");
		if (loginUser == null || !loginUser.getUserId().equals(user1Id)) {
			response.put("status", "fail");
			response.put("message", "로그인 정보가 유효하지 않습니다.");
			return response;
		}

		try {
			ChatRoomVO chatRoom = chatService.getOrCreateChatRoom(user1Id, user2Id);
			response.put("status", "success");
			response.put("roomNo", chatRoom.getRoomNo());
			response.put("message", "채팅방 생성 또는 입장 성공");
		} catch (Exception e) {
			response.put("status", "fail");
			response.put("message", "채팅방 생성/입장 실패: " + e.getMessage());
			e.printStackTrace();
		}
		return response;
	}

	@GetMapping("/enterRoom/{roomNo}")
	public ModelAndView enterChatRoom(@PathVariable("roomNo") int roomNo, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		Member loginUser = (Member) session.getAttribute("loginUser");

		if (loginUser == null) {
			mv.setViewName("redirect:/member/login");
			return mv;
		}

		String userId = loginUser.getUserId();

		ChatRoomVO chatRoom = chatService.getChatRoomByRoomNo(roomNo);
		if (chatRoom == null) {
			mv.setViewName("errorPage");
			mv.addObject("msg", "존재하지 않는 채팅방입니다.");
			return mv;
		}

		Map<String, Object> params = new HashMap<>();
		params.put("roomNo", roomNo);
		params.put("currentUserId", userId);

		// ChatService를 통해 다른 유저 ID 조회
		String otherUserId = chatService.selectOtherParticipantId(params);
		if (otherUserId != null) {
			chatRoom.setOtherUserId(otherUserId);
			// ChatService를 통해 다른 유저 이름 조회
			chatRoom.setOtherUserName(chatService.selectUserNameByUserId(otherUserId));
		}

		ChatParticipantVO participant = new ChatParticipantVO(roomNo, userId, new Date());
		chatService.updateLastVisit(participant);

		List<MessageVO> messages = chatService.getMessagesByRoomNo(roomNo);

		mv.addObject("chatRoom", chatRoom);
		mv.addObject("messages", messages);
		mv.addObject("currentUserId", userId);
		mv.setViewName("chat/chatDetail");
		
        logger.debug("ChatRoom object passed to JSP: {}", chatRoom); // 전체 ChatRoomVO 객체 로깅

		return mv;
	}
}