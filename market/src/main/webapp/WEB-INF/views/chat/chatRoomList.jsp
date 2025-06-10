<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>채팅방 목록</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h2 { color: #333; }
        ul { list-style-type: none; padding: 0; }
        li { border: 1px solid #ddd; margin-bottom: 10px; padding: 10px; border-radius: 5px; }
        a { text-decoration: none; color: #007bff; }
        a:hover { text-decoration: underline; }
        button { padding: 8px 15px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background-color: #218838; }
        .unread-count { color: red; font-weight: bold; margin-left: 10px; }
    </style>
</head>
<body>
    <h2>${currentUserId}님의 채팅방 목록</h2>

    <c:choose>
        <c:when test="${not empty chatRooms}">
            <ul>
                <c:forEach var="room" items="${chatRooms}">
                    <li>
                        <p><strong><c:if test="${not empty room.otherUserName}">${room.otherUserName}(${room.otherUserId})</c:if> 채팅방</strong></p>
                        <p>채팅방 번호: ${room.roomNo}</p>
                        <p>채팅 타입: ${room.chatType}</p>
                        <p>생성일자: <fmt:formatDate value="${room.createdDate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                        <p>마지막 방문: <fmt:formatDate value="${room.lastVisit}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                        <a href="${pageContext.request.contextPath}/chat/enterRoom/${room.roomNo}">
                            채팅방 입장
                            <%-- <c:if test="${room.unreadMessageCount > 0}">
                                <span class="unread-count">(${room.unreadMessageCount}개 새 메시지)</span>
                            </c:if> --%>
                        </a>
                        <hr/>
                    </li>
                </c:forEach>
            </ul>
        </c:when>
        <c:otherwise>
            <p>참여 중인 채팅방이 없습니다.</p>
        </c:otherwise>
    </c:choose>

    <h3>새 채팅방 생성 (테스트용)</h3>
    <p>상대방 ID: <input type="text" id="targetUserId" value="testuser" /></p>
    <button onclick="createTestChatRoom()">새 채팅방 생성</button>

    <script>
        function createTestChatRoom() {
            var targetUserId = document.getElementById('targetUserId').value;
            if (!targetUserId) {
                alert('상대방 ID를 입력해주세요.');
                return;
            }

            fetch('${pageContext.request.contextPath}/chat/createRoom', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'user1=${currentUserId}&user2=' + targetUserId
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    alert('채팅방 생성 성공! 방 번호: ' + data.roomNo);
                    location.reload();
                } else {
                    alert('채팅방 생성 실패: ' + data.message);
                }
            })
            .catch(error => console.error('Error:', error));
        }
    </script>

    <p><a href="${pageContext.request.contextPath}/">홈으로</a></p>
</body>
</html>