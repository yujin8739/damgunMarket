<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>답변 등록</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(180, 139, 255, 0.08);
            border: 2px solid #f0ebff;
            padding: 40px;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 25px;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-radius: 15px;
            border: 2px solid #e8e0ff;
        }
        
        .form-header h1 {
            color: #a88bff;
            font-size: 2.2rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 0 2px 4px rgba(168, 139, 255, 0.15);
        }
        
        .qna-info {
            background: linear-gradient(135deg, #f8f6ff 0%, #f0ebff 100%);
            border: 2px solid #e8e0ff;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .qna-info h3 {
            color: #a88bff;
            margin-top: 0;
            margin-bottom: 15px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #a88bff;
            font-size: 1rem;
        }
        
        .form-input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e8e0ff;
            border-radius: 10px;
            font-size: 14px;
            box-sizing: border-box;
            background: rgba(255, 255, 255, 0.9);
            transition: all 0.3s ease;
        }
        
        .form-input:focus {
            border-color: #c8b8ff;
            outline: none;
            box-shadow: 0 0 15px rgba(200, 184, 255, 0.3);
            background: white;
        }
        
        .form-textarea {
            height: 150px;
            resize: vertical;
            font-family: inherit;
            line-height: 1.6;
        }
        
        .btn-group {
            text-align: center;
            margin-top: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            border-radius: 15px;
            border: 2px solid #e8e0ff;
        }
        
        .btn {
            padding: 15px 35px;
            margin: 0 15px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%);
            color: white;
            border: 2px solid #7b68ee;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
            border: 2px solid #5a6268;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        }
        
        .required {
            color: #ff6b6b;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-header">
            <h1>📝 답변 등록</h1>
        </div>
        
        <!-- 원본 문의사항 정보 -->
        <div class="qna-info">
            <h3>💬 원본 문의사항</h3>
            <p><strong>제목:</strong> ${userQna.userQnaTitle}</p>
            <p><strong>내용:</strong> ${userQna.userQna}</p>
        </div>
        
        <form action="${contextPath}/answer/insert.an" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="userQnaNum" value="${userQnaNum}">
            <input type="hidden" name="userNo" value="${userQna.userNo}">

            <div class="form-group">
                <label for="answerTitle" class="form-label">답변 제목 <span class="required">*</span></label>
                <input type="text" id="answerTitle" name="answerTitle" class="form-input" 
                       placeholder="답변 제목을 입력해주세요" required>
            </div>
            
            <div class="form-group">
                <label for="answerQna" class="form-label">답변 내용 <span class="required">*</span></label>
                <textarea id="answerQna" name="answerQna" class="form-input form-textarea" 
                          placeholder="답변 내용을 입력해주세요" required></textarea>
            </div>
            
            <div class="form-group">
                <label for="adminName" class="form-label">관리자 이름 <span class="required">*</span></label>
                <input type="text" id="adminName" name="adminName" class="form-input" 
                       placeholder="관리자 이름을 입력해주세요" required>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary">답변 등록</button>
                <a href="${contextPath}/answer/detail.an?qno=${userQnaNum}" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
    
    <script>
        function validateForm() {
            var title = document.getElementById("answerTitle").value.trim();
            var content = document.getElementById("answerQna").value.trim();
            var adminName = document.getElementById("adminName").value.trim();
            
            if(title === "") {
                alert("답변 제목을 입력해주세요.");
                document.getElementById("answerTitle").focus();
                return false;
            }
            
            if(content === "") {
                alert("답변 내용을 입력해주세요.");
                document.getElementById("answerQna").focus();
                return false;
            }
            
            if(adminName === "") {
                alert("관리자 이름을 입력해주세요.");
                document.getElementById("adminName").focus();
                return false;
            }
            
            return confirm("답변을 등록하시겠습니까?");
        }
    </script>
</body>
</html>