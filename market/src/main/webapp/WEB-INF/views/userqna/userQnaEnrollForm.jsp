<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>문의사항 작성</title>
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
        
        .btn-primary {
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%);
            color: white;
            border: 2px solid #7b68ee;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
        }
        
        .btn-primary:hover {
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
        
        .help-text {
            font-size: 13px;
            color: #8a7bcc;
            margin-top: 8px;
            padding: 10px;
            background: linear-gradient(135deg, #faf9ff 0%, #f8f6ff 100%);
            border-radius: 8px;
            border-left: 3px solid #c8b8ff;
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
        
        /* 반응형 디자인 */
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