<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 작성</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-container { max-width: 800px; margin: 0 auto; }
        .form-group {
            margin-bottom: 20px;
       	 }
		.form-label {
	            display: block;
	            margin-bottom: 8px;
	            font-weight: bold;
	            color: #333;
	        }
        input, textarea { width: 100%; padding: 10px; margin: 5px 0; }
        textarea { height: 200px; }
        button { padding: 12px 20px; margin: 5px; }
    </style>
</head>
<body>
	
    <div class="form-container">
        <h2>공지사항 작성</h2>
        <form action="insert.bo" method="post">
            <input type="text" name="noticeTitle" placeholder="제목" required>
            <textarea name="notice" placeholder="내용" required></textarea>
            <!-- <input type="text" name="noticeImg" placeholder="이미지 URL (선택사항)"> -->
            <button type="submit">등록</button>
            <button type="button" onclick="location.href='list.bo'">취소</button>
        </form>
    </div>
    <div class="form-group">
                <label for="noticeImg" class="form-label">첨부 이미지</label>
                <input type="file" id="noticeImg" name="upfile" class="form-input" 
                       accept="image/*" onchange="previewImage(this)">
                <div class="file-info">
                    * 이미지 파일만 업로드 가능합니다. (JPG, PNG, GIF - 최대 10MB)
                </div>
                <div id="imagePreview" style="margin-top: 10px;"></div>
            </div>
            
	<script>
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