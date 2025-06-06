<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채팅방 ${chatRoom.roomNo}</title>
    <style>
        #chatMessages { 
            border: 1px solid #ccc; 
            height: 400px; 
            overflow-y: scroll; 
            padding: 10px; 
            margin-bottom: 10px; 
            background-color: #f9f9f9;
        }
        .message-item { 
            margin-bottom: 8px; 
            padding: 5px 10px;
            border-radius: 8px;
            max-width: 70%;
            word-wrap: break-word;
        }
        .my-message { 
            background-color: #dcf8c6; 
            margin-left: auto; /* 오른쪽 정렬 */
            text-align: right;
        }
        .other-message { 
            background-color: #ffffff; 
            margin-right: auto; /* 왼쪽 정렬 */
            text-align: left;
            border: 1px solid #eee;
        }
        .sender { 
            font-weight: bold; 
            font-size: 0.9em; 
            color: #555;
            display: block; /* 줄 바꿈 */
            margin-bottom: 2px;
        }
        .time { 
            font-size: 0.7em; 
            color: #888; 
            display: block;
            margin-top: 2px;
        }
        .message-content {
            font-size: 1em;
            color: #333;
        }
        .message-item img {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
            margin-top: 5px;
        }
        #chatControls {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        #messageInput {
            flex-grow: 1;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        #sendMessageBtn, #imageInputLabel {
            padding: 8px 15px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        #sendMessageBtn:hover, #imageInputLabel:hover {
            background-color: #0056b3;
        }
        #imageInput {
            display: none; /* 실제 파일 입력 필드는 숨김 */
        }
    </style>
