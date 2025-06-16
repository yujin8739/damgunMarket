<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
<title>${chatRoom.otherUserName}(${chatRoom.otherUserId})채팅방</title>
<style>
/* 기존 헤더/푸터와 어울리도록 body 스타일 조정 */
body {
	font-family: 'Noto Sans KR', sans-serif; /* 헤더의 폰트와 통일 */
	margin: 0; /* 기본 마진 제거 */
	padding: 0; /* 기본 패딩 제거 */
	background: #fafafa; /* 헤더의 배경색과 유사하게 설정 */
}

/* 메인 콘텐츠 영역을 위한 래퍼 */
.main-content {
	margin-top: 60px; /* 헤더 높이만큼 여백 추가 */
	padding: 20px;
	max-width: 800px; /* 너무 넓어지지 않도록 최대 너비 설정 */
	margin-left: auto;
	margin-right: auto; /* 중앙 정렬 */
	background-color: #fff; /* 콘텐츠 배경색 */
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	position: relative;
	/* Add this to make it the positioning context for absolute children */
	min-height: calc(100vh - 120px);
	/* Adjust based on actual header/footer heights */
	/* Example: 100vh - header_height - footer_height */
	/* This prevents footer from floating up on short content */
	display: flex;
	flex-direction: column; /* Allows content to stack vertically */
}

/* h2 스타일 조정 */
h2 {
	color: #5a4fcf; /* 헤더의 주요 색상과 맞춤 */
	text-align: center;
	margin-bottom: 20px;
	font-size: 24px;
	font-weight: 700;
}

.chat-container {
	border: 1px solid #e0e0e0; /* 테두리 색상 밝게 조정 */
	padding: 10px;
	height: 400px;
	overflow-y: scroll;
	margin-bottom: 10px;
	background-color: #fdfdfd; /* 채팅 배경색 */
	border-radius: 8px;
	flex-grow: 1;
	/* Allow chat container to take available vertical space */
}

.message {
	margin-bottom: 8px; /* 메시지 간 간격 증가 */
	padding: 8px 12px; /* 패딩 조정 */
	border-radius: 18px; /* 더 부드러운 모서리 */
	max-width: 70%; /* 메시지 너비 제한 */
	word-wrap: break-word;
	line-height: 1.4;
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.08); /* 그림자 추가 */
}

.my-message {
	margin-left: auto; /* 오른쪽 정렬 */
	background-color: #7b68ee; /* 헤더 강조색과 통일 */
	color: white;
	text-align: left; /* 메시지 내용은 왼쪽 정렬 유지 */
}

.other-message {
	margin-right: auto; /* 왼쪽 정렬 */
	background-color: #e6e6fa; /* 헤더 배경색과 통일 */
	color: #333;
	text-align: left;
}

.sender {
	font-weight: bold;
	margin-bottom: 2px; /* 보낸 사람과 메시지 내용 사이 간격 */
	display: block; /* 줄바꿈 */
	font-size: 0.9em;
	color: rgba(255, 255, 255, 0.9); /* 내 메시지의 보낸 사람 색상 */
}

.other-message .sender {
	color: #4b3bdb; /* 상대 메시지의 보낸 사람 색상 */
}

.time {
	font-size: 0.75em; /* 시간 글씨 크기 조정 */
	color: rgba(255, 255, 255, 0.7); /* 내 메시지의 시간 색상 */
	margin-top: 3px;
	display: block; /* 줄바꿈 */
	text-align: right; /* 시간 오른쪽 정렬 */
}

.other-message .time {
	color: #888; /* 상대 메시지의 시간 색상 */
}

.message-content {
	margin: 2px 0;
	font-size: 0.95em;
}

.message-image {
	max-width: 150px; /* 이미지 최대 너비 조정 */
	max-height: 150px; /* 이미지 최대 높이 추가 */
	margin-top: 8px; /* 이미지 위 간격 */
	border-radius: 8px;
	display: block; /* 이미지 아래 다른 요소와 분리 */
}

.message-input {
	width: calc(100% - 90px); /* 버튼과의 간격 고려 */
	padding: 10px 12px; /* 패딩 증가 */
	border: 1px solid #ccc;
	border-radius: 20px; /* 더 둥근 입력창 */
	font-size: 1em;
	box-sizing: border-box;
	vertical-align: middle; /* 버튼과 정렬 */
	margin-bottom: 10px; /* Space between input and notification */
}

