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
	<h1>상품 목록</h1>

    <form id="searchForm" onsubmit="return false;">
        <input type="text" id="searchKeyword" placeholder="상품명 검색">
        <button onclick="startSearch()">검색</button>
    </form>
	<jsp:include page="/WEB-INF/views/product/productList.jsp"/>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>

</body>
</html>