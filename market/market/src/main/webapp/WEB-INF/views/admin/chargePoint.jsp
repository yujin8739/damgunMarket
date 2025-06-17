<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>포인트 충전</title>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        h2 {
            color: #6d28d9;
            margin-bottom: 40px;
            font-size: 28px;
        }

        label {
            display: block;
            color: #4c1d95;
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 10px;
        }

        input {
            width: 100%;
            padding: 14px 16px;
            margin-bottom: 30px;
            border: 1px solid #c4b5fd;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        input:focus {
            border-color: #8b5cf6;
            outline: none;
            box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.25);
        }

        #chargeBtn {
            width: 100%;
            background-color: #8b5cf6;
            color: white;
            padding: 16px;
            font-size: 17px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #7c3aed;
        }

        #result {
            margin-top: 30px;
            font-size: 16px;
            font-weight: 600;
        }

</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container">
    <h2>포인트 충전</h2>

    <label for="userId">유저 ID</label>
    <input type="text" id="userId" placeholder="예: user123">

    <label for="point">충전 포인트</label>
    <input type="number" id="point" placeholder="예: 100">

    <button id="chargeBtn" onclick="chargePoint()">충전하기</button>

    <p id="result"></p>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script>
    function chargePoint() {
        const userId = $("#userId").val();
        const point = $("#point").val();
        const serverPath = '${pageContext.request.contextPath}';

        if (!userId || !point) {
            alert("모든 항목을 입력해주세요.");
            return;
        }

        $.ajax({
            url: serverPath+"/etc/chargePoint",
            data: {
                userId: userId,
                point: point
            },
            success: function(response) {
            	if(response>0){
               		$("#result").css("color", "#10b981").text("포인트 충전 완료!");
                } else {
                	$("#result").css("color", "#ef4444").text("관리자만 이용가능합니다!");
                }
            },
            error: function() {
                $("#result").css("color", "#ef4444").text("충전에 실패했습니다.");
            }
        });
    }
</script>

</body>
</html>
