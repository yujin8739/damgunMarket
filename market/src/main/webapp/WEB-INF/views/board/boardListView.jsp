<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 목록</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .btn { padding: 10px 15px; margin: 5px; text-decoration: none; background: #007bff; color: white; }
    </style>
</head>
<body>
    <h2>공지사항 목록</h2>
    <a href="enrollForm.bo" class="btn">새 공지사항 작성</a>
    <table>
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="board" items="${list}">
                <tr>
                    <td>${board.noticeNum}</td>
                    <td><a href="detail.bo?bno=${board.noticeNum}">${board.noticeTitle}</a></td>
                    <td>
                        <a href="updateForm.bo?bno=${board.noticeNum}">수정</a>
                        <a href="javascript:deleteBoard(${board.noticeNum})">삭제</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <script>
        function deleteBoard(noticeNum) {
            if(confirm('정말 삭제하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete.bo';
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'bno';
                input.value = noticeNum;
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>