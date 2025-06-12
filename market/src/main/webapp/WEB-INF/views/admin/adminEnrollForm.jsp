<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 등록</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        .form-container { max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; }
        input { width: 100%; padding: 10px; margin: 5px 0; }
        button { padding: 12px 20px; margin: 5px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>관리자 등록</h2>
        <form action="insert.ad" method="post">
            <input type="text" name="adminId" placeholder="관리자 ID" required>
            <button type="button" onclick="checkId()">중복체크</button>
            <input type="password" name="adminPw" placeholder="비밀번호" required>
            <input type="text" name="adminName" placeholder="관리자 이름" required>
            <button type="submit">등록</button>
            <button type="button" onclick="location.href='main.ad'">취소</button>
        </form>
    </div>
    <script>
        function checkId() {
            const adminId = document.querySelector('input[name="adminId"]').value;
            if(!adminId) { alert('아이디를 입력하세요'); return; }
            
            fetch('idCheck.ad?adminId=' + adminId)
                .then(response => response.text())
                .then(data => {
                    if(data === 'NNNNY') {
                        alert('사용 가능한 아이디입니다.');
                    } else {
                        alert('이미 사용중인 아이디입니다.');
                    }
                });
        }
    </script>
</body>
</html>