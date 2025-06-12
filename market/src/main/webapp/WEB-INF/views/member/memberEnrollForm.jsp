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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
					<input type="hidden" class="form-control" id="latitude" name="latitude">
					<input type="hidden" class="form-control" id="longitude" name="longitude">
					
					<!-- 확인 버튼 영역 -->
					<div class="btns" align="center" >
						<div id="confirmBox" style="display:none;" class="innerOuter">
							<h1 style="color: #7c5cc4;">해당 위치가 맞습니까?<br><br> </h1>
						    <p style="font-size: 14px;color: #7c5cc4;">
						    위치는 오차가 있을 수 있으며,</p>
						    <h3 style="color: green;"> 현재 위치의 근처로 설정하셔도 무관합니다.</h3>
						    <p style="font-size: 14px;color: #7c5cc4;">
						    네트워크 이용환경에 따라 위치가 다르게 조회될 수 있습니다.<br>
						    주소는 이후 마이페이지에서 갱신하실수 있습니다.</p>
						    <br>
						    <!-- 주소 표시 영역 -->
							<div id="addressBox">
							    <h2 id="parcel" style="color: green;"></h2>
							</div><br><br>
						    <button  type="button" class="btn btn-primary" onclick="checkStation(true)">내 위치 다시 확인</button>
						</div>
					<br>
			
					</div>
                   
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
	  	function checkStation(answer) {
	  	    if (navigator.geolocation) {
	  	        navigator.geolocation.getCurrentPosition(function(position) {
	  	            const lat = position.coords.latitude;
	  	            const lng = position.coords.longitude;
	
	  	            $('#latitude').val(lat);
	  	            $('#longitude').val(lng);
	
	  	            $.ajax({
	  	                url: "Gecoding",
	  	                data: {
	  	                    longitude: lng,
	  	                    latitude: lat
	  	                },
	  	                success: function(result) {
	  	                	if(answer){
	  	                		alert("주소 정보를 다시 가져왔습니다.");
	  	                	}
	  	                    $('#parcel').text("주소: " + result.parcel);
	  	                    $('#confirmBox').show();
	  	                },
	  	                error: function() {
	  	                	$('#parcel').text("주소를 가져오지 못했습니다. 가입을 위해 다시 시도해주세요");
	  	                    alert("주소 정보를 가져오지 못했습니다.");
	  	                }
	  	            });
	
	  	        }, function(error) {
	  	            alert('위치 정보를 가져올 수 없습니다. 브라우저 설정을 확인해주세요.');
	  	        });
	  	    } else {
	  	        alert('이 브라우저는 위치 서비스를 지원하지 않습니다.');
	  	    }
	  	}
	  	
	  	$(document).ready(function() {
	  		checkStation(false);
	  	});
		$(function (){
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
	                if (!$('#latitude').val().trim()&&!$('#longitude').val().trim()) {
	                	submitBtn.attr("disabled", true);
	                } else {
	                	 submitBtn.attr("disabled", false);
	                }
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