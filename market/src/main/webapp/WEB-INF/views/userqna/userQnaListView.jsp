<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의사항</title>
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .btn {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }
        
        .btn:hover {
            background-color: #0056b3;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        .table th, .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        
        .table tr:hover {
            background-color: #f5f5f5;
        }
        
        .title-link {
            color: #007bff;
            text-decoration: none;
        }
        
        .title-link:hover {
            text-decoration: underline;
        }
        
        .no-data {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        
        .search-form {
            margin-bottom: 20px;
            text-align: right;
        }
        
        .search-input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 250px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>문의사항</h1>
            <c:if test="${not empty loginUser}">
                <a href="${contextPath}/userqna/enrollForm.uq" class="btn">문의하기</a>
            </c:if>
        </div>
        
        <div class="search-form">
		    <form action="${contextPath}/userqna/list.uq" method="get"> <!-- search.uq 대신 list.uq 사용 -->
		        <input type="text" name="keyword" class="search-input" placeholder="제목 또는 내용으로 검색">
		        <button type="submit" class="btn">검색</button>
		    </form>
</div>
        
        <c:choose>
            <c:when test="${not empty list}">
                <table class="table">
                    <thead>
                        <tr>
                            <th width="10%">번호</th>
                            <th width="50%">제목</th>
                            <th width="15%">작성자</th>
                            <th width="15%">작성일</th>
                            <th width="10%">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="qna" items="${list}">
                            <tr>
                                <td>${qna.userQnaNum}</td>
                                <td>
                                    <a href="${contextPath}/userqna/detail.uq?qno=${qna.userQnaNum}" class="title-link">
                                        ${qna.userQnaTitle}
                                    </a>
                                </td>
                                <td>회원${qna.userNo}</td>
                                <td>2024-01-01</td>
                                <td>
                                    <span class="badge badge-warning">답변대기</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    <p>등록된 문의사항이 없습니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        // 알림 메시지 표시
        <c:if test="${not empty alertMsg}">
            alert("${alertMsg}");
            <c:remove var="alertMsg" scope="session"/>
        </c:if>
    </script>
</body>
</html>