<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Document</title>
<style>
	.content {
		display: flex;
		justify-content: center;
		padding: 50px 20px;
		background-color: #f4efff; /* 전체 배경: 연보라 */
	}
	
	.innerOuter {
		width: 100%;
		max-width: 500px;
		background-color: #ffffff;
		border-radius: 16px;
		padding: 30px 40px;
		box-shadow: 0 4px 12px rgba(168, 139, 255, 0.2); /* 연보라 그림자 */
	}
	
	.form-title {
		text-align: center;
		color: #7c5cc4;
		margin-bottom: 30px;
	}
	
	.form-group {
		display: flex;
		flex-direction: column;
	}
	
	.form-group label {
		margin-top: 12px;
		font-weight: bold;
		color: #7c5cc4;
	}
	
	.form-group input {
		padding: 10px;
		margin-top: 4px;
		border: 1px solid #ccc;
		border-radius: 6px;
		font-size: 14px;
		transition: border-color 0.3s ease;
	}
	
	.form-group input:focus {
		border-color: #a88bff;
		outline: none;
		background-color: #f4f0ff;
	}
	
	.msg-div {
		font-size: 0.8em;
		margin-top: 5px;
		display: none;
	}
	
	.btns {
		margin-top: 30px;
		display: flex;
		justify-content: space-between;
	}
	
	.btns .btn {
		width: 48%;
		padding: 12px 0;
		font-size: 16px;
		border: none;
		border-radius: 8px;
		cursor: pointer;
	}
	
	.btns .btn-primary {
		background-color: #a88bff;
		color: #fff;
	}
	
	.btns .btn-primary:disabled {
		background-color: #d6cfff;
		color: #eee;
		cursor: not-allowed;
	}
	
	.btns .btn-danger {
		background-color: #d32f2f;
		color: #fff;
	}
	
	@media ( max-width : 600px) {
		.innerOuter {
			padding: 20px;
		}
		.btns {
			flex-direction: column;
			gap: 10px;
		}
		.btns .btn {
			width: 100%;
		}
	}
</style>
</head>
<body>
    
    <!-- 메뉴바 -->
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="content">
        <br><br>
        <div class="innerOuter">
            <h2>회원가입</h2>
            <br>

            <form action="${contextRoot}/insert.me" method="post">
                <div class="form-group">
                    <label for="userId">* ID : </label>
                    <input type="text" class="form-control" id="insertUserId" placeholder="Please Enter ID" name="userId" required> <br>
					<div id="resultDiv" style="font-size:0.8em; display:none"></div> 
					
                    <label for="passWord">* Password : </label>
                    <input type="password" class="form-control" id="insertPassWord" placeholder="Please Enter Password" name="passWord" required> <br>

                    <label for="checkPwd">* Password Check : </label>
                    <input type="password" class="form-control" id="checkPwd" placeholder="Please Enter Password" required> <br>
					<div id="pwdCheckMsg" style="font-size: 0.8em; display: none;"></div>
					
                    <label for="userName">* Name : </label>
                    <input type="text" class="form-control" id="userName" placeholder="Please Enter Name" name="userName" required> <br>
					<div id="nameMsg" style="font-size: 0.8em; display: none;"></div>
					
                    <label for="email"> &nbsp; Email : </label>
                    <input type="text" class="form-control" id="email" placeholder="Please Enter Email" name="email"> <br>

                   
                </div> 
                <br>
                <div class="btns" align="center">
                    <button type="submit" class="btn btn-primary" disabled>회원가입</button>
                    <button type="reset" class="btn btn-danger">초기화</button>
                </div>
            </form>
        </div>
        <br><br>

    </div>
    
 
  	<script>
$(function(){
    var inputId = $("#insertUserId");
    var inputPwd = $("#insertPassWord");
    var inputPwdCheck = $("#checkPwd");
    var inputName = $("#userName");

    var resultDiv = $("#resultDiv");
    var pwdCheckMsg = $("#pwdCheckMsg");
    var nameMsg = $("#nameMsg");
    var submitBtn = $(".btns>button[type=submit]");

    let idUsable = false;

    // 이름 확인
    function checkNameValid() {
        const name = inputName.val().trim();
        if (name.length === 0) {
            nameMsg.css({ display: "block", color: "red" }).text("이름을 입력해 주세요.");
            return false;
        } else {
            nameMsg.css({ display: "block", color: "green" }).text("이름이 입력되었습니다.");
            return true;
        }
    }

    // 비밀번호 일치 확인
    function checkPasswordMatch() {
        const pwd = inputPwd.val();
        const confirmPwd = inputPwdCheck.val();

        if (pwd.length === 0 && confirmPwd.length === 0) {
            pwdCheckMsg.hide();
            return false;
        }

        if (pwd !== confirmPwd) {
            pwdCheckMsg.css({ display: "block", color: "red" }).text("비밀번호가 일치하지 않습니다.");
            return false;
        } else {
            pwdCheckMsg.css({ display: "block", color: "green" }).text("비밀번호가 일치합니다.");
            return true;
        }
    }

    // 최종 검사해서 버튼 활성화
    function validateAll() {
        const pwdOk = checkPasswordMatch();
        const nameOk = checkNameValid();

        if (idUsable && pwdOk && nameOk) {
            submitBtn.attr("disabled", false);
        } else {
            submitBtn.attr("disabled", true);
        }
    }

    // 아이디 입력 검사 + AJAX 중복 확인
    inputId.keyup(function(){
        const val = inputId.val();
        if(val.length > 4){
            $.ajax({
                url : "idCheck.me",
                data : { userId : val },
                success : function(result){
                    if(result === "NNNNN"){
                        resultDiv.css({ display: "block", color: "red" }).text("사용 불가능한 아이디 입니다.");
                        idUsable = false;
                    } else {
                        resultDiv.css({ display: "block", color: "green" }).text("사용 가능한 아이디 입니다.");
                        idUsable = true;
                    }
                    validateAll();
                },
                error : function(){
                    resultDiv.css({ display: "block", color: "red" }).text("서버 오류");
                    idUsable = false;
                    validateAll();
                }
            });
        } else {
            resultDiv.css({ display: "block", color: "orange" }).text("아이디는 최소 5글자 이상이어야 합니다.");
            idUsable = false;
            validateAll();
        }
    });

    inputPwd.keyup(validateAll);
    inputPwdCheck.keyup(validateAll);
    inputName.keyup(validateAll);
});
</script>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>