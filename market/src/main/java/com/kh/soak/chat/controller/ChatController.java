package com.kh.soak.chat.controller; // 본인의 패키지 경로

//--- 아래 import 구문들을 추가하거나 확인해주세요 ---
import java.io.File;
import java.io.IOException;
import java.util.HashMap; // uploadImage 메소드에서 사용
import java.util.Map;     // uploadImage 메소드에서 사용
import javax.servlet.http.HttpServletRequest; // 추가
import org.springframework.web.multipart.MultipartFile; // 추가

//--- 기존에 있던 다른 import 구문들 ---
import com.kh.soak.chat.model.service.ChatService;
import com.kh.soak.chat.model.vo.ChatParticipantVO;
import com.kh.soak.chat.model.vo.ChatRoomVO;
import com.kh.soak.chat.model.vo.MessageVO;
// ... (기타 필요한 VO 및 Service 클래스 import)
import com.kh.soak.member.model.vo.Member;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
@Controller
@RequestMapping("/chat")
public class ChatController {

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
			mv.setViewName("redirect:/");
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

//커밋하고 풀 해보자 
		return mv;
	}
	// ChatController.java 안에 이 메소드를 추가하세요.

	@PostMapping("/uploadImage")
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestParam("image") MultipartFile image, HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();

		// 파일이 비어있는지 확인
		if (image == null || image.isEmpty()) {
			response.put("status", "fail");
			response.put("message", "이미지 파일이 전송되지 않았습니다.");
			return response;
		}

		try {
			// saveFile 메소드를 호출하여 파일을 저장하고, 저장된 파일명을 받습니다.
			String savedFileName = saveFile(image, request);

			// 클라이언트에서 접근할 수 있는 URL 경로를 생성합니다.
			// request.getContextPath()는 "/soak" 같은 컨텍스트 경로를 반환합니다.
			String imageUrl = request.getContextPath() + "/resources/uploadFiles/" + savedFileName;

			response.put("status", "success");
			response.put("imageUrl", imageUrl);
			response.put("message", "이미지 업로드 성공");

		} catch (IOException e) {
			response.put("status", "fail");
			response.put("message", "이미지 업로드 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
		}

		return response;
	}

	// 기존에 다른 곳에 있던 saveFile 메소드를 ChatController 안으로 가져오거나,
	// 혹은 공통 유틸리티 클래스에 있다면 그대로 사용합니다.
	// 여기서는 Controller 내에 private 메소드로 두는 것을 가정합니다.
	private String saveFile(MultipartFile upfile, HttpServletRequest request) throws IOException {
		String savePath = request.getSession().getServletContext().getRealPath("/resources/uploadFiles/");

		File uploadDir = new File(savePath);
		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}

		String originalFileName = upfile.getOriginalFilename();
		String ext = "";
		if (originalFileName != null && originalFileName.contains(".")) {
			ext = originalFileName.substring(originalFileName.lastIndexOf("."));
		}

		String savedFileName = System.currentTimeMillis() + ext;

		File saveFile = new File(savePath, savedFileName); // 경로와 파일명을 분리하여 File 객체 생성
		upfile.transferTo(saveFile);

		return savedFileName;
	}

}