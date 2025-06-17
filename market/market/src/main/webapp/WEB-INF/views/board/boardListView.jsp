<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항</title>
    <style>
        body { 
            font-family: 'Noto Sans KR', sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%); 
        }

        .container { 
            max-width: 1000px; 
            margin: 0 auto; 
            background: rgba(255, 255, 255, 0.95); 
            border-radius: 20px; 
            padding: 30px; 
            box-shadow: 0 10px 30px rgba(180, 139, 255, 0.08);
            border: 2px solid #f0ebff;
        }

        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 30px; 
            padding: 25px;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-radius: 15px;
            border: 2px solid #e8e0ff;
            border-bottom: none;
        }

        .header h2 { 
            margin: 0; 
            color: #a88bff; 
            font-size: 28px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(168, 139, 255, 0.15);
        }

        .home-btn {
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%) !important;
            color: white !important;
            padding: 12px 20px;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none !important;
            border: 2px solid #7b68ee;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
            transition: all 0.3s ease;
        }

        .home-btn:hover {
            background: linear-gradient(135deg, #7b68ee 0%, #9370db 100%) !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 69, 255, 0.4);
        }

        .btn { 
            padding: 12px 25px; 
            border: none; 
            border-radius: 25px; 
            text-decoration: none; 
            display: inline-block; 
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
        }

        .btn-primary { 
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%); 
            color: white;
            border: 2px solid #7b68ee;
        }

        .btn-primary:hover { 
            background: linear-gradient(135deg, #7b68ee 0%, #9370db 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 69, 255, 0.4);
        }

        .notice-list { 
            list-style: none; 
            padding: 0; 
            margin: 0; 
        }

        .notice-item { 
            border-bottom: 1px solid #e8e0ff; 
            padding: 20px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center;
            background: white;
            margin-bottom: 10px;
            border-radius: 12px;
            border: 2px solid #f0ebff;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.05);
            transition: all 0.3s ease;
        }

        .notice-item:hover { 
            background: linear-gradient(135deg, #faf9ff 0%, #f8f6ff 100%); 
            margin: 0 0 10px 0; 
            padding: 20px;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(180, 139, 255, 0.15);
            border-color: #e8e0ff;
        }

        .notice-info { 
            flex: 1; 
        }

        .notice-title { 
            font-size: 16px; 
            color: #a88bff; 
            text-decoration: none; 
            display: block; 
            margin-bottom: 8px;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .notice-title:hover { 
            color: #8b45ff;
            text-decoration: underline;
        }

        .notice-date { 
            font-size: 12px; 
            color: #8a7bcc; 
        }

        .admin-actions { 
            display: flex; 
            gap: 10px; 
        }

        .admin-actions a { 
            font-size: 12px; 
            padding: 8px 15px; 
            border-radius: 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-edit { 
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%); 
            color: white;
            border: 1px solid #28a745;
        }

        .btn-edit:hover {
            background: linear-gradient(135deg, #218838 0%, #1abc9c 100%);
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(40, 167, 69, 0.3);
        }

        .btn-delete { 
            background: linear-gradient(135deg, #dc3545 0%, #e74c3c 100%); 
            color: white;
            border: 1px solid #dc3545;
        }

        .btn-delete:hover {
            background: linear-gradient(135deg, #c82333 0%, #c0392b 100%);
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.3);
        }

        .empty-notice { 
            text-align: center; 
            padding: 60px; 
            color: #a88bff;
            font-size: 1.2rem;
            font-weight: 500;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-radius: 15px;
            border: 2px solid #e8e0ff;
        }
    </style>
</head>
<body>
    <c:set var="contextRoot" value="${pageContext.request.contextPath}" />
    <div class="container">
        <div class="header">
            <h2>공지사항</h2>
            <a href="${contextRoot}/" class="home-btn">🏠 HOME</a>
            <c:if test="${not empty sessionScope.loginAdmin}">
                <a href="enrollForm.bo" class="btn btn-primary">새 공지사항 작성</a>
            </c:if>
        </div>
        
        <c:choose>
            <c:when test="${empty list}">
                <div class="empty-notice">
                    <p>등록된 공지사항이 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="notice-list">
                    <c:forEach var="board" items="${list}">
                        <li class="notice-item">
                            <div class="notice-info">
                                <a href="detail.bo?bno=${board.noticeNum}" class="notice-title">
                                    ${board.noticeTitle}
                                </a>
								<!-- 기존 하드코딩된 날짜를 실제 데이터로 변경 -->
								<div class="notice-date">
								    <fmt:formatDate value="${board.createdate}" pattern="yyyy-MM-dd"/>
								    <c:if test="${not empty board.modifydate}">
								        (수정: <fmt:formatDate value="${board.modifydate}" pattern="yyyy-MM-dd"/>)
								    </c:if>
								</div>
                            <c:if test="${not empty loginAdmin}">
						    <div class="admin-actions">
						        <a href="updateForm.bo?bno=${board.noticeNum}" class="btn btn-edit">수정</a>
						        <a href="javascript:deleteBoard(${board.noticeNum})" class="btn btn-delete">삭제</a>
						    </div>
						</c:if>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
    </div>

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
        
        // 알림 메시지 표시
        <c:if test="${not empty sessionScope.alertMsg}">
            alert('${sessionScope.alertMsg}');
            <c:remove var="alertMsg" scope="session"/>
        </c:if>
    </script>
</body>
</html>