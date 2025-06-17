<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>답변 관리</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 20px; 
        }
        .home-btn {
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        .home-btn:hover {
            background-color: #0056b3;
        }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        .status-badge {
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-answered {
            background-color: #28a745;
            color: white;
        }
        .status-pending {
            background-color: #ffc107;
            color: #212529;
        }
    </style>
</head>
<body>
    <div class="header">
        <h2>답변 관리 (문의사항 목록)</h2>
        <a href="${contextPath}/" class="home-btn">홈으로</a>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>문의번호</th>
                <th>문의제목</th>
                <th>작성자</th>
                <th>답변상태</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="userQna" items="${list}">
                <tr>
                    <td>${userQna.userQnaNum}</td>
                    <td>
                        <a href="detail.an?qno=${userQna.userQnaNum}">
                            ${userQna.userQnaTitle}
                        </a>
                    </td>
                    <td>사용자${userQna.userNo}</td>
                    <td>
                        <!-- 여기서 답변 상태를 확인해야 함 -->
                        <span class="status-badge status-pending" id="status-${userQna.userQnaNum}">
                            답변대기
                        </span>
                    </td>
                    <td>
                        <a href="enrollForm.an?qno=${userQna.userQnaNum}">답변작성</a>
                        <a href="detail.an?qno=${userQna.userQnaNum}">상세보기</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <c:if test="${empty list}">
        <p style="text-align: center; margin-top: 50px; color: #666;">
            등록된 문의사항이 없습니다.
        </p>
    </c:if>
    
    <script>
        // 페이지 로드 시 각 문의사항의 답변 상태 확인
        window.onload = function() {
            <c:forEach var="userQna" items="${list}">
                checkAnswerStatus(${userQna.userQnaNum});
            </c:forEach>
        };
        
        function checkAnswerStatus(qno) {
            // AJAX로 답변 존재 여부 확인
            fetch('checkAnswer.an?qno=' + qno)
                .then(response => response.json())
                .then(data => {
                    const statusElement = document.getElementById('status-' + qno);
                    if (data.hasAnswer) {
                        statusElement.textContent = '답변완료';
                        statusElement.className = 'status-badge status-answered';
                    }
                })
                .catch(error => console.log('Error:', error));
        }
    </script>
</body>
</html>