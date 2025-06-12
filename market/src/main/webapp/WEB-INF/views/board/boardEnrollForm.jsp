<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 작성</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-container { max-width: 800px; margin: 0 auto; }
        input, textarea { width: 100%; padding: 10px; margin: 5px 0; }
        textarea { height: 200px; }
        button { padding: 12px 20px; margin: 5px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>공지사항 작성</h2>
        <form action="insert.bo" method="post">
            <input type="text" name="noticeTitle" placeholder="제목" required>
            <textarea name="notice" placeholder="내용" required></textarea>
            <input type="text" name="noticeImg" placeholder="이미지 URL (선택사항)">
            <button type="submit">등록</button>
            <button type="button" onclick="location.href='list.bo'">취소</button>
        </form>
    </div>
</body>
</html>