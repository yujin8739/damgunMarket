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
        .message { margin-bottom: 5px; }
        .my-message { text-align: right; color: blue; }
        .other-message { text-align: left; color: green; }
        .sender { font-weight: bold; }
        .time { font-size: 0.8em; color: #888; }
        .message-input { width: calc(100% - 80px); padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .send-button { width: 70px; padding: 8px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .send-button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <h2>${chatRoom.otherUserName}(${chatRoom.otherUserId}) 채팅방 (Room No: ${chatRoom.roomNo})</h2>

    <div class="chat-container" id="chatContainer">
        <c:forEach var="msg" items="${messages}">
            <div class="message <c:if test='${msg.userId eq currentUserId}'>my-message</c:if><c:if test='${msg.userId ne currentUserId}'>other-message</c:if>">
                <span class="sender">${msg.userId}</span>: ${msg.message}
                <span class="time">(<fmt:formatDate value="${msg.sendTime}" pattern="HH:mm:ss"/>)</span>
                <c:if test="${not empty msg.imageUrl}"><br><img src="${msg.imageUrl}" width="100px"></c:if>
            </div>
        </c:forEach>
    </div>

    <input type="text" id="messageInput" class="message-input" placeholder="메시지를 입력하세요...">
    <button onclick="sendMessage()" class="send-button">전송</button>

    <script>
        var websocket;
        var roomNo = ${chatRoom.roomNo}; // JSP에서 서버로부터 받은 roomNo
        var currentUserId = '${currentUserId}'; // JSP에서 서버로부터 받은 현재 로그인된 유저 ID

        const chatContainer = document.getElementById('chatContainer');
        // 초기 스크롤 하단으로 이동
        chatContainer.scrollTop = chatContainer.scrollHeight;

        // WebSocket 연결 함수
        function connectWebSocket() {
            // location.host는 "localhost:8080"과 같이 호스트와 포트를 포함합니다.
            // ${pageContext.request.contextPath}는 "/soak"와 같이 웹 애플리케이션의 컨텍스트 경로입니다.
            // 최종적으로 "ws://localhost:8080/soak/chatting" 형태의 URL이 됩니다.
            websocket = new WebSocket("ws://" + location.host + "${pageContext.request.contextPath}/chatting");

            websocket.onopen = function(event) {
                console.log("WebSocket 연결 성공!");
                // 방 입장 시 서버에 "enter" 타입의 메시지를 보냅니다.
                var enterMessage = {
                    roomNo: roomNo,
                    userId: currentUserId,
                    message: "", // 입장 메시지는 내용이 없을 수 있습니다.
                    type: "enter" // 메시지 타입: 'enter'
                };
                websocket.send(JSON.stringify(enterMessage));
            };

            websocket.onmessage = function(event) {
                // 서버로부터 메시지 수신 시
                var receivedMessage = JSON.parse(event.data);
                console.log("메시지 수신: ", receivedMessage);
                displayMessage(receivedMessage); // 수신된 메시지를 화면에 표시
            };

            websocket.onclose = function(event) {
                console.log("WebSocket 연결 종료: ", event.code, event.reason);
                // 연결이 끊겼을 때 재연결을 시도하거나 사용자에게 알림을 줄 수 있습니다.
            };

            websocket.onerror = function(event) {
                console.error("WebSocket 오류: ", event);
                // 오류 발생 시 사용자에게 알림
            };
        }

        // 메시지 전송 함수
        function sendMessage() {
            const messageInput = document.getElementById('messageInput');
            const messageText = messageInput.value.trim();

            if (messageText === "") {
                alert("메시지를 입력해주세요.");
                return;
            }

            if (websocket.readyState === WebSocket.OPEN) {
                // 서버로 보낼 메시지 데이터 객체
                const messageData = {
                    roomNo: roomNo,
                    userId: currentUserId,
                    message: messageText,
                    imageUrl: null, // 이미지 메시지가 아니므로 null
                    type: "chat" // 메시지 타입: 'chat'
                };
                websocket.send(JSON.stringify(messageData)); // JSON 문자열로 변환하여 전송
                messageInput.value = ""; // 입력창 비우기
            } else {
                console.error("WebSocket 연결이 닫혀있습니다.");
                alert("채팅 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.");
                // 연결이 끊겼을 경우 재연결 로직을 호출할 수도 있습니다.
                // connectWebSocket();
            }
        }

        // 메시지를 화면에 표시하는 함수
        function displayMessage(msg) {
            const chatContainer = document.getElementById('chatContainer');
            const newMessageDiv = document.createElement('div');
            // 자신의 메시지는 my-message, 다른 사람 메시지는 other-message 클래스 적용
            newMessageDiv.className = 'message ' + (msg.userId === currentUserId ? 'my-message' : 'other-message');

            let messageHtml = `<span class="sender">${msg.userId}</span>: ${msg.message}`;
            if (msg.imageUrl) {
                // 이미지 URL이 있을 경우 이미지 태그 추가
                messageHtml += `<br><img src="${msg.imageUrl}" width="100px">`;
            }
            // 수신 시간 포맷 (서버에서 받은 sendTime은 ISO 8601 문자열 또는 숫자 타임스탬프일 수 있음)
            // `new Date(msg.sendTime).toLocaleTimeString()`을 사용하여 현재 로케일에 맞는 시간 포맷으로 표시
            messageHtml += `<span class="time">(${new Date(msg.sendTime).toLocaleTimeString()})</span>`;

            newMessageDiv.innerHTML = messageHtml;
            chatContainer.appendChild(newMessageDiv);
            chatContainer.scrollTop = chatContainer.scrollHeight; // 스크롤 하단으로 이동
        }

        // 페이지 로드 시 웹소켓 연결 시작
        window.onload = function() {
            connectWebSocket();
            // 엔터 키로 메시지 전송 이벤트 리스너
            document.getElementById('messageInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });
        };
    </script>
    <p><a href="${pageContext.request.contextPath}/chat/roomList">채팅방 목록으로 돌아가기</a></p>
</body>
</html>