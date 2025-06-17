<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
    <style>
        body { 
            font-family: 'Noto Sans KR', sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%); 
        }
        
        .container { 
            max-width: 800px; 
            margin: 0 auto; 
            background: rgba(255, 255, 255, 0.95); 
            border-radius: 20px; 
            overflow: hidden; 
            box-shadow: 0 10px 30px rgba(180, 139, 255, 0.08);
            border: 2px solid #f0ebff;
        }
        
        .header { 
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%); 
            padding: 30px; 
            border-bottom: 2px solid #e8e0ff; 
        }
        
        .header h2 { 
            margin: 0; 
            color: #a88bff; 
            font-size: 28px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(168, 139, 255, 0.15);
        }
        
        .meta-info { 
            margin-top: 15px; 
            color: #8a7bcc; 
            font-size: 14px; 
            padding: 15px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            border: 1px solid #e8e0ff;
        }
        
        .content { 
            padding: 40px; 
            line-height: 1.8; 
            color: #333; 
            min-height: 200px; 
            background: white;
        }
        
        .actions { 
            padding: 30px; 
            border-top: 2px solid #e8e0ff; 
            display: flex; 
            justify-content: space-between; 
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
        }
        
        .btn-group { 
            display: flex; 
            gap: 15px; 
        }
        
        .btn { 
            padding: 15px 30px; 
            border: none; 
            border-radius: 25px; 
            text-decoration: none; 
            display: inline-block; 
            transition: all 0.3s ease; 
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .btn-secondary { 
            background: linear-gradient(135deg, #b4a0ff 0%, #c8b8ff 100%); 
            color: white;
            border: 2px solid #a88bff;
            box-shadow: 0 4px 15px rgba(180, 160, 255, 0.3);
        }
        
        .btn-primary { 
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%); 
            color: white;
            border: 2px solid #7b68ee;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
        }
        
        .btn-danger { 
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%); 
            color: white;
            border: 2px solid #dc3545;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }
        
        .btn:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #a88bff 0%, #b49fff 100%);
            box-shadow: 0 6px 20px rgba(180, 160, 255, 0.4);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #7b68ee 0%, #9370db 100%);
            box-shadow: 0 6px 20px rgba(139, 69, 255, 0.4);
        }
        
        .btn-danger:hover {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
        }
        
        .back-btn { 
            color: white !important; 
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>${board.noticeTitle}</h2>
            <div class="meta-info">
                작성일: <fmt:formatDate value="${board.createdate}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
        </div>
        
        <div class="content">
            ${board.notice}
        </div>
        
        <div class="actions">
            <a href="list.bo" class="btn btn-secondary back-btn">목록으로</a>
            <c:if test="${not empty loginAdmin}">
                <div class="btn-group">
                    <a href="updateForm.bo?bno=${board.noticeNum}" class="btn btn-primary">수정</a>
                    <a href="javascript:deleteBoard()" class="btn btn-danger">삭제</a>
                </div>
            </c:if>
        </div>
    </div>
    
    <script>
        function deleteBoard() {
            if(confirm('정말 삭제하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete.bo';
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'bno';
                input.value = '${board.noticeNum}';
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
        

        <c:if test="${not empty sessionScope.alertMsg}">
            alert('${sessionScope.alertMsg}');
            <c:remove var="alertMsg" scope="session"/>
        </c:if>
    </script>
</body>
</html>