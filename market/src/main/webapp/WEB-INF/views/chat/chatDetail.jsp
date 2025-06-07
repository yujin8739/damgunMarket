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
        var roomNo = ${chatRoom.roomNo};
        var currentUserId = '${currentUserId}';

        const chatContainer = document.getElementById('chatContainer');
        // 초기 스크롤 하단으로 이동
        chatContainer.scrollTop = chatContainer.scrollHeight;

        function connectWebSocket() {
            websocket = new WebSocket("ws://" + location.host + "${pageContext.request.contextPath}/chatting");

            websocket.onopen = function(event) {
                console.log("WebSocket 연결 성공!");
                var enterMessage = {
                    roomNo: roomNo,
                    userId: currentUserId,
                    message: "",
                    type: "enter"
                };
                websocket.send(JSON.stringify(enterMessage));
            };

            websocket.onmessage = function(event) {
                var receivedMessage = JSON.parse(event.data);
                console.log("메시지 수신: ", receivedMessage);
                displayMessage(receivedMessage); // 수신된 메시지를 화면에 표시
            };

            websocket.onclose = function(event) {
                console.log("WebSocket 연결 종료: ", event.code, event.reason);
                // 연결이 끊겼을 때 재연결을 시도하거나 사용자에게 알림을 줄 수 있습니다.
                // 5초 후에 재연결 시도 (옵션)
                // setTimeout(connectWebSocket, 5000);
            };

            websocket.onerror = function(event) {
                console.error("WebSocket 오류: ", event);
                // 오류 발생 시 사용자에게 알림
            };
        }

        function sendMessage() {
            const messageInput = document.getElementById('messageInput');
            const messageText = messageInput.value.trim();

            if (messageText === "") {
                alert("메시지를 입력해주세요.");
                return;
            }

            if (websocket.readyState === WebSocket.OPEN) {
                const messageData = {
                    roomNo: roomNo,
                    userId: currentUserId,
                    message: messageText,
                    imageUrl: null,
                    type: "chat",
                    // sendTime을 클라이언트에서 현재 시간으로 설정하여 바로 표시
                    // 서버로 보내면 서버에서 다시 설정하겠지만, 화면에 즉시 보이게 하기 위함.
                    sendTime: new Date().toISOString()
                };
                websocket.send(JSON.stringify(messageData));
                messageInput.value = "";

                // **자신이 보낸 메시지도 즉시 화면에 추가**
                displayMessage(messageData);

            } else {
                console.error("WebSocket 연결이 닫혀있습니다.");
                alert("채팅 서버에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.");
            }
        }

        function displayMessage(msg) {
            const chatContainer = document.getElementById('chatContainer');
            const newMessageDiv = document.createElement('div');
            newMessageDiv.className = 'message ' + (msg.userId === currentUserId ? 'my-message' : 'other-message');

            let messageHtml = `<span class="sender">${msg.userId}</span>: ${msg.message}`;
            if (msg.imageUrl) {
                messageHtml += `<br><img src="${msg.imageUrl}" width="100px">`;
            }
            
            // `sendTime`이 유효한지 확인하고 포맷팅
            let messageTimeStr = '';
            try {
                // msg.sendTime이 없거나 유효하지 않은 경우 대비
                const messageDate = new Date(msg.sendTime);
                if (!isNaN(messageDate.getTime())) { // 유효한 Date 객체인지 확인
                    messageTimeStr = messageDate.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
                } else {
                    console.warn("Invalid sendTime received:", msg.sendTime);
                    messageTimeStr = "시간정보없음"; // 또는 다른 기본값
                }
            } catch (e) {
                console.error("Error parsing sendTime:", msg.sendTime, e);
                messageTimeStr = "시간정보없음";
            }
            messageHtml += `<span class="time">(${messageTimeStr})</span>`;

            newMessageDiv.innerHTML = messageHtml;
            chatContainer.appendChild(newMessageDiv);
            chatContainer.scrollTop = chatContainer.scrollHeight; // 스크롤 하단으로 이동
        }

        window.onload = function() {
            connectWebSocket();
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