<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<div id=all-container >
		<h1 style="text-align: center;">찜목록</h1>
		<jsp:include page="/WEB-INF/views/member/favorList.jsp"/>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>