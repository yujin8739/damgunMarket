<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의사항 상세보기</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            margin: 0;
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 40px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(180, 139, 255, 0.08);
            border: 2px solid #f0ebff;
        }
        
        .detail-header {
            border-bottom: 2px solid #a88bff;
            padding: 25px;
            margin-bottom: 30px;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-radius: 15px;
            border: 2px solid #e8e0ff;
        }
        
        .detail-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 15px;
            color: #a88bff;
            text-shadow: 0 2px 4px rgba(168, 139, 255, 0.15);
        }
        
        .detail-info {
            color: #8a7bcc;
            font-size: 14px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            border: 1px solid #e8e0ff;
        }
        
        .detail-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            min-height: 200px;
            line-height: 1.8;
            border: 2px solid #f0ebff;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.05);
        }
        
        .detail-image {
            margin: 20px 0;
            text-align: center;
        }
        
        .detail-image img {
            max-width: 100%;
            height: auto;
            border: 2px solid #e8e0ff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(180, 139, 255, 0.1);
        }
        
        .btn-group {
            text-align: center;
            margin-top: 40px;
            padding: 20px;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-radius: 15px;
            border: 2px solid #e8e0ff;
        }
        
        .btn {
            padding: 15px 30px;
            margin: 0 10px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%);
            color: white;
            border: 2px solid #7b68ee;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #7b68ee 0%, #9370db 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 69, 255, 0.4);
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #9370db 0%, #8b5cf6 100%);
            color: white;
            border: 2px solid #8b5cf6;
            box-shadow: 0 4px 15px rgba(147, 112, 219, 0.3);
        }
        
        .btn-warning:hover {
            background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(147, 112, 219, 0.4);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
            color: white;
            border: 2px solid #dc3545;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #b4a0ff 0%, #c8b8ff 100%);
            color: white;
            border: 2px solid #a88bff;
            box-shadow: 0 4px 15px rgba(180, 160, 255, 0.2);
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #a88bff 0%, #b49fff 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(180, 160, 255, 0.3);
        }
        
        .answer-section {
            margin-top: 40px;
            border-top: 2px solid #e8e0ff;
            padding: 30px;
            background: white;
            border-radius: 15px;
            border: 2px solid #f0ebff;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.05);
        }
        
        .answer-title {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #a88bff;
            text-shadow: 0 1px 2px rgba(168, 139, 255, 0.1);
        }
        
        .answer-content {
            background: linear-gradient(135deg, #f0ebff 0%, #e8e0ff 100%);
            padding: 25px;
            border-radius: 12px;
            border-left: 4px solid #a88bff;
            border: 2px solid #e8e0ff;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.05);
        }
        
        .answer-header {
            color: #8a7bcc;
            margin-bottom: 15px;
        }
        
        .answer-text {
            color: #333;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="detail-header">
            <div class="detail-title">${userQna.userQnaTitle}</div>
            <div class="detail-info">
                작성일: 
                <c:choose>
                    <c:when test="${not empty userQna.createdate}">
                        <fmt:formatDate value="${userQna.createdate}" pattern="yyyy-MM-dd HH:mm"/>
                    </c:when>
                    <c:otherwise>
                        등록일 없음
                    </c:otherwise>
                </c:choose>
                <br>
                작성자: 
                <c:choose>
                    <c:when test="${not empty userQna.userName}">
                        ${userQna.userName}님
                    </c:when>
                    <c:when test="${not empty loginUser.userName}">
                        ${loginUser.userName}님
                    </c:when>
                    <c:otherwise>
                        회원${userQna.userNo}
                    </c:otherwise>
                </c:choose>
                <br>
                문의번호: ${userQna.userQnaNum}
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
        
        <!-- 관리자 답변 영역 -->
        <div class="answer-section">
            <div class="answer-title">📝 관리자 답변</div>
            <div class="answer-content">
                <c:choose>
                    <c:when test="${not empty answer and not empty answer.answerQna}">
                        <!-- 답변이 있는 경우 -->
                        <div class="answer-header">
                            <strong>제목:</strong> ${answer.answerTitle}<br>
                            <strong>답변자:</strong> ${answer.adminName}<br>
                            <hr style="margin: 15px 0; border: 1px solid #ddd;">
                        </div>
                        <div class="answer-text">
                            ${answer.answerQna}
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- 답변이 없는 경우 -->
                        아직 답변이 등록되지 않았습니다.
                    </c:otherwise>
                </c:choose>
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