<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의 상세</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(180, 139, 255, 0.08);
            border: 2px solid #f0ebff;
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            padding: 30px;
            border-bottom: 2px solid #e8e0ff;
        }
        
        .header h1 {
            color: #a88bff;
            font-size: 2.2rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 0 2px 4px rgba(168, 139, 255, 0.15);
        }
        
        .content-section {
            padding: 30px;
        }
        
        .qna-section {
            background: white;
            border: 2px solid #f0ebff;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.05);
        }
        
        .section-title {
            color: #a88bff;
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 15px;
            border-bottom: 2px solid #e8e0ff;
            padding-bottom: 8px;
        }
        
        .qna-content {
            color: #333;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        
        .qna-image {
            text-align: center;
            margin: 20px 0;
        }
        
        .qna-image img {
            max-width: 100%;
            height: auto;
            border: 2px solid #e8e0ff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(180, 139, 255, 0.1);
        }
        
        .answer-section {
            background: linear-gradient(135deg, #f8f6ff 0%, #f0ebff 100%);
            border: 2px solid #e8e0ff;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .answer-meta {
            background: rgba(255, 255, 255, 0.8);
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 1px solid #e8e0ff;
        }
        
        .btn-group {
            text-align: center;
            padding: 20px;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-top: 2px solid #e8e0ff;
        }
        
        .btn {
            padding: 12px 25px;
            margin: 0 10px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%);
            color: white;
            border: 2px solid #7b68ee;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #ffb300 100%);
            color: #856404;
            border: 2px solid #ffb300;
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border: 2px solid #c82333;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
            border: 2px solid #5a6268;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        }
        
        .no-answer {
            color: #8a7bcc;
            font-style: italic;
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 문의사항 상세보기</h1>
        </div>
        
        <div class="content-section">
            <!-- 문의사항 영역 -->
            <div class="qna-section">
                <div class="section-title">💬 문의내용</div>
                <h3><strong>${userQna.userQnaTitle}</strong></h3>
                <div class="qna-content">${userQna.userQna}</div>
                
                <c:if test="${not empty userQna.userQnaImg}">
                    <div class="qna-image">
                        <img src="${contextPath}/resources/uploadFiles/${userQna.userQnaImg}" alt="첨부이미지"/>
                    </div>
                </c:if>
            </div>

            <!-- 답변 영역 -->
            <div class="answer-section">
                <div class="section-title">📝 관리자 답변</div>
                <c:choose>
                    <c:when test="${not empty answer}">
                        <div class="answer-meta">
                            <strong>답변 제목:</strong> ${answer.answerTitle}<br>
                            <strong>답변자:</strong> ${answer.adminName}
                        </div>
                        <div class="qna-content">${answer.answerQna}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-answer">아직 답변이 등록되지 않았습니다.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="btn-group">
            <a href="${contextPath}/answer/list.an" class="btn btn-secondary">목록으로</a>
            
            <c:choose>
                <c:when test="${not empty answer}">
                    <a href="${contextPath}/answer/updateForm.an?qno=${userQna.userQnaNum}" class="btn btn-warning">답변수정</a>
                    <form action="${contextPath}/answer/delete.an" method="post" style="display:inline;" 
                          onsubmit="return confirm('답변을 삭제하시겠습니까?')">
                        <input type="hidden" name="qno" value="${userQna.userQnaNum}">
                        <input type="submit" value="답변삭제" class="btn btn-danger">
                    </form>
                </c:when>
                <c:otherwise>
                    <a href="${contextPath}/answer/enrollForm.an?qno=${userQna.userQnaNum}" class="btn btn-primary">답변작성</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>