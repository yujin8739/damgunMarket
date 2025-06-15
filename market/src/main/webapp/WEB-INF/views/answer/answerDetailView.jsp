<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
    <title>문의 상세</title>
</head>
<body>
    <h1>문의 상세</h1>
    <p><strong>제목:</strong> ${userQna.userQnaTitle}</p>
    <p><strong>내용:</strong> ${userQna.userQna}</p>
    <c:if test="${not empty userQna.userQnaImg}">
        <p><img src="${userQna.userQnaImg}" width="200"/></p>
    </c:if>

    <hr/>

    <c:choose>
        <c:when test="${not empty answer}">
            <h2>답변</h2>
            <p><strong>제목:</strong> ${answer.answerTitle}</p>
            <p><strong>내용:</strong> ${answer.answerQna}</p>
            <p><strong>작성자:</strong> ${answer.adminName}</p>
            <a href="updateForm.an?qno=${userQna.userQnaNum}">수정</a>
            <form action="delete.an" method="post" style="display:inline;">
                <input type="hidden" name="qno" value="${userQna.userQnaNum}">
                <input type="submit" value="삭제">
            </form>
        </c:when>
        <c:otherwise>
            <p>답변이 없습니다.</p>
            <a href="enrollForm.an?qno=${userQna.userQnaNum}">답변 작성</a>
        </c:otherwise>
    </c:choose>
</body>
</html>
