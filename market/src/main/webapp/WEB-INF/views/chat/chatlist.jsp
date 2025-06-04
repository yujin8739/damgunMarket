<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>채팅방 목록</title>
<style>
.chat-room {
	border: 1px solid #ccc;
	padding: 10px;
	margin: 10px;
	cursor: pointer;
}

.chat-type {
	font-size: 12px;
	color: gray;
}
</style>
</head>
<body>

	<h2>💬 채팅방 목록</h2>

	<c:forEach var="room" items="${chatRooms}">
		<div class="chat-room" onclick="enterRoom(${room.roomNo})">
			<div>
				<strong>방 번호:</strong> ${room.roomNo}
			</div>
			<div>
				<strong>유저:</strong> ${room.userId}
			</div>
			<div class="chat-type">채팅 타입: ${room.chatType}</div>
			<div class="last-visit">마지막 방문: ${room.lastVisit}</div>
		</div>
	</c:forEach>

	<script>
    function enterRoom(roomNo) {
        location.href = "chatRoom.do?roomNo=" + roomNo;
    }
</script>

</body>
</html>