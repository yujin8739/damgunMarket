<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>    
    <meta charset="UTF-8">
    <title>문의사항 수정</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 40px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(180, 139, 255, 0.08);
            border: 2px solid #f0ebff;
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
            margin: 0 0 10px 0;
            text-shadow: 0 2px 4px rgba(168, 139, 255, 0.15);
        }
        
        .form-header p {
            color: #8a7bcc;
            font-size: 1.1rem;
            margin: 0;
        }
        
        .form-group {
            margin-bottom: 30px;
            padding: 20px;
            background: white;
            border-radius: 12px;
            border: 2px solid #f0ebff;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.05);
        }
        
        .form-label {
            display: block;
            margin-bottom: 12px;
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
            height: 200px;
            resize: vertical;
            font-family: inherit;
            line-height: 1.6;
        }
        
        .btn-group {
            text-align: center;
            margin-top: 40px;
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
        
        .btn-warning {
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%);
            color: white;
            border: 2px solid #7b68ee;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
        }
        
        .btn-warning:hover {
            background: linear-gradient(135deg, #7b68ee 0%, #9370db 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 69, 255, 0.4);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #b4a0ff 0%, #c8b8ff 100%);
            color: white;
            border: 2px solid #a88bff;
            box-shadow: 0 4px 15px rgba(180, 160, 255, 0.2);
        }
        
        .btn-secondary:hover {
            background: linear-gradient(135deg, #a88bff 0%, #b49fff 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(180, 160, 255, 0.3);
        }
        
        .required {
            color: #ff6b6b;
            font-weight: bold;
        }
        
        .current-image {
            margin: 15px 0;
            padding: 15px;
            background: linear-gradient(135deg, #faf9ff 0%, #f8f6ff 100%);
            border-radius: 10px;
            border: 2px solid #e8e0ff;
        }
        
        .current-image img {
            max-width: 200px;
            max-height: 150px;
            border: 2px solid #e8e0ff;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.1);
        }
        
        .current-image p {
            color: #8a7bcc;
            margin: 5px 0;
        }
        
        .file-info {
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
            padding: 12px;
            border-radius: 8px;
            margin-top: 10px;
            font-size: 12px;
            color: #8a7bcc;
            border: 1px solid #e8e0ff;
        }
        
        .info-box {
            background: linear-gradient(135deg, #f0ebff 0%, #e8e0ff 100%);
            border: 2px solid #d8ccf0;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            color: #6a5acd;
            font-weight: 500;
        }
        
        .info-box strong {
            color: #a88bff;
        }
        
        #imagePreview {
            margin-top: 15px;
            padding: 10px;
            background: white;
            border-radius: 8px;
            border: 2px dashed #e8e0ff;
            text-align: center;
        }
        
        #imagePreview img {
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.1);
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                padding: 20px;
                border-radius: 15px;
            }
            
            .form-header {
                padding: 20px;
            }
            
            .form-header h1 {
                font-size: 1.8rem;
            }
            
            .form-group {
                padding: 15px;
                margin-bottom: 20px;
            }
            
            .btn-group {
                padding: 15px;
            }
            
            .btn {
                padding: 12px 25px;
                margin: 5px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-header">
            <h1>문의사항 수정</h1>
            <p>문의사항 내용을 수정하실 수 있습니다.</p>
        </div>
        
        <div class="info-box">
            <strong>문의번호:</strong> ${userQna.userQnaNum}<br>
            <strong>작성일:</strong> 2024-01-01<br>
            <strong>현재 상태:</strong> 답변대기
        </div>
        
        <form action="${pageContext.request.contextPath}/userqna/update.uq" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
            <input type="hidden" name="userQnaNum" value="${userQna.userQnaNum}">
            
            <div class="form-group">
                <label for="userQnaTitle" class="form-label">제목 <span class="required">*</span></label>
                <input type="text" id="userQnaTitle" name="userQnaTitle" class="form-input" 
                       value="${userQna.userQnaTitle}" required maxlength="255">
            </div>
            
            <div class="form-group">
                <label for="userQna" class="form-label">문의내용 <span class="required">*</span></label>
                <textarea id="userQna" name="userQna" class="form-input form-textarea" required>${userQna.userQna}</textarea>
            </div>
            
            <div class="form-group">
                <label for="userQnaImg" class="form-label">첨부 이미지</label>
                
                <c:if test="${not empty userQna.userQnaImg}">
                    <div class="current-image">
                        <p><strong>현재 이미지:</strong></p>
                        <img src="${contextPath}/resources/uploadFiles/${userQna.userQnaImg}" alt="현재 첨부이미지">
                        <p style="margin-top: 10px; font-size: 12px; color: #666;">
                            새 이미지를 선택하면 기존 이미지가 교체됩니다.
                        </p>
                    </div>
                </c:if>
                
                <input type="file" id="userQnaImg" name="upfile" class="form-input" 
                       accept="image/*" onchange="previewImage(this)">
                <div class="file-info">
                    * 이미지 파일만 업로드 가능합니다. (JPG, PNG, GIF - 최대 10MB)
                </div>
                <div id="imagePreview" style="margin-top: 10px;"></div>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-warning">수정완료</button>
                <a href="${contextPath}/userqna/detail.uq?qno=${userQna.userQnaNum}" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
    
    <script>
        function validateForm() {
            var title = document.getElementById("userQnaTitle").value.trim();
            var content = document.getElementById("userQna").value.trim();
            
            if(title === "") {
                alert("제목을 입력해주세요.");
                document.getElementById("userQnaTitle").focus();
                return false;
            }
            
            if(content === "") {
                alert("문의내용을 입력해주세요.");
                document.getElementById("userQna").focus();
                return false;
            }
            
            if(title.length > 255) {
                alert("제목은 255자 이내로 입력해주세요.");
                document.getElementById("userQnaTitle").focus();
                return false;
            }
            
            return confirm("문의사항을 수정하시겠습니까?");
        }
        
        function previewImage(input) {
            var preview = document.getElementById("imagePreview");
            preview.innerHTML = "";
            
            if (input.files && input.files[0]) {
                var file = input.files[0];
                
                // 파일 크기 체크 (10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert("파일 크기는 10MB 이하만 업로드 가능합니다.");
                    input.value = "";
                    return;
                }
                
                // 이미지 미리보기
                var reader = new FileReader();
                reader.onload = function(e) {
                    var div = document.createElement("div");
                    div.style.marginTop = "10px";
                    div.innerHTML = "<p style='margin-bottom: 5px; font-weight: bold; color: #007bff;'>새 이미지 미리보기:</p>";
                    
                    var img = document.createElement("img");
                    img.src = e.target.result;
                    img.style.maxWidth = "300px";
                    img.style.maxHeight = "200px";
                    img.style.border = "1px solid #ddd";
                    img.style.borderRadius = "5px";
                    div.appendChild(img);
                    preview.appendChild(div);
                }
                reader.readAsDataURL(file);
            }
        }
    </script>
</body>
</html>