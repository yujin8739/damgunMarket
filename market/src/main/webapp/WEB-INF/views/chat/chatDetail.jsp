<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>${chatRoom.otherUserName}(${chatRoom.otherUserId}) 채팅방</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h2 { color: #333; }
        .chat-container { border: 1px solid #ccc; padding: 10px; height: 400px; overflow-y: scroll; margin-bottom: 10px; }
        .message { margin-bottom: 5px; padding: 5px; border-radius: 5px; }
        .my-message { text-align: right; color: blue; background-color: #e3f2fd; }
        .other-message { text-align: left; color: green; background-color: #f1f8e9; }
        .sender { font-weight: bold; }
        .time { font-size: 0.8em; color: #888; margin-left: 5px; }
        .message-input { width: calc(100% - 80px); padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .send-button { width: 70px; padding: 8px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .send-button:hover { background-color: #0056b3; }
        .connection-status { padding: 5px; margin-bottom: 10px; border-radius: 4px; font-size: 0.9em; }
        .connected { background-color: #d4edda; color: #155724; }
        .disconnected { background-color: #f8d7da; color: #721c24; }
        .message-content { word-wrap: break-word; margin: 2px 0; }
        .message-image { max-width: 200px; margin-top: 5px; border-radius: 5px; }
    </style>
</head>
<body>
    <h2>${chatRoom.otherUserName}(${chatRoom.otherUserId}) 채팅방 (Room No: ${chatRoom.roomNo})</h2>

    <div id="connectionStatus" class="connection-status disconnected">연결 중...</div>

    <div class="chat-container" id="chatContainer">
        <%-- 서버에서 미리 로드된 기존 메시지들 --%>
        <c:forEach var="msg" items="${messages}">
            <div class="message <c:if test='${msg.userId eq currentUserId}'>my-message</c:if><c:if test='${msg.userId ne currentUserId}'>other-message</c:if>">
                <span class="sender">${msg.userId}</span>
                <div class="message-content">${msg.message}</div>
                <span class="time">(<fmt:formatDate value="${msg.sendTime}" pattern="HH:mm:ss"/>)</span>
                <c:if test="${not empty msg.imageUrl}"><br><img src="${msg.imageUrl}" class="message-image" alt="이미지"></c:if>
            </div>
        </c:forEach>
    </div>

    <input type="text" id="messageInput" class="message-input" placeholder="메시지를 입력하세요...">
    <button onclick="sendMessage()" class="send-button">전송</button>

    <script>
        var websocket;
        var roomNo = ${chatRoom.roomNo};
        var currentUserId = '${currentUserId}';
        var reconnectInterval;
        var maxReconnectAttempts = 5;
        var reconnectAttempts = 0;

        const chatContainer = document.getElementById('chatContainer');
        const connectionStatus = document.getElementById('connectionStatus');
        
        // 초기 스크롤을 맨 아래로 설정
        chatContainer.scrollTop = chatContainer.scrollHeight;

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
                        
                        // 배열인지 확인
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

        // 메시지 처리 및 표시 함수 (핵심 수정 부분)
        function processAndDisplayMessage(messageData) {
            console.log("=== processAndDisplayMessage 시작 ===");
            console.log("받은 메시지 데이터:", messageData);
            console.log("메시지 데이터 타입:", typeof messageData);
            
            if (!messageData || typeof messageData !== 'object') {
                console.error("유효하지 않은 메시지 데이터:", messageData);
                return;
            }

            // 메시지 타입 확인 (시스템 메시지는 표시하지 않음)
            var msgType = messageData.type || 'chat';
            if (msgType === 'enter' || msgType === 'leave') {
                console.log("시스템 메시지이므로 표시하지 않음:", msgType);
                return;
            }

            // 메시지 데이터 추출
            var userId = extractValue(messageData, ['userId', 'sender', 'from', 'user']) || '익명';
            var message = extractValue(messageData, ['message', 'content', 'text', 'msg']) || '';
            var imageUrl = extractValue(messageData, ['imageUrl', 'image', 'img']) || null;
            var sendTime = extractValue(messageData, ['sendTime', 'timestamp', 'time', 'createdAt']) || new Date().toISOString();

            console.log("추출된 데이터:");
            console.log("- userId:", userId);
            console.log("- message:", message);
            console.log("- imageUrl:", imageUrl);
            console.log("- sendTime:", sendTime);

            // 메시지 내용이 비어있는 경우 전체 객체 내용 검사
            if (!message || message.trim() === '') {
                console.warn("메시지 내용이 비어있음. 객체 전체 검사 중...");
                
                // 객체의 모든 속성을 검사하여 문자열 값 찾기
                for (var key in messageData) {
                    var value = messageData[key];
                    if (typeof value === 'string' && value.trim() !== '' && 
                        !['userId', 'type', 'roomNo', 'sendTime', 'timestamp'].includes(key)) {
                        console.log(`${key} 속성에서 메시지 발견:`, value);
                        message = value;
                        break;
                    }
                }

                // 여전히 메시지가 없으면 디버그 정보 표시
                if (!message || message.trim() === '') {
                    message = "빈 메시지 (디버그: " + JSON.stringify(messageData) + ")";
                    console.warn("최종적으로 메시지 내용을 찾을 수 없음");
                }
            }

            // 화면에 메시지 표시
            displayMessageOnScreen(userId, message, imageUrl, sendTime);
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
        function displayMessageOnScreen(userId, message, imageUrl, sendTime) {
            console.log("=== displayMessageOnScreen 시작 ===");
            console.log("표시할 데이터:", {userId, message, imageUrl, sendTime});

            const newMessageDiv = document.createElement('div');
            
            // 메시지 스타일 결정
            var isMyMessage = (userId === currentUserId);
            newMessageDiv.className = 'message ' + (isMyMessage ? 'my-message' : 'other-message');

            // 시간 포맷팅
            var timeStr = '';
            try {
                if (sendTime) {
                    var messageDate = new Date(sendTime);
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
            
            // 스크롤을 맨 아래로
            chatContainer.scrollTop = chatContainer.scrollHeight;
            
            console.log("메시지가 화면에 추가되었습니다.");
            console.log("=== displayMessageOnScreen 종료 ===");
        }

        // HTML 이스케이프 함수
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
                websocket.send(JSON.stringify(messageData));
                messageInput.value = "";
                messageInput.focus();

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
                websocket.close();
            }
        });

        // 페이지 로드 완료 후 초기화
        window.onload = function() {
            connectWebSocket();
            
            document.getElementById('messageInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    sendMessage();
                }
            });
            
            document.getElementById('messageInput').focus();
        };

        // 주기적으로 연결 상태 확인
        setInterval(function() {
            if (!websocket || websocket.readyState === WebSocket.CLOSED) {
                console.log("연결 상태 확인: 연결 끊어짐");
                updateConnectionStatus(false, '연결 끊어짐');
            }
        }, 10000);

    </script>
    <p><a href="${pageContext.request.contextPath}/chat/roomList">채팅방 목록으로 돌아가기</a></p>
</body>
</html>