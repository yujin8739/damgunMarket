<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의사항 작성</title>
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #007bff;
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
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 5px rgba(0,123,255,0.3);
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
        
        .btn-primary {
            background-color: #007bff;
            color: white;
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
        
        .help-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        .file-info {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 12px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-header">
            <h1>문의사항 작성</h1>
            <p>궁금한 사항이나 문제점을 자세히 작성해 주세요.</p>
        </div>
        
        <form action="${contextPath}/userqna/insert.uq" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="userQnaTitle" class="form-label">제목 <span class="required">*</span></label>
                <input type="text" id="userQnaTitle" name="userQnaTitle" class="form-input" 
                       placeholder="문의사항 제목을 입력해주세요" required maxlength="255">
            </div>
            
            <div class="form-group">
                <label for="userQna" class="form-label">문의내용 <span class="required">*</span></label>
                <textarea id="userQna" name="userQna" class="form-input form-textarea" 
                          placeholder="문의사항을 자세히 작성해주세요" required></textarea>
                <div class="help-text">
                    문제 발생 상황, 사용 환경, 오류 메시지 등을 구체적으로 작성해주시면 더 정확한 답변을 받으실 수 있습니다.
                </div>
            </div>
            
            <div class="form-group">
                <label for="userQnaImg" class="form-label">첨부 이미지</label>
                <input type="file" id="userQnaImg" name="upfile" class="form-input" 
                       accept="image/*" onchange="previewImage(this)">
                <div class="file-info">
                    * 이미지 파일만 업로드 가능합니다. (JPG, PNG, GIF - 최대 10MB)
                </div>
                <div id="imagePreview" style="margin-top: 10px;"></div>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">문의하기</button>
                <a href="${contextPath}/userqna/list.uq" class="btn btn-secondary">취소</a>
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
            
            return true;
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
                    var img = document.createElement("img");
                    img.src = e.target.result;
                    img.style.maxWidth = "300px";
                    img.style.maxHeight = "200px";
                    img.style.border = "1px solid #ddd";
                    img.style.borderRadius = "5px";
                    preview.appendChild(img);
                }
                reader.readAsDataURL(file);
            }
        }
    </script>
</body>
</html>