.send-button {
	width: 80px; /* 버튼 너비 조정 */
	padding: 10px; /* 패딩 증가 */
	background-color: #7b68ee; /* 헤더 강조색과 통일 */
	color: white;
	border: none;
	border-radius: 20px; /* 더 둥근 버튼 */
	cursor: pointer;
	font-size: 1em;
	font-weight: 600;
	vertical-align: middle; /* 입력창과 정렬 */
	transition: background-color 0.2s ease;
}

.send-button:hover {
	background-color: #5a4fcf; /* 호버 색상 */
}

.connection-status {
	padding: 8px 12px; /* 패딩 조정 */
	margin-bottom: 15px;
	border-radius: 5px;
	font-size: 0.9em;
	text-align: center;
	font-weight: 500;
}

.connected {
	background-color: #d4edda;
	color: #155724;
}

.disconnected {
	background-color: #f8d7da;
	color: #721c24;
}

.new-message-notification {
	position: absolute;
	bottom: 80px;
	/* Adjust as needed, relative to the main-content bottom */
	left: 50%;
	transform: translateX(-50%);
	background-color: #ffc107; /* 알림 색상 유지 */
	color: #333;
	padding: 10px 20px;
	border-radius: 25px;
	font-size: 0.9em;
	cursor: pointer;
	text-align: center;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.25);
	display: none;
	z-index: 1000;
	white-space: nowrap; /* 텍스트 줄바꿈 방지 */
}

/* 채팅방 목록으로 돌아가기 링크 스타일 */
.back-link {
	display: block;
	text-align: center;
	margin-top: 25px;
	/* margin-bottom is implicitly handled by footer.jsp */
	font-size: 1.05em;
	color: #7b68ee; /* 헤더 강조색과 통일 */
	text-decoration: none;
	font-weight: 600;
	transition: color 0.2s ease;
}