</head>
<body>
    <h1>채팅방: ${chatRoom.roomNo}</h1>
    <p>현재 사용자: ${currentUserId}</p>
    <hr>

    <div id="chatMessages">
        <c:forEach var="msg" items="${messages}">
            <div class="message-item ${msg.userId eq currentUserId ? 'my-message' : 'other-message'}">
                <span class="sender">${msg.userId}</span>
                <div class="message-content">
                    <c:choose>
                        <c:when test="${not empty msg.imageUrl}">
                            <img src="${pageContext.request.contextPath}${msg.imageUrl}" alt="이미지 메시지">
                        </c:when>
                        <c:otherwise>
                            ${msg.message}
                        </c:otherwise>
                    </c:choose>
                </div>
                <span class="time"><fmt:formatDate value="${msg.sendTime}" pattern="(yyyy.MM.dd HH:mm:ss)"/></span>
            </div>
        </c:forEach>
    </div>

    <div id="chatControls">
        <input type="text" id="messageInput" placeholder="메시지를 입력하세요">
        <label for="imageInput" id="imageInputLabel">이미지</label>
        <input type="file" id="imageInput" accept="image/*">
        <button id="sendMessageBtn">전송</button>
    </div>
    <br>
    <button onclick="history.back()">뒤로가기</button>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // WebSocket 연결 설정
        var host = window.location.host; 
        // Context Path를 동적으로 가져와 웹소켓 경로에 추가
        var contextPath = "${pageContext.request.contextPath}";
        var ws = new WebSocket("ws://" + host + contextPath + "/chatting");

        var roomNo = ${chatRoom.roomNo};
        var currentUserId = '${currentUserId}';

        // WebSocket 연결 성공 시
        ws.onopen = function() {
            console.log("WebSocket 연결 성공!");
            // 웹소켓 연결 성공 시, 서버의 ChatWebSocketHandler에 이 세션이 어떤 방에 속하는지 알립니다.
            var entryMessage = {
                type: "enter", // 메시지 타입: "enter"
                roomNo: roomNo,
                userId: currentUserId,
                message: currentUserId + "님이 입장했습니다."
            };
            ws.send(JSON.stringify(entryMessage));
        };

        // 메시지 수신 시
        ws.onmessage = function(event) {
            var receivedMessage = JSON.parse(event.data);
            console.log("메시지 수신:", receivedMessage);

            // 메시지 타입에 따라 처리
            if (receivedMessage.type === "enter") {
                console.log(receivedMessage.message);
                return; // 입장 메시지는 UI에 표시하지 않음 (선택 사항)
            }

            var messageArea = $('#chatMessages');
            var messageClass = receivedMessage.userId === currentUserId ? 'my-message' : 'other-message';
            
            // 날짜 형식 포맷
            // JavaScript Date 객체로 변환 시, 밀리초 단위로 변환되어 넘어와야 합니다.
            // Spring JSON 직렬화 시 @JsonFormat 등을 사용하면 더 정확한 포맷이 가능합니다.
            // 현재는 Date 객체를 직접 넘기므로, JS에서 Date 객체 생성 후 포맷팅합니다.
            var sendTime = new Date(receivedMessage.sendTime); 
            var formattedTime = sendTime.toLocaleString('ko-KR', { 
                year: 'numeric', month: '2-digit', day: '2-digit', 
                hour: '2-digit', minute: '2-digit', second: '2-digit', 
                hour12: false 
            });

            var messageContentHtml;
            if (receivedMessage.imageUrl) {
                // 이미지 URL에 contextPath 추가
                messageContentHtml = `<img src="${contextPath}${receivedMessage.imageUrl}" alt="이미지 메시지">`;
            } else {
                messageContentHtml = receivedMessage.message;
            }

            var messageHtml = `
                <div class="message-item ${messageClass}">
                    <span class="sender">${receivedMessage.userId}</span>
                    <div class="message-content">
                        ${messageContentHtml}
                    </div>
                    <span class="time">(${formattedTime})</span>
                </div>
            `;
            messageArea.append(messageHtml);
            messageArea.scrollTop(messageArea[0].scrollHeight); // 스크롤 최하단으로 이동
        };

        // 연결 끊김 시
        ws.onclose = function(event) {
            console.log("WebSocket 연결 종료:", event.code, event.reason);
        };

        // 에러 발생 시
        ws.onerror = function(event) {
            console.error("WebSocket 오류:", event);
        };

        // 메시지 전송 버튼 클릭 시
        $('#sendMessageBtn').on('click', function() {
            var messageInput = $('#messageInput');
            var imageInput = $('#imageInput');
            var messageText = messageInput.val();
            var imageFile = imageInput[0].files[0]; // 선택된 이미지 파일

            if (messageText.trim() === '' && !imageFile) {
                alert('메시지를 입력하거나 이미지를 선택하세요.');
                return;
            }

            // 이미지 파일이 있을 경우 먼저 HTTP로 업로드 후 URL 받기
            if (imageFile) {
                var formData = new FormData();
                formData.append('uploadFile', imageFile); 
                
                $.ajax({
                    url: contextPath + '/uploadImage', // ContextPath 동적으로 가져오기
                    type: 'POST',
                    data: formData,
                    processData: false, // FormData 사용 시 필수
                    contentType: false, // FormData 사용 시 필수
                    success: function(response) {
                        if (response.status === 'success') {
                            sendWebSocketMessage(messageText, response.imageUrl);
                        } else {
                            alert('이미지 업로드 실패: ' + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Image Upload Error:", error);
                        alert('오류 발생: ' + error);
                    }
                });
            } else {
                // 이미지 없으면 빈 문자열 전달
                sendWebSocketMessage(messageText, ''); 
            }
        });

        // WebSocket을 통해 메시지 전송 함수
        function sendWebSocketMessage(messageText, imageUrl) {
            var messageObject = {
                type: "chat", // 메시지 타입: "chat" (일반 채팅 메시지)
                roomNo: roomNo,
                userId: currentUserId,
                message: messageText,
                imageUrl: imageUrl // 이미지 URL이 없으면 빈 문자열
            };
            ws.send(JSON.stringify(messageObject)); // JSON 형태로 전송

            // 입력 필드 초기화
            $('#messageInput').val(''); 
            $('#imageInput').val(''); // 파일 입력 초기화
        }

        // 엔터 키로 메시지 전송
        $('#messageInput').on('keypress', function(e) {
            if (e.which === 13) { // Enter key
                $('#sendMessageBtn').click();
            }
        });

        // 초기 스크롤을 최하단으로
        $(document).ready(function() {
            $('#chatMessages').scrollTop($('#chatMessages')[0].scrollHeight);
        });
    </script>
</body>
</html>