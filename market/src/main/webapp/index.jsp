<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h1>안녕</h1>
	
	<jsp:forward page="/WEB-INF/views/main.jsp"/>

	<h1>상품 목록</h1>

    <form id="searchForm" onsubmit="return false;">
        <input type="text" id="searchKeyword" placeholder="상품명 검색">
        <button onclick="startSearch()">검색</button>
    </form>
	<jsp:include page="/WEB-INF/views/product/productList.jsp"/>

</body>
</html>