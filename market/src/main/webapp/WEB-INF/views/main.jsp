<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

	#searchForm {
	    margin-bottom: 20px;
	    display: flex;
	    gap: 10px;
	    justify-content: right;
	    padding-right: 5%
	}
	#all-container {
	    max-width: 95%;
    	margin: 0 auto;
    	padding: 0 20px;
    	margin-top: 30px;
	}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<div id=all-container >
	    <form id="searchForm" onsubmit="return false;">
	        <input type="text" id="searchKeyword" placeholder="상품명 검색">
	        <button onclick="startSearch()">검색</button>
	    </form>
	    <hr>
		<jsp:include page="/WEB-INF/views/product/productList.jsp"/>
	</div>
	 <p><a href="${pageContext.request.contextPath}/chat/roomList">채팅방으로 이동</a></p>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>