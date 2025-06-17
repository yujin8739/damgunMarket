<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <style>
        .content {
            background-color:rgb(247, 245, 245);
            width:80%;
            margin:auto;
        }
        .innerOuter {
            border:1px solid lightgray;
            width:80%;
            margin:auto;
            padding:5% 10%;
            background-color:white;
        }
        .addressOuter {
			width: 100%;
			max-width: 90%;
			background-color: #ffffff;
			border-radius: 16px;
			padding: 30px 40px;
			box-shadow: 0 4px 12px rgba(168, 139, 255, 0.2);
		}
        .password-section {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <div class="content">
        <br><br>
        <div class="innerOuter">
            <h2>마이페이지</h2>
            <br>

            <form action="${contextRoot }/update.me" method="post">
                <div class="form-group">
                    <label for="userId">* ID : </label>
                    <input type="text" class="form-control" id="mypageId" value="${loginUser.userId }" name="userId" readonly> <br>

                    <label for="passWord">* Name : </label>
                    <input type="text" class="form-control" id="userName" value="${loginUser.userName }" name="userName" required> <br>

                    <label for="email"> &nbsp; Email : </label>
                    <input type="text" class="form-control" id="email" value="${loginUser.email }" name="email"> <br>

                    <!-- 비밀번호 변경 섹션 -->
                    <div class="password-section">
                        <h5>🔒 비밀번호 변경 (선택사항)</h5>
                        <p class="text-muted">비밀번호를 변경하지 않으려면 아래 필드를 비워두세요.</p>
                        
                        <label for="newPassword">새 비밀번호 :</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="변경하지 않으려면 비워두세요">
                        <small class="form-text text-muted">8자 이상, 영문+숫자 조합을 권장합니다.</small>
                        <br>
                        
                        <label for="confirmPassword">새 비밀번호 확인 :</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="새 비밀번호를 다시 입력하세요">
                        <div id="passwordMatchMessage" class="mt-2"></div>
                    </div>

					<input type="hidden" class="form-control" id="latitude" name="latitude"  value="${loginUser.latitude}">
					<input type="hidden" class="form-control" id="longitude" name="longitude"  value="${loginUser.longitude}">
					
					<div class="btns" align="center">
						<div id="confirmBox" class="addressOuter">
							<h1 style="color: #7c5cc4;">해당 위치가 맞습니까?<br><br> </h1>
						    <p style="font-size: 14px;color: #7c5cc4;">
						    위치는 오차가 있을 수 있으며,</p>
						    <h3 style="color: green;"> 현재 위치의 근처로 설정하셔도 무관합니다.</h3>
						    <p style="font-size: 14px;color: #7c5cc4;">
						    네트워크 이용환경에 따라 위치가 다르게 조회될 수 있습니다.<br>
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
                    <button type="submit" class="btn btn-primary" id="updateBtn">수정하기</button>
                    <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#deleteForm">회원탈퇴</button>
                </div>
            </form>
        </div>
        <br><br>
    </div>

    <!-- 회원탈퇴 Modal -->
    <div class="modal fade" id="deleteForm">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">회원탈퇴</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <form action="${contextRoot }/delete.me" method="post">
                	<input type="hidden" name="userId" value="${loginUser.userId }">
                    <!-- Modal body -->
                    <div class="modal-body">
                        <div align="center">
                            탈퇴 후 복구가 불가능합니다. <br>
                            정말로 탈퇴 하시겠습니까? <br>
                        </div>
                        <br>
                            <label for="passWord" class="mr-sm-2">Password : </label>
                            <input type="password" class="form-control mb-2 mr-sm-2" placeholder="Enter Password" id="deletePassWord" name="passWord"> <br>
                    </div>
                    <!-- Modal footer -->
                    <div class="modal-footer" align="center">
                        <button type="submit" class="btn btn-danger">탈퇴하기</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
    	function geoCodingRun(lat,lng,answer){
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
	                },
	                error: function() {
	                	$('#parcel').text("주소를 가져오지 못했습니다. 가입을 위해 다시 시도해주세요");
	                    alert("주소 정보를 가져오지 못했습니다.");
	                }
	            });
    	}
    
	  	function checkStation(answer) {
	  	    if (navigator.geolocation) {
	  	        navigator.geolocation.getCurrentPosition(function(position) {
	  	            const lat = position.coords.latitude;
	  	            const lng = position.coords.longitude;
	  	          	geoCodingRun(lat,lng,answer);
	  	        }, function(error) {
	  	            alert('위치 정보를 가져올 수 없습니다. 브라우저 설정을 확인해주세요.');
	  	        });
	  	    } else {
	  	        alert('이 브라우저는 위치 서비스를 지원하지 않습니다.');
	  	    }
	  	}
	  	
	  	$(document).ready(function() {
	  		geoCodingRun($('#latitude').val(),$('#longitude').val(),false);
	  		
	  		// 비밀번호 확인 검증
	  		$('#confirmPassword').on('keyup', function() {
	  		    const newPassword = $('#newPassword').val();
	  		    const confirmPassword = $(this).val();
	  		    const messageDiv = $('#passwordMatchMessage');
	  		    const updateBtn = $('#updateBtn');
	  		    
	  		    // 새 비밀번호가 입력되었을 때만 검증
	  		    if (newPassword.length > 0) {
	  		        if (confirmPassword.length > 0) {
	  		            if (newPassword === confirmPassword) {
	  		                messageDiv.html('<span class="text-success">✓ 비밀번호가 일치합니다</span>');
	  		                updateBtn.prop('disabled', false);
	  		            } else {
	  		                messageDiv.html('<span class="text-danger">✗ 비밀번호가 일치하지 않습니다</span>');
	  		                updateBtn.prop('disabled', true);
	  		            }
	  		        } else {
	  		            messageDiv.html('<span class="text-warning">새 비밀번호 확인을 입력해주세요</span>');
	  		            updateBtn.prop('disabled', true);
	  		        }
	  		    } else {
	  		        // 새 비밀번호가 없으면 확인 메시지 지우고 버튼 활성화
	  		        messageDiv.html('');
	  		        updateBtn.prop('disabled', false);
	  		    }
	  		});
	  		
	  		// 새 비밀번호 입력 시에도 확인
	  		$('#newPassword').on('keyup', function() {
	  		    $('#confirmPassword').trigger('keyup');
	  		});
	  	});
    </script>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>