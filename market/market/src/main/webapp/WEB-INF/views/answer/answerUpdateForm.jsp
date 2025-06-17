<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>답변 수정</title>
</head>
<body>
    <h1>답변 수정</h1>
    <form action="update.an" method="post">
        <input type="hidden" name="userQnaNum" value="${answer.userQnaNum}">
        <input type="hidden" name="userNo" value="${answer.userNo}">

        <p><strong>문의제목:</strong> ${answer.userQnaTitle}</p>
        <p><strong>문의내용:</strong> ${answer.userQna}</p>

        <p>답변제목: <input type="text" name="answerTitle" value="${answer.answerTitle}" required></p>
        <p>답변내용: <textarea name="answerQna" rows="5" cols="50" required>${answer.answerQna}</textarea></p>
        <p>관리자이름: <input type="text" name="adminName" value="${answer.adminName}" required></p>
        <input type="submit" value="수정">
    </form>
</body>
</html>
