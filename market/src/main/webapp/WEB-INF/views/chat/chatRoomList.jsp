<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
<title>채팅방 목록</title>
<style>
/* 기존 헤더/푸터와 어울리도록 body 스타일 조정 */
body {
	font-family: 'Noto Sans KR', sans-serif; /* 헤더의 폰트와 통일 */
	margin: 0; /* 기본 마진 제거 */
	padding: 0; /* 기본 패딩 제거 */
	background: #fafafa; /* 헤더의 배경색과 유사하게 설정 */
	display: flex; /* Flexbox 레이아웃 적용 */
	flex-direction: column; /* 자식 요소들을 세로로 정렬 */
	min-height: 100vh; /* 뷰포트 전체 높이를 최소 높이로 설정 */
}

/* 메인 콘텐츠 영역을 위한 래퍼 */
.main-content {
	margin-top: 60px;
	padding: 20px;
	/* 	max-width: 800px; */
	margin-left: 40px;
	margin-right: 40px;
	background-color: #fff; /* 콘텐츠 배경색 */
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	position: relative; /* 자식 요소의 absolute 포지셔닝을 위한 컨텍스트 */
	flex-grow: 1; /* 남은 공간을 모두 차지하여 푸터가 아래로 밀리도록 함 */
	display: flex; /* 내부 요소들을 위한 flexbox */
	flex-direction: column;
	background-color: #fff; /* 내부 요소들을 세로로 정렬 */
}

h2 {
	color: #5a4fcf; /* 헤더의 주요 색상과 맞춤 */
	text-align: center;
	margin-bottom: 20px;
	font-size: 24px;
	font-weight: 700;
}

/* li 요소에만 스타일 적용 */
.main-content ul {
	list-style-type: none;
	padding: 0;
	flex-grow: 1; /* ul이 사용 가능한 수직 공간을 채우도록 함 */
}

.main-content li {
	border: 1px solid #e0e0e0; /* 테두리 색상 밝게 조정 */
	margin-bottom: 10px;
	padding: 15px; /* 패딩 증가 */
	border-radius: 8px; /* 더 부드러운 모서리 */
	background-color: ebe4ff; /* 배경색 */
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05); /* 그림자 추가 */
}

.main-content li p {
	margin: 5px 0;
} /* 단락 간격 조정 */
.main-content li strong {
	color: #333;
}

.main-content li a {
	text-decoration: none;
	color: #7b68ee;
	font-weight: 600;
} /* 헤더 강조색과 통일 */
.main-content li a:hover {
	text-decoration: underline;
	color: #5a4fcf;
}

#hamburger {
	position: relative;
}

button {
	padding: 10px 20px; /* 패딩 증가 */
	background-color: #7b68ee; /* 헤더 강조색과 통일 */
	color: white;
	border: none;
	border-radius: 20px; /* 더 둥근 버튼 */
	cursor: pointer;
	font-size: 1em;
	font-weight: 600;
	transition: background-color 0.2s ease;
	margin-top: 15px; /* 버튼 위 여백 */
}

button:hover {
	background-color: #5a4fcf;
}

.unread-count {
	color: #dc3545;
	font-weight: bold;
	margin-left: 10px;
} /* 더 눈에 띄는 색상 */
#targetUserId {
	padding: 8px 12px;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-size: 0.95em;
	margin-right: 10px;
	box-sizing: border-box;
}

.home-link {
	display: block;
	text-align: center;
	margin-top: 25px;
	margin-bottom: 20px; /* 푸터와 겹치지 않도록 여백 추가 */
	font-size: 1.05em;
	color: #7b68ee;
	text-decoration: none;
	font-weight: 600;
	transition: color 0.2s ease;
}

.home-link:hover {
	color: #5a4fcf;
	text-decoration: underline;
}
</style>
</head>
<body>
	<%-- Header Include --%>
	<%@ include file="/WEB-INF/views/common/header.jsp"%>

	<div class="main-content">
		<h2>${currentUserId}님의채팅방목록</h2>

		<c:choose>
			<c:when test="${not empty chatRooms}">
				<ul>
					<c:forEach var="room" items="${chatRooms}">
						<li>
							<p>
								<strong><c:if test="${not empty room.otherUserName}">${room.otherUserName}(${room.otherUserId})</c:if>
									채팅방</strong>
							</p>
							<p>채팅방 번호: ${room.roomNo}</p>
							<p>채팅 타입: ${room.chatType}</p>
							<p>
								생성일자:
								<fmt:formatDate value="${room.createdDate}"
									pattern="yyyy-MM-dd HH:mm:ss" />
							</p>
							<p>
								마지막 방문:
								<fmt:formatDate value="${room.lastVisit}"
									pattern="yyyy-MM-dd HH:mm:ss" />
							</p> <a
							href="${pageContext.request.contextPath}/chat/enterRoom/${room.roomNo}">
								채팅방 입장 <%-- <c:if test="${room.unreadMessageCount > 0}">
                                    <span class="unread-count">(${room.unreadMessageCount}개 새 메시지)</span>
                                </c:if> --%>
						</a>
							<hr />
						</li>
					</c:forEach>
				</ul>
			</c:when>
			<c:otherwise>
				<p>참여 중인 채팅방이 없습니다.</p>
			</c:otherwise>
		</c:choose>

		<h3>새 채팅방 생성</h3>
		<p>
			상대방 ID: <input type="text" id="targetUserId" value="testuser" />
		</p>
		<button onclick="createTestChatRoom()">새 채팅방 생성</button>

		<p>
			<a href="${pageContext.request.contextPath}/" class="home-link">홈으로</a>
		</p>
	</div>

	<%-- Footer Include --%>
	<%@ include file="/WEB-INF/views/common/footer.jsp"%>

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
</body>
</html>
