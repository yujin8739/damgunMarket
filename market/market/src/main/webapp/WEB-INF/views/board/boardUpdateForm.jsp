<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-container { max-width: 800px; margin: 0 auto; }
        input, textarea { width: 100%; padding: 10px; margin: 5px 0; box-sizing: border-box; }
        textarea { height: 200px; resize: vertical; }
        button { padding: 12px 20px; margin: 5px; }
        .btn-primary { background: #007bff; color: white; border: none; border-radius: 4px; }
        .btn-secondary { background: #6c757d; color: white; border: none; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>공지사항 수정</h2>
        <form action="update.bo" method="post">
            <input type="hidden" name="noticeNum" value="${board.noticeNum}">
            <input type="text" name="noticeTitle" value="${board.noticeTitle}" placeholder="제목" required>
            <textarea name="notice" placeholder="내용" required>${board.notice}</textarea>
            <input type="text" name="noticeImg" value="${board.noticeImg}" placeholder="이미지 URL (선택사항)">
            <button type="submit" class="btn-primary">수정</button>
            <button type="button" class="btn-secondary" onclick="location.href='detail.bo?bno=${board.noticeNum}'">취소</button>
        </form>
    </div>
</body>
</html>