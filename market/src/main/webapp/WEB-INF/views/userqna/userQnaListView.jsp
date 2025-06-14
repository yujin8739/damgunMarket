<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의사항</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px 20px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(180, 90, 255, 0.08);
            margin-top: 20px;
            border: 2px solid #f0ebff;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding: 25px;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-radius: 15px;
            border: 2px solid #e8e0ff;
        }
        
        .header h1 {
            color: #a88bff;
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 0 2px 4px rgba(168, 139, 255, 0.15);
        }
        
        .btn {
            padding: 12px 25px;
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            border: 2px solid #7b68ee;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
        }
        
        .btn:hover {
            background: linear-gradient(135deg, #7b68ee 0%, #9370db 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 69, 255, 0.4);
        }
        
        .search-form {
            margin-bottom: 30px;
            text-align: right;
            padding: 20px;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-radius: 15px;
            border: 2px solid #e8e0ff;
        }
        
        .search-input {
            padding: 12px 18px;
            border: 2px solid #c8b8ff;
            border-radius: 25px;
            width: 280px;
            font-size: 14px;
            outline: none;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
        }
        
        .search-input:focus {
            border-color: #8b45ff;
            box-shadow: 0 0 15px rgba(139, 69, 255, 0.3);
            background: white;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(180, 139, 255, 0.08);
            border: 2px solid #f0ebff;
        }
        
        .table th, .table td {
            padding: 18px 15px;
            text-align: left;
            border-bottom: 1px solid #f5f2ff;
        }
        
        .table th {
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            color: #a88bff;
            font-weight: 700;
            text-shadow: 0 1px 2px rgba(168, 139, 255, 0.1);
            border: none;
            border-bottom: 2px solid #e8e0ff;
        }
        
        .table tr {
            transition: all 0.3s ease;
        }
        
        .table tr:hover {
            background: linear-gradient(135deg, #faf9ff 0%, #f8f6ff 100%);
            transform: scale(1.01);
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.15);
        }
        
        .table tr:last-child td {
            border-bottom: none;
        }
        
        .title-link {
            color: #a88bff;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .title-link:hover {
            color: #b4a0ff;
            text-decoration: underline;
            text-shadow: 0 1px 3px rgba(180, 160, 255, 0.2);
        }
        
        .no-data {
            text-align: center;
            padding: 60px;
            color: #a88bff;
            font-size: 1.2rem;
            font-weight: 500;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-radius: 15px;
            border: 2px solid #e8e0ff;
        }
        
        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
            display: inline-block;
        }
        
        .badge-warning {
            background: linear-gradient(135deg, #ffc107 0%, #ffb300 100%);
            color: #856404;
            border: 1px solid #ffb300;
        }
        
        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                padding: 20px 15px;
                border-radius: 15px;
            }
            
            .header {
                flex-direction: column;
                gap: 20px;
                text-align: center;
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .search-form {
                text-align: center;
                padding: 15px;
            }
            
            .search-input {
                width: 90%;
                max-width: 300px;
            }
            
            .table {
                font-size: 14px;
            }
            
            .table th, .table td {
                padding: 12px 8px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>문의사항</h1>
            <c:if test="${not empty loginUser}">
                <a href="${contextPath}/userqna/enrollForm.uq" class="btn">문의하기</a>
            </c:if>
        </div>
        
        <div class="search-form">
            <form action="${contextPath}/userqna/search.uq" method="get">
                <input type="text" name="keyword" class="search-input" placeholder="제목 또는 내용으로 검색">
                <button type="submit" class="btn">검색</button>
            </form>
        </div>
        
        <c:choose>
            <c:when test="${not empty list}">
                <table class="table">
                    <thead>
                        <tr>
                            <th width="10%">번호</th>
                            <th width="50%">제목</th>
                            <th width="15%">작성자</th>
                            <th width="15%">작성일</th>
                            <th width="10%">상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="qna" items="${list}">
                            <tr>
                                <td>${qna.userQnaNum}</td>
                                <td>
                                    <a href="${contextPath}/userqna/detail.uq?qno=${qna.userQnaNum}" class="title-link">
                                        ${qna.userQnaTitle}
                                    </a>
                                </td>
                                <td>회원${qna.userNo}</td>
                                <td>2024-01-01</td>
                                <td>
                                    <span class="badge badge-warning">답변대기</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    <p>등록된 문의사항이 없습니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        // 알림 메시지 표시
        <c:if test="${not empty alertMsg}">
            alert("${alertMsg}");
            <c:remove var="alertMsg" scope="session"/>
        </c:if>
    </script>
</body>
</html>