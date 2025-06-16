<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>답변 등록</title>
</head>
<body>
    <h1>답변 등록</h1>
    <form action="insert.an" method="post">
        <input type="hidden" name="userQnaNum" value="${userQnaNum}">
        <input type="hidden" name="userNo" value="${userQna.userNo}">

        <p><strong>문의제목:</strong> ${userQna.userQnaTitle}</p>
        <p><strong>문의내용:</strong> ${userQna.userQna}</p>

        <p>답변제목: <input type="text" name="answerTitle" required></p>
        <p>답변내용: <textarea name="answerQna" rows="5" cols="50" required></textarea></p>
        <p>관리자이름: <input type="text" name="adminName" required></p>
        <input type="submit" value="등록">
    </form>
</body>
</html>
