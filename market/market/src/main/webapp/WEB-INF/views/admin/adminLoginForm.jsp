<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 로그인</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        .login-form { max-width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; }
        input { width: 100%; padding: 10px; margin: 5px 0; }
        button { width: 100%; padding: 12px; background: #007bff; color: white; border: none; }
    </style>
</head>
<body>
    <div class="login-form">
        <h2>관리자 로그인</h2>
        <form action="login.ad" method="post">
            <input type="text" name="adminId" placeholder="관리자 ID" required>
            <input type="password" name="adminPw" placeholder="비밀번호" required>
            <button type="submit">로그인</button>
        </form>
    </div>
</body>
</html>