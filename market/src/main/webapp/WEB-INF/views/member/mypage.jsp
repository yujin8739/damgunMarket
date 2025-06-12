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
			box-shadow: 0 4px 12px rgba(168, 139, 255, 0.2); /* 연보라 그림자 */
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
            
            <!-- 
            	updateMember() 메소드를 작성하여 정보수정 처리해보기 
            	성공시 : 정보수정 성공! 메시지와 함께 마이페이지로 되돌아오기 (변경된 정보 갱신)
            	실패시 : 에러페이지로 정보수정 실패! 메시지와 함께 위임시키기(model 이용)
            	
            	마이바티스 메소드와 태그는 update() / <update> 를 이용하시면 됩니다. 
            
             -->

            <form action="${contextRoot }/update.me" method="post">
                <div class="form-group">
                    <label for="userId">* ID : </label>
                    <input type="text" class="form-control" id="mypageId" value="${loginUser.userId }" name="userId" readonly> <br>

                    <label for="passWord">* Name : </label>
                    <input type="text" class="form-control" id="userName" value="${loginUser.userName }" name="userName" required> <br>

                    <label for="email"> &nbsp; Email : </label>
                    <input type="text" class="form-control" id="email" value="${loginUser.email }" name="email"> <br>
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
                    <button type="submit" class="btn btn-primary">수정하기</button>
                    <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#deleteForm">회원탈퇴</button>
                </div>
            </form>
        </div>
        <br><br>
        
    </div>
<<<<<<< HEAD
    
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
	  	});
    
    </script>
    
    
    <!-- 
    	성공시 회원 탈퇴 성공 메시지와 함께 메인페이지로 이동(재요청) - 세션에 담긴 로그인정보 삭제하기 
    	실패시 회원 탈퇴 실패 메시지와 함께 마이페이지로 이동(재요청) 	
    	회원탈퇴 처리도 update로 작성하기 (STATUS 에 Y를 N으로 변경하는 처리)   
     -->
    
    
=======

>>>>>>> branch 'main' of https://github.com/yujin8739/damgunMarket.git

    <!-- 회원탈퇴 버튼 클릭 시 보여질 Modal -->
    <div class="modal fade" id="deleteForm">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">회원탈퇴</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <form action="${contextRoot }/delete.me" method="post">
                	<!--요청시 아이디 전달 -->
                	<input type="hidden" name="userId" value="${loginUser.userId }">
                    <!-- Modal body -->
                    <div class="modal-body">
                        <div align="center">
                            탈퇴 후 복구가 불가능합니다. <br>
                            정말로 탈퇴 하시겠습니까? <br>
                        </div>
                        <br>
                            <label for="passWord" class="mr-sm-2">Password : </label>
                            <input type="password" class="form-control mb-2 mr-sm-2" placeholder="Enter Password" id="deleteUserPwd" name="userPwd"> <br>
                    </div>
                    <!-- Modal footer -->
                    <div class="modal-footer" align="center">
                        <button type="submit" class="btn btn-danger">탈퇴하기</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>