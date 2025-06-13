<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
<title>${chatRoom.otherUserName}(${chatRoom.otherUserId})채팅방</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

h2 {
	color: #333;
}

.chat-container {
	border: 1px solid #ccc;
	padding: 10px;
	height: 400px;
	overflow-y: scroll;
	margin-bottom: 10px;
}

.message {
	margin-bottom: 5px;
	padding: 5px;
	border-radius: 5px;
}

.my-message {
	text-align: right;
	color: blue;
	background-color: #e3f2fd;
}

.other-message {
	text-align: left;
	color: green;
	background-color: #f1f8e9;
}

.sender {
	font-weight: bold;
}

.time {
	font-size: 0.8em;
	color: #888;
	margin-left: 5px;
}

.message-input {
	width: calc(100% - 80px);
	padding: 8px;
	border: 1px solid #ccc;
	border-radius: 4px;
}

.send-button {
	width: 70px;
	padding: 8px;
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.send-button:hover {
	background-color: #0056b3;
}

.connection-status {
	padding: 5px;
	margin-bottom: 10px;
	border-radius: 4px;
	font-size: 0.9em;
}

.connected {
	background-color: #d4edda;
	color: #155724;
}

.disconnected {
	background-color: #f8d7da;
	color: #721c24;
}

.message-content {
	word-wrap: break-word;
	margin: 2px 0;
}

.message-image {
	max-width: 200px;
	margin-top: 5px;
	border-radius: 5px;
}

.new-message-notification {
	position: relative;
	bottom: 10px;
	left: 50%;
	transform: translateX(-50%);
	background-color: #ffc107;
	color: #333;
	padding: 8px 15px;
	border-radius: 20px;
	font-size: 0.9em;
	cursor: pointer;
	text-align: center;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
	display: none;
	z-index: 1000;
}
</style>
</head>
<body>
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

	<input type="text" id="messageInput" class="message-input"
		placeholder="메시지를 입력하세요...">
	<button onclick="sendMessage()" class="send-button">전송</button>

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
            
            // 간단한 해시 생성 (userId + message + 시간을 분 단위로 반올림)
            var timeForId = new Date(sendTime);
            timeForId.setSeconds(0, 0); // 초와 밀리초를 0으로 설정
            return btoa(userId + '|' + message + '|' + timeForId.toISOString());
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
    </script>
	<p>
		<a href="${pageContext.request.contextPath}/chat/roomList">채팅방
			목록으로 돌아가기</a>
	</p>
</body>
</html>