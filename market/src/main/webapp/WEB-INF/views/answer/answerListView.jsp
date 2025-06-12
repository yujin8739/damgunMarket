<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>답변 목록</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>답변 목록</h2>
    <table>
        <thead>
            <tr>
                <th>문의번호</th>
                <th>답변제목</th>
                <th>관리자</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="answer" items="${list}">
                <tr>
                    <td>${answer.userQnaNum}</td>
                    <td><a href="detail.an?qno=${answer.userQnaNum}">${answer.answerTitle}</a></td>
                    <td>${answer.adminName}</td>
                    <td>
                        <a href="updateForm.an?qno=${answer.userQnaNum}">수정</a>
                        <a href="javascript:deleteAnswer(${answer.userQnaNum})">삭제</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <script>
        function deleteAnswer(qno) {
            if(confirm('정말 삭제하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete.an';
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'qno';
                input.value = qno;
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>