.back-link:hover {
	color: #5a4fcf;
	text-decoration: underline;
}
</style>
</head>
<body>

	<%-- Header Include --%>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<div class="main-content">
		<h2>${chatRoom.otherUserName}(${chatRoom.otherUserId})채팅방(RoomNo:
			${chatRoom.roomNo})</h2>

		<div id="connectionStatus" class="connection-status disconnected">연결
			중...</div>

		<div class="chat-container" id="chatContainer">
			<%-- 서버에서 미리 로드된 기존 메시지들 --%>
			<c:forEach var="msg" items="${messages}">
				<div
					class="message <c:if test='${msg.userId eq currentUserId}'>my-message</c:if><c:if test='${msg.userId ne currentUserId}'>other-message</c:if>">
					<span class="sender">${msg.userId}</span>
					<div class="message-content">${msg.message}</div>
					<span class="time">(<fmt:formatDate value="${msg.sendTime}"
							pattern="HH:mm:ss" />)
					</span>
					<c:if test="${not empty msg.imageUrl}">
						<br>
						<img src="${msg.imageUrl}" class="message-image" alt="이미지">
					</c:if>
				</div>
			</c:forEach>
		</div>

		<div id="newMessageNotification" class="new-message-notification"
			onclick="scrollToBottom()">새로운 메시지가 있습니다. 클릭하여 이동</div>

		<input type="file" id="imageInput" accept="image/*"
			style="display: none;" onchange="handleImageUpload(event)">

		<div style="display: flex; align-items: center; gap: 5px;">
			<button onclick="document.getElementById('imageInput').click()"
				class="send-button" style="width: 50px; background-color: #5a4fcf;">📷</button>

			<input type="text" id="messageInput" class="message-input"
				style="width: calc(100% - 145px);" placeholder="메시지를 입력하세요...">
			<button onclick="sendMessage()" class="send-button">전송</button>
		</div>
		<p>
			<a href="${pageContext.request.contextPath}/chat/roomList"
				class="back-link">채팅방 목록으로 돌아가기</a>
		</p>
	</div>

	<script>
        var websocket;
        var roomNo = ${chatRoom.roomNo};
        var currentUserId = '${currentUserId}';
        var reconnectInterval;
        var maxReconnectAttempts = 5;
        var reconnectAttempts = 0;
        var lastMessageId = null; // 마지막 메시지 ID 추적
        var sentMessages = new Set(); // 내가 보낸 메시지 ID들을 저장하는 Set

        const chatContainer = document.getElementById('chatContainer');
        const connectionStatus = document.getElementById('connectionStatus');
        const newMessageNotification = document.getElementById('newMessageNotification');
        
        // 초기 스크롤을 맨 아래로 설정
        scrollToBottom();

        function updateConnectionStatus(isConnected, message) {
            if (isConnected) {
                connectionStatus.className = 'connection-status connected';
                connectionStatus.textContent = message || '연결됨';
            } else {
                connectionStatus.className = 'connection-status disconnected';
                connectionStatus.textContent = message || '연결 끊김';
            }
        }

        function connectWebSocket() {
            try {
                var protocol = location.protocol === 'https:' ? 'wss:' : 'ws:';
                var wsUrl = protocol + "//" + location.host + "${pageContext.request.contextPath}/chatting";
                
                console.log("WebSocket 연결 시도:", wsUrl);
                websocket = new WebSocket(wsUrl);

                websocket.onopen = function(event) {
                    console.log("WebSocket 연결 성공!");
                    updateConnectionStatus(true, '채팅 서버에 연결됨');
                    reconnectAttempts = 0;
                    
                    var enterMessage = {
                        roomNo: roomNo,
                        userId: currentUserId,
                        message: "",
                        type: "enter"
                    };
                    websocket.send(JSON.stringify(enterMessage));
                };

                websocket.onmessage = function(event) {
                    console.log("=== WebSocket 메시지 수신 ===");
                    console.log("원본 데이터:", event.data);
                    console.log("데이터 타입:", typeof event.data);
                    
                    try {
                        var receivedData;
                        
                        if (typeof event.data === 'string') {
                            receivedData = JSON.parse(event.data);
                        } else {
                            receivedData = event.data;
                        }
                        
                        console.log("파싱된 데이터:", receivedData);
                        
                        if (Array.isArray(receivedData)) {
                            console.log("배열 데이터 처리, 길이:", receivedData.length);
                            receivedData.forEach(function(messageItem, index) {
                                console.log(`배열 요소 [${index}]:`, messageItem);
                                if (messageItem && typeof messageItem === 'object') {
                                    processAndDisplayMessage(messageItem);
                                }
                            });
                        } else if (receivedData && typeof receivedData === 'object') {
                            console.log("단일 객체 데이터 처리");
                            processAndDisplayMessage(receivedData);
                        } else {
                            console.warn("예상되지 않은 데이터 형식:", receivedData);
                        }
                        
                    } catch (e) {
                        console.error("메시지 파싱 오류:", e);
                        console.error("원본 데이터:", event.data);
                    }
                };

                websocket.onclose = function(event) {
                    console.log("WebSocket 연결 종료:", event.code, event.reason);
                    updateConnectionStatus(false, '연결이 끊어짐');
                    
                    if (event.code !== 1000 && reconnectAttempts < maxReconnectAttempts) {
                        setTimeout(function() {
                            reconnectAttempts++;
                            console.log("재연결 시도:", reconnectAttempts + "/" + maxReconnectAttempts);
                            updateConnectionStatus(false, '재연결 중... (' + reconnectAttempts + '/' + maxReconnectAttempts + ')');
                            connectWebSocket();
                        }, 3000);
                    } else if (event.code !== 1000) {
                        updateConnectionStatus(false, '재연결 실패: 최대 시도 횟수 초과');
                    }
                };

                websocket.onerror = function(event) {
                    console.error("WebSocket 오류:", event);
                    updateConnectionStatus(false, '연결 오류 발생');
                };

            } catch (e) {
                console.error("WebSocket 생성 오류:", e);
                updateConnectionStatus(false, 'WebSocket 생성 실패');
            }
        }

        // 메시지 처리 및 표시 함수
        function processAndDisplayMessage(messageData) {
            console.log("=== processAndDisplayMessage 시작 ===");
            console.log("받은 메시지 데이터:", messageData);
            
            if (!messageData || typeof messageData !== 'object') {
                console.error("유효하지 않은 메시지 데이터:", messageData);
                return;
            }

            // 시스템 메시지 (enter, leave)는 표시하지 않음
            var msgType = messageData.type || 'chat';
            if (msgType === 'enter' || msgType === 'leave') {
                console.log("시스템 메시지이므로 표시하지 않음:", msgType);
                return;
            }

            // 중복 메시지 체크를 위한 고유 ID 생성
            var messageId = generateMessageId(messageData);
            
            // 내가 보낸 메시지인지 확인
            var userId = extractValue(messageData, ['userId', 'sender', 'from', 'user']) || '익명';
            var isMyMessage = (userId === currentUserId);
            
            // 내가 보낸 메시지이고 이미 표시했다면 무시
            if (isMyMessage && sentMessages.has(messageId)) {
                console.log("내가 보낸 메시지로 이미 표시됨:", messageId);
                return;
            }
            
            // 이미 표시된 메시지인지 확인
            if (isMessageAlreadyDisplayed(messageId)) {
                console.log("이미 표시된 메시지입니다:", messageId);
                return;
            }

            // 메시지 데이터 추출
            var message = extractValue(messageData, ['message', 'content', 'text', 'msg']) || '';
            var imageUrl = extractValue(messageData, ['imageUrl', 'image', 'img']) || null;
            var sendTime = extractValue(messageData, ['sendTime', 'timestamp', 'time', 'createdAt']) || new Date().toISOString();

            console.log("추출된 데이터:", { userId, message, imageUrl, sendTime });

            // 메시지 내용이 비어있는 경우 처리
            if (!message || message.trim() === '') {
                console.warn("메시지 내용이 비어있음. 객체 전체 검사 중...");
                for (var key in messageData) {
                    var value = messageData[key];
                    if (typeof value === 'string' && value.trim() !== '' && !['userId', 'type', 'roomNo', 'sendTime', 'timestamp', 'imageUrl'].includes(key)) {
                        console.log(`${key} 속성에서 메시지 발견:`, value);
                        message = value;
                        break;
                    }
                }
                if (!message || message.trim() === '') {
                    console.warn("최종적으로 메시지 내용을 찾을 수 없음");
                    return; // 메시지가 없으면 표시하지 않음
                }
            }

            // 화면에 메시지 표시 (내가 보낸 메시지가 아닌 경우만)
            if (!isMyMessage) {
                displayMessageOnScreen(userId, message, imageUrl, sendTime, messageId);
            }
        }

        // 내가 보낸 메시지 ID를 저장하는 함수
        function addToSentMessages(messageId) {
            sentMessages.add(messageId);
            // 메모리 절약을 위해 최대 100개까지만 저장
            if (sentMessages.size > 100) {
                var firstItem = sentMessages.values().next().value;
                sentMessages.delete(firstItem);
            }
        }

        // 메시지 고유 ID 생성 함수
        function generateMessageId(messageData) {
    var userId = extractValue(messageData, ['userId', 'sender', 'from', 'user']) || 'unknown';
    var message = extractValue(messageData, ['message', 'content', 'text', 'msg']) || '';
    var sendTime = extractValue(messageData, ['sendTime', 'timestamp', 'time', 'createdAt']) || new Date().toISOString();
    
    var timeForId = new Date(sendTime);
    timeForId.setSeconds(0, 0); // 초와 밀리초를 0으로 설정

    // 1. 인코딩할 전체 문자열을 만듭니다.
    const stringToEncode = userId + '|' + message + '|' + timeForId.toISOString();
    
    // 2. encodeURIComponent로 먼저 인코딩한 후, 그 결과를 btoa로 인코딩합니다.
    return btoa(encodeURIComponent(stringToEncode));
}

        // 이미 표시된 메시지인지 확인하는 함수
        function isMessageAlreadyDisplayed(messageId) {
            var existingMessages = chatContainer.querySelectorAll('.message[data-message-id="' + messageId + '"]');
            return existingMessages.length > 0;
        }

        // 객체에서 값을 추출하는 헬퍼 함수
        function extractValue(obj, keys) {
            for (var i = 0; i < keys.length; i++) {
                var key = keys[i];
                if (obj.hasOwnProperty(key) && obj[key] !== null && obj[key] !== undefined) {
                    var value = obj[key];
                    if (typeof value === 'string' && value.trim() !== '') {
                        return value.trim();
                    } else if (typeof value !== 'string' && value !== '') {
                        return value;
                    }
                }
            }
            return null;
        }

        // 화면에 메시지를 표시하는 함수
        function displayMessageOnScreen(userId, message, imageUrl, sendTime, messageId) {
            console.log("=== displayMessageOnScreen 시작 ===");
            console.log("표시할 데이터:", {userId, message, imageUrl, sendTime, messageId});

            const newMessageDiv = document.createElement('div');
            
            // 메시지 ID를 data 속성으로 저장하여 중복 체크에 사용
            if (messageId) {
                newMessageDiv.setAttribute('data-message-id', messageId);
            }
            
            // 메시지 스타일 결정
            var isMyMessage = (userId === currentUserId);
            newMessageDiv.className = 'message ' + (isMyMessage ? 'my-message' : 'other-message');

            // 시간 포맷팅
            var timeStr = '';
            try {
                if (sendTime) {
                    var dateVal = typeof sendTime === 'string' ? sendTime : parseInt(sendTime);
                    var messageDate = new Date(dateVal);
                    if (!isNaN(messageDate.getTime())) {
                        timeStr = messageDate.toLocaleTimeString('ko-KR', {
                            hour: '2-digit',
                            minute: '2-digit',
                            second: '2-digit',
                            hour12: false
                        });
                    }
                }
            } catch (e) {
                console.error("시간 파싱 오류:", e);
            }
            
            if (!timeStr) {
                timeStr = new Date().toLocaleTimeString('ko-KR', {
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: false
                });
            }

            // HTML 생성
            var messageHtml = '<span class="sender">' + escapeHtml(userId) + '</span>';
            messageHtml += '<div class="message-content">' + escapeHtml(message) + '</div>';
            messageHtml += '<span class="time">(' + timeStr + ')</span>';
            
            if (imageUrl) {
                messageHtml += '<br><img src="' + escapeHtml(imageUrl) + '" class="message-image" alt="전송된 이미지">';
            }

            newMessageDiv.innerHTML = messageHtml;
            chatContainer.appendChild(newMessageDiv);
            
            // 스크롤 처리
            if (isMyMessage || isScrolledToBottom()) {
                scrollToBottom();
                hideNewMessageNotification();
            } else {
                showNewMessageNotification();
            }
            
            console.log("메시지가 화면에 추가되었습니다.");
            console.log("=== displayMessageOnScreen 종료 ===");
        }

        // HTML 이스케이프 함수 (XSS 방지)
        function escapeHtml(text) {
            if (typeof text !== 'string') {
                return String(text || '');
            }
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function sendMessage() {
            const messageInput = document.getElementById('messageInput');
            const messageText = messageInput.value.trim();

            if (messageText === "") {
                alert("메시지를 입력해주세요.");
                return;
            }

            // WebSocket 연결 상태 확인
            if (!websocket || websocket.readyState !== WebSocket.OPEN) {
                alert("채팅 서버에 연결되지 않았습니다. 잠시 후 다시 시도해주세요.");
                connectWebSocket();
                return;
            }

            try {
                const messageData = {
                    roomNo: roomNo,
                    userId: currentUserId,
                    message: messageText,
                    imageUrl: null,
                    type: "chat",
                    sendTime: new Date().toISOString()
                };
                
                console.log("메시지 전송:", messageData);
                
                // 메시지 ID 미리 생성하여 중복 방지를 위해 저장
                const messageId = generateMessageId(messageData);
                addToSentMessages(messageId);
                
                websocket.send(JSON.stringify(messageData));
                messageInput.value = "";
                messageInput.focus();

                // 내가 보낸 메시지는 즉시 표시하고, 서버 응답은 무시하도록 처리
                displayMessageOnScreen(messageData.userId, messageData.message, messageData.imageUrl, messageData.sendTime, messageId);

            } catch (e) {
                console.error("메시지 전송 오류:", e);
                alert("메시지 전송에 실패했습니다. 다시 시도해주세요.");
            }
        }

        // 페이지가 닫힐 때 WebSocket 정리
        window.addEventListener('beforeunload', function() {
            if (websocket && websocket.readyState === WebSocket.OPEN) {
                var leaveMessage = {
                    roomNo: roomNo,
                    userId: currentUserId,
                    message: "",
                    type: "leave"
                };
                websocket.send(JSON.stringify(leaveMessage));
            }
        });

        // 페이지 로드 완료 후 초기화
        window.onload = function() {
            connectWebSocket();
            
            // Enter key to send message
            document.getElementById('messageInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    sendMessage();
                }
            });
            
            // 스크롤 이벤트 리스너 추가
            chatContainer.addEventListener('scroll', handleChatScroll);
            
            document.getElementById('messageInput').focus();
        };

        // 주기적으로 연결 상태 확인
        setInterval(function() {
            if (!websocket || websocket.readyState === WebSocket.CLOSED) {
                console.log("연결 상태 확인: 연결 끊어짐");
                updateConnectionStatus(false, '연결 끊어짐');
            }
        }, 10000);

        // 스크롤 관련 함수들
        function isScrolledToBottom() {
            const scrollHeight = chatContainer.scrollHeight;
            const scrollTop = chatContainer.scrollTop;
            const clientHeight = chatContainer.clientHeight;
            return (scrollTop + clientHeight >= scrollHeight - 10); 
        }

        function scrollToBottom() {
            chatContainer.scrollTop = chatContainer.scrollHeight;
            hideNewMessageNotification();
        }

        function showNewMessageNotification() {
            newMessageNotification.style.display = 'block';
        }

        function hideNewMessageNotification() {
            newMessageNotification.style.display = 'none';
        }

        function handleChatScroll() {
            if (isScrolledToBottom()) {
                hideNewMessageNotification();
            }
        }
     // [필수 확인] 이 함수가 <script> 태그 안에 있는지 확인해주세요.
     // 이미지 파일을 선택했을 때 호출되는 함수입니다.
     function handleImageUpload(event) {
         const file = event.target.files[0];
         if (!file) {
             return;
         }

         const formData = new FormData();
         formData.append('image', file);

         updateConnectionStatus(true, '이미지 업로드 중...');

         fetch('${pageContext.request.contextPath}/chat/uploadImage', {
             method: 'POST',
             body: formData
         })
         .then(response => response.json())
         .then(data => {
             if (data.status === 'success') {
                 console.log("이미지 업로드 성공:", data.imageUrl);
                 // 업로드 성공 시, 이미지 URL을 웹소켓으로 전송합니다.
                 sendImageMessage(data.imageUrl);
                 updateConnectionStatus(true, '채팅 서버에 연결됨');
             } else {
                 alert('이미지 업로드 실패: ' + data.message);
                 updateConnectionStatus(true, '채팅 서버에 연결됨');
             }
         })
         .catch(error => {
             console.error('이미지 업로드 fetch 오류:', error);
             alert('이미지 업로드 중 오류가 발생했습니다.');
             updateConnectionStatus(true, '채팅 서버에 연결됨');
         });

         event.target.value = null;
     }

     // [필수 확인] 이 함수도 함께 있어야 합니다.
     // 이미지 URL을 포함한 메시지를 웹소켓으로 전송하는 함수입니다.
     function sendImageMessage(imageUrl) {
         if (!websocket || websocket.readyState !== WebSocket.OPEN) {
             alert("채팅 서버에 연결되지 않았습니다.");
             return;
         }

         try {
             const messageData = {
                 roomNo: roomNo,
                 userId: currentUserId,
                 message: "(사진)",
                 imageUrl: imageUrl,
                 type: "chat",
                 sendTime: new Date().toISOString()
             };
             
             console.log("이미지 메시지 전송:", messageData);
             
             const messageId = generateMessageId(messageData);
             addToSentMessages(messageId);
             
             websocket.send(JSON.stringify(messageData));

             displayMessageOnScreen(messageData.userId, messageData.message, messageData.imageUrl, messageData.sendTime, messageId);

         } catch (e) {
             console.error("이미지 메시지 전송 오류:", e);
             alert("이미지 메시지 전송에 실패했습니다.");
         }
     }
        
    </script>

	<%-- Footer Include --%>
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>
</body>
</html>