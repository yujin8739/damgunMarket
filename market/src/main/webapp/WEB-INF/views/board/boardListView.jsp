<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; margin: 0; padding: 20px; background: #f8f9fa; }
        .container { max-width: 1000px; margin: 0 auto; background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid #f0f0f0; padding-bottom: 20px; }
        .header h2 { margin: 0; color: #333; font-size: 28px; }
        /* 🔥 HOME 버튼 스타일 추가 */
        .home-btn {
            background: #7b68ee !important;
            color: white !important;
            padding: 8px 16px;
            border-radius: 4px;
            font-weight: bold;
            text-decoration: none !important;
        }
        .home-btn:hover {
            background: #5a4fcf !important;
        }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; display: inline-block; transition: all 0.3s; }
        .btn-primary { background: #007bff; color: white; }
        .btn-primary:hover { background: #0056b3; }
        .notice-list { list-style: none; padding: 0; margin: 0; }
        .notice-item { border-bottom: 1px solid #eee; padding: 15px 0; display: flex; justify-content: space-between; align-items: center; }
        .notice-item:hover { background: #f8f9fa; margin: 0 -15px; padding-left: 15px; padding-right: 15px; }
        .notice-info { flex: 1; }
        .notice-title { font-size: 16px; color: #333; text-decoration: none; display: block; margin-bottom: 5px; }
        .notice-title:hover { color: #007bff; }
        .notice-date { font-size: 12px; color: #999; }
        .admin-actions { display: flex; gap: 10px; }
        .admin-actions a { font-size: 12px; padding: 5px 10px; border-radius: 3px; }
        .btn-edit { background: #28a745; color: white; }
        .btn-delete { background: #dc3545; color: white; }
        .empty-notice { text-align: center; padding: 50px; color: #999; }
    </style>
</head>
<body>
    <c:set var="contextRoot" value="${pageContext.request.contextPath}" />
    <div class="container">
        <div class="header">
            <h2>공지사항</h2>
            <a href="${contextRoot}/" class="home-btn">🏠 HOME</a>
            <c:if test="${not empty sessionScope.loginAdmin}">
                <a href="enrollForm.bo" class="btn btn-primary">새 공지사항 작성</a>
            </c:if>
        </div>
        
        <c:choose>
            <c:when test="${empty list}">
                <div class="empty-notice">
                    <p>등록된 공지사항이 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="notice-list">
                    <c:forEach var="board" items="${list}">
                        <li class="notice-item">
                            <div class="notice-info">
                                <a href="detail.bo?bno=${board.noticeNum}" class="notice-title">
                                    ${board.noticeTitle}
                                </a>
								<!-- 기존 하드코딩된 날짜를 실제 데이터로 변경 -->
								<div class="notice-date">
								    <fmt:formatDate value="${board.createdate}" pattern="yyyy-MM-dd"/>
								    <c:if test="${not empty board.modifydate}">
								        (수정: <fmt:formatDate value="${board.modifydate}" pattern="yyyy-MM-dd"/>)
								    </c:if>
								</div>
                            <c:if test="${not empty loginAdmin}">
						    <div class="admin-actions">
						        <a href="updateForm.bo?bno=${board.noticeNum}" class="btn btn-edit">수정</a>
						        <a href="javascript:deleteBoard(${board.noticeNum})" class="btn btn-delete">삭제</a>
						    </div>
						</c:if>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        function deleteBoard(noticeNum) {
            if(confirm('정말 삭제하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete.bo';
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'bno';
                input.value = noticeNum;
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 알림 메시지 표시
        <c:if test="${not empty sessionScope.alertMsg}">
            alert('${sessionScope.alertMsg}');
            <c:remove var="alertMsg" scope="session"/>
        </c:if>
    </script>
</body>
</html>