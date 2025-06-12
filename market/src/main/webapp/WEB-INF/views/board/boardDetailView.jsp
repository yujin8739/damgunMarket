<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .detail-container { max-width: 800px; margin: 0 auto; }
        .content { padding: 20px; border: 1px solid #ddd; margin: 10px 0; }
        .btn { padding: 10px 15px; margin: 5px; text-decoration: none; background: #007bff; color: white; }
    </style>
</head>
<body>
    <div class="detail-container">
        <h2>${board.noticeTitle}</h2>
        <div class="content">
            ${board.notice}
        </div>
        <c:if test="${not empty board.noticeImg}">
            <img src="${board.noticeImg}" alt="공지이미지" style="max-width: 100%;">
        </c:if>
        <div>
            <a href="updateForm.bo?bno=${board.noticeNum}" class="btn">수정</a>
            <a href="javascript:deleteBoard()" class="btn">삭제</a>
            <a href="list.bo" class="btn">목록</a>
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
    </script>
</body>
</html>