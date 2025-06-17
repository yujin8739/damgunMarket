<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 작성</title>
    <style>
        body { 
            font-family: 'Noto Sans KR', sans-serif; 
            margin: 20px; 
            background: linear-gradient(135deg, #faf9ff 0%, #f5f2ff 100%);
        }
        
        .form-container { 
            max-width: 800px; 
            margin: 0 auto; 
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(180, 139, 255, 0.08);
            border: 2px solid #f0ebff;
            padding: 40px;
        }
        
        .form-container h2 {
            color: #a88bff;
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
            text-shadow: 0 2px 4px rgba(168, 139, 255, 0.15);
        }
        
        .form-group {
            margin-bottom: 20px;
            background: white;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #f0ebff;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.05);
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #a88bff;
        }
        
        input, textarea { 
            width: 100%; 
            padding: 15px; 
            margin: 10px 0; 
            border: 2px solid #e8e0ff;
            border-radius: 10px;
            font-size: 14px;
            background: rgba(255, 255, 255, 0.9);
            transition: all 0.3s ease;
            box-sizing: border-box;
        }
        
        input:focus, textarea:focus {
            border-color: #c8b8ff;
            outline: none;
            box-shadow: 0 0 15px rgba(200, 184, 255, 0.3);
            background: white;
        }
        
        textarea { 
            height: 200px; 
            font-family: inherit;
            line-height: 1.6;
            resize: vertical;
        }
        
        button { 
            padding: 15px 30px; 
            margin: 10px 5px; 
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        button[type="submit"] {
            background: linear-gradient(135deg, #8b45ff 0%, #b45aff 100%); 
            color: white; 
            border: 2px solid #7b68ee;
            box-shadow: 0 4px 15px rgba(139, 69, 255, 0.3);
        }
        
        button[type="submit"]:hover {
            background: linear-gradient(135deg, #7b68ee 0%, #9370db 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139, 69, 255, 0.4);
        }
        
        button[type="button"] {
            background: linear-gradient(135deg, #b4a0ff 0%, #c8b8ff 100%); 
            color: white; 
            border: 2px solid #a88bff;
            box-shadow: 0 4px 15px rgba(180, 160, 255, 0.2);
        }
        
        button[type="button"]:hover {
            background: linear-gradient(135deg, #a88bff 0%, #b49fff 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(180, 160, 255, 0.3);
        }
        
        .form-container form {
            background: white;
            padding: 30px;
            border-radius: 15px;
            border: 2px solid #f0ebff;
            box-shadow: 0 3px 10px rgba(180, 139, 255, 0.05);
        }
        
        .form-container input::placeholder,
        .form-container textarea::placeholder {
            color: #8a7bcc;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>공지사항 작성</h2>
        <form action="insert.bo" method="post">
            <input type="text" name="noticeTitle" placeholder="제목" required>
            <textarea name="notice" placeholder="내용" required></textarea>
            <button type="submit">등록</button>
            <button type="button" onclick="location.href='list.bo'">취소</button>
        </form>
    </div>
</body>
</html>