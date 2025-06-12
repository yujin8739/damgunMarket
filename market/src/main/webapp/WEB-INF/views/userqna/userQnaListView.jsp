<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의사항 목록</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .btn { padding: 10px 15px; margin: 5px; text-decoration: none; background: #007bff; color: white; }
    </style>
</head>
<body>
    <h2>문의사항 목록</h2>
    <a href="enrollForm.uq" class="btn">새 문의 작성</a>
    <table>
        <thead>
            <tr>
                <th>문의번호</th>
                <th>제목</th>
                <th>유저번호</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="userQna" items="${list}">
                <tr>
                    <td>${userQna.userQnaNum}</td>
                    <td><a href="detail.uq?qno=${userQna.userQnaNum}">${userQna.userQnaTitle}</a></td>
                    <td>${userQna.userNo}</td>
                    <td>
                        <a href="../answer/enrollForm.an?qno=${userQna.userQnaNum}">답변작성</a>
                        <a href="updateForm.uq?qno=${userQna.userQnaNum}">수정</a>
                        <a href="javascript:deleteUserQna(${userQna.userQnaNum})">삭제</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <script>
        function deleteUserQna(qno) {
            if(confirm('정말 삭제하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete.uq';
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