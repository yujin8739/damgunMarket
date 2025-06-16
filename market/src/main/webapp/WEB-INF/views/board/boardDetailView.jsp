<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; margin: 0; padding: 20px; background: #f8f9fa; }
        .container { max-width: 800px; margin: 0 auto; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background: #f8f9fa; padding: 20px; border-bottom: 1px solid #eee; }
        .header h2 { margin: 0; color: #333; font-size: 24px; }
        .meta-info { margin-top: 10px; color: #666; font-size: 14px; }
        .content { padding: 30px; line-height: 1.6; color: #333; min-height: 200px; }
        .content img { max-width: 100%; height: auto; border-radius: 5px; margin: 10px 0; }
        .actions { padding: 20px; border-top: 1px solid #eee; display: flex; justify-content: space-between; }
        .btn-group { display: flex; gap: 10px; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; display: inline-block; transition: all 0.3s; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-primary { background: #007bff; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn:hover { opacity: 0.9; transform: translateY(-1px); }
        .back-btn { color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>${board.noticeTitle}</h2>
            <div class="meta-info">
			    작성일: <fmt:formatDate value="${board.createdate}" pattern="yyyy-MM-dd HH:mm"/>
			    <c:if test="${not empty board.modifydate}">
			        <br>수정일: <fmt:formatDate value="${board.modifydate}" pattern="yyyy-MM-dd HH:mm"/>
			    </c:if>
			</div>
        </div>
        
        <div class="content">
            ${board.notice}
            <c:if test="${not empty board.noticeImg}">
                <div style="text-align: center; margin-top: 20px;">
                    <img src="${board.noticeImg}" alt="공지이미지">
                </div>
            </c:if>
        </div>
        
        <div class="actions">
            <a href="list.bo" class="btn btn-secondary back-btn">목록으로</a>
            <c:if test="${not empty loginAdmin}">
			    <div class="btn-group">
			        <a href="updateForm.bo?bno=${board.noticeNum}" class="btn btn-primary">수정</a>
			        <a href="javascript:deleteBoard()" class="btn btn-danger">삭제</a>
			    </div>
			</c:if>
        </div>
    </div>
    
    <script>
        function deleteBoard() {
            if(confirm('정말 삭제하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete.bo';
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'bno';
                input.value = '${board.noticeNum}';
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