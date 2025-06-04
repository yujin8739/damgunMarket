<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채팅방 목록</title>
</head>
<body>
    <h1>${currentUserId}님의 채팅방 목록</h1> <hr>
    
    <button onclick="createRandomRoom()">랜덤 채팅방 생성 (테스트용)</button>
    <br><br>

    <c:if test="${empty chatRooms}">
        <p>참여 중인 채팅방이 없습니다.</p>
    </c:if>
    <c:if test="${not empty chatRooms}">
        <ul>
            <c:forEach var="room" items="${chatRooms}">
                <li>
                    <a href="${pageContext.request.contextPath}/chat/enterRoom/${room.roomNo}">
                        채팅방 ${room.roomNo} 
                        (개설 유저: ${room.userId} / 마지막 방문: ${room.lastVisit})
                    </a>
                </li>
            </c:forEach>
        </ul>
    </c:if>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function createRandomRoom() {
            var user1 = '${currentUserId}'; // 현재 로그인 유저 ID
            var user2 = prompt("채팅할 상대방 ID를 입력하세요 (예: user02, user03 등)");
            if (!user2) {
                alert("상대방 ID를 입력해야 합니다.");
                return;
            }

            if (user1 === user2) {
                alert("자신과 채팅할 수 없습니다.");
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/chat/createRoom',
                type: 'POST',
                data: { user1: user1, user2: user2 },
                success: function(response) {
                    if (response.status === 'success') {
                        alert('채팅방 ' + response.roomNo + '이(가) 생성되었습니다.');
                        location.href = '${pageContext.request.contextPath}/chat/enterRoom/' + response.roomNo;
                    } else {
                        alert('채팅방 생성 실패: ' + response.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("채팅방 생성 오류:", error);
                    alert('채팅방 생성 중 오류 발생: ' + error);
                }
            });
        }
    </script>
</body>
</html>