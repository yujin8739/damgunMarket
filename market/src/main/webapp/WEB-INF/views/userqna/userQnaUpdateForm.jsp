<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의사항 수정</title>
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #ffc107;
            padding-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        
        .form-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        .form-input:focus {
            border-color: #ffc107;
            outline: none;
            box-shadow: 0 0 5px rgba(255,193,7,0.3);
        }
        
        .form-textarea {
            height: 200px;
            resize: vertical;
            font-family: inherit;
        }
        
        .btn-group {
            text-align: center;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 30px;
            margin: 0 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
        
        .required {
            color: red;
        }
        
        .current-image {
            margin: 10px 0;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        
        .current-image img {
            max-width: 200px;
            max-height: 150px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        
        .file-info {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 12px;
            color: #666;
        }
        
        .info-box {
            background-color: #d1ecf1;
            border: 1px solid #bee5eb;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
            color: #0c5460;
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