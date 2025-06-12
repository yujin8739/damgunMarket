<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 메인</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .nav { background: #f8f9fa; padding: 15px; margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #007bff; }
        .content { padding: 20px; }
    </style>
</head>
<body>
    <div class="nav">
        <h3>관리자 시스템</h3>
        <a href="insert.ad">관리자 등록</a>
        <a href="../board/list.bo">공지사항 관리</a>
        <a href="../answer/list.an">답변 관리</a>
        <a href="../userqna/list.uq">문의사항 관리</a>
        <a href="logout.ad">로그아웃</a>
    </div>
    <div class="content">
        <h2>관리자 메인 페이지</h2>
        <p>안녕하세요, ${sessionScope.loginAdmin.adminName}님!</p>
    </div>
</body>
</html>