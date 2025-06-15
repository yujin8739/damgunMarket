<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의사항 상세보기</title>
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .detail-header {
            border-bottom: 2px solid #007bff;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        
        .detail-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .detail-info {
            color: #666;
            font-size: 14px;
        }
        
        .detail-content {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            min-height: 200px;
            line-height: 1.6;
        }
        
        .detail-image {
            margin: 20px 0;
            text-align: center;
        }
        
        .detail-image img {
            max-width: 100%;
            height: auto;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        
        .btn-group {
            text-align: center;
            margin-top: 30px;
        }
        
        .btn {
            padding: 10px 20px;
            margin: 0 5px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
        
        .answer-section {
            margin-top: 40px;
            border-top: 1px solid #ddd;
            padding-top: 20px;
        }
        
        .answer-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #007bff;
        }
        
        .answer-content {
            background-color: #e3f2fd;
            padding: 20px;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="detail-header">
            <div class="detail-title">${userQna.userQnaTitle}</div>
            <div class="detail-info">
                작성자: 회원${userQna.userNo} | 작성일: 2024-01-01 | 문의번호: ${userQna.userQnaNum}
            </div>
        </div>
        
        <div class="detail-content">
            ${userQna.userQna}
        </div>
        
        <c:if test="${not empty userQna.userQnaImg}">
            <div class="detail-image">
                <img src="${contextPath}/resources/uploadFiles/${userQna.userQnaImg}" alt="첨부이미지">
            </div>
        </c:if>
        
        <!-- 관리자 답변 영역 (나중에 구현) -->
        <div class="answer-section">
            <div class="answer-title">📝 관리자 답변</div>
            <div class="answer-content">
                아직 답변이 등록되지 않았습니다.
            </div>
        </div>
        
        <div class="btn-group">
            <a href="${contextPath}/userqna/list.uq" class="btn btn-secondary">목록으로</a>
            
            <c:if test="${loginUser.userNo == userQna.userNo}">
                <a href="${contextPath}/userqna/updateForm.uq?qno=${userQna.userQnaNum}" class="btn btn-warning">수정하기</a>
                <button onclick="deleteQna()" class="btn btn-danger">삭제하기</button>
            </c:if>
        </div>
    </div>
    
    <form id="deleteForm" action="${contextPath}/userqna/delete.uq" method="post" style="display:none;">
        <input type="hidden" name="qno" value="${userQna.userQnaNum}">
    </form>
    
    <script>
        function deleteQna() {
            if(confirm("정말로 이 문의사항을 삭제하시겠습니까?")) {
                document.getElementById("deleteForm").submit();
            }
        }
        
        // 알림 메시지 표시
        <c:if test="${not empty alertMsg}">
            alert("${alertMsg}");
            <c:remove var="alertMsg" scope="session"/>
        </c:if>
    </script>
</body>
</html>