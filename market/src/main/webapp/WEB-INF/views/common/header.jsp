<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8" />
   <meta name="viewport" content="width=device-width, initial-scale=1.0" />
   <title>담금마켓header</title>
   <style>
      * {
         margin: 0;
         padding: 0;
         box-sizing: border-box;
      }

        #header_1>div{
            height:100%;
            float:left;
        }

        #header_1_center {width:40%;}
        #header_1_right {width:30%;}
        #header_1_right {text-align:center; line-height:35px; font-size:12px; text-indent:35px;}
        #header_1_right>a {margin:5px;}
        #header_1_right>a:hover {cursor:pointer;}

      header {
         background: rgba(255, 255, 255, 0.9);
         backdrop-filter: blur(10px);
         box-shadow: 0 2px 20px rgba(139, 69, 255, 0.1);
         position: fixed;
         width: 100%;
         top: 0;
         z-index: 1000;
         transition: all 0.3s ease;
      }

      nav {
         display: flex;
         justify-content: space-between;
         align-items: center;
         padding: 1rem 0;
      }

      .logo {
         font-size: 1.8rem;
         font-weight: bold;
         background: linear-gradient(45deg, #8b45ff, #b45aff);
         -webkit-background-clip: text;
         -webkit-text-fill-color: transparent;
         background-clip: text;
      }

      .nav-links {
         display: flex;
         list-style: none;
         gap: 2rem;
      }

      .nav-links a {
         text-decoration: none;
         color: #666;
         font-weight: 500;
         transition: color 0.3s ease;
      }

      .nav-links a:hover {
         color: #8b45ff;
      }

      .nav-buttons {
         display: flex;
         gap: 1rem;
      }

      .btn {
         padding: 0.7rem 1.5rem;
         border: none;
         border-radius: 25px;
         font-weight: 500;
         cursor: pointer;
         transition: all 0.3s ease;
         text-decoration: none;
         display: inline-block;
      }

      .btn-login {
         background: transparent;
         color: #8b45ff;
         border: 2px solid #8b45ff;
      }

      .btn-login:hover {
         background: #8b45ff;
         color: white;
         transform: translateY(-2px);
         box-shadow: 0 5px 15px rgba(139, 69, 255, 0.3);
      }

      .btn-join {
         background: linear-gradient(45deg, #8b45ff, #b45aff);
         color: white;
      }

      .btn-join:hover {
         transform: translateY(-2px);
         box-shadow: 0 5px 15px rgba(139, 69, 255, 0.4);
      }

      .btn-chat {
         background: linear-gradient(45deg, #b45aff, #8b45ff);
         color: white;
         border: 2px solid #b45aff;
         padding: 0.7rem 1.5rem;
         border-radius: 25px;
         font-weight: 500;
         cursor: pointer;
         transition: all 0.3s ease;
         text-decoration: none;
         display: inline-block;
      }

      .btn-chat:hover {
         background: linear-gradient(45deg, #8b45ff, #b45aff);
         border-color: #8b45ff;
         box-shadow: 0 5px 15px rgba(180, 90, 255, 0.4);
         transform: translateY(-2px);
      }


      .hamburger {
         font-size: 2rem;
         background: none;
         border: none;
         color: #8b45ff;
         cursor: pointer;
         display: none;
      }

      @media (max-width: 768px) {

         .nav-links,
         .nav-buttons {
            display: none;
         }

         .hamburger {
            display: block;
         }
      }

      .sidebar {
         position: fixed;
         top: 0;
         left: -260px;
         width: 240px;
         height: 100%;
         background-color: #f5efff;
         box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
         padding: 2rem 1.2rem;
         transition: left 0.3s ease;
         z-index: 2000;
      }

      .sidebar.open {
         left: 0;
      }

      .sidebar h3 {
         color: #8b45ff;
         margin-bottom: 1rem;
      }

      .sidebar ul {
         list-style: none;
         padding: 0;
      }

      .sidebar li {
         margin: 1rem 0;
         font-weight: 500;
         cursor: pointer;
         color: #5c3d99;
      }

      .sidebar li:hover {
         color: #8b45ff;
      }

      .hero {
         margin-top: 80px;
         padding: 4rem 0;
         text-align: center;
      }

      .hero h1 {
         font-size: 3rem;
         margin-bottom: 1rem;
         background: linear-gradient(45deg, #8b45ff, #b45aff);
         -webkit-background-clip: text;
         -webkit-text-fill-color: transparent;
         background-clip: text;
      }

      .hero p {
         font-size: 1.2rem;
         color: #666;
         margin-bottom: 2rem;
         max-width: 600px;
         margin-left: auto;
         margin-right: auto;
      }

      .search-input {
         width: 100%;
         padding: 1rem 1.5rem;
         border: 2px solid #e0d9ff;
         border-radius: 50px;
         font-size: 1rem;
         outline: none;
         transition: all 0.3s ease;
      }

      .search-input:focus {
         border-color: #8b45ff;
         box-shadow: 0 0 20px rgba(139, 69, 255, 0.2);
      }

      .search-btn:hover {
         transform: translateY(-50%) scale(1.05);
      }
   </style>
</head>

<body>
	<c:set var="contextRoot" value="${pageContext.request.contextPath}"/>	
	
	<script>
	
		var msg="${alertMsg}";
		
		if(msg!=""){
			alert(msg);
		}
	</script>
	<c:remove var="alertMsg"/>
	
	
    <div id="header">
        <div id="header_1">
            <div id="header_1_center"></div>
            <div id="header_1_right">
            
            	<c:choose>
            		<c:when test="${empty loginUser}">
		                <!-- 로그인 전 -->
		                <a href="${contextRoot}/insert.me">회원가입</a>
		                <a data-toggle="modal" data-target="#loginModal">로그인</a> <!-- 모달의 원리 : 이 버튼 클릭시 data-targer에 제시되어있는 해당 아이디의 div요소를 띄워줌 -->
            		</c:when>
					<c:otherwise>
	                <!-- 로그인 후 -->
	                    <label>${loginUser.userName}님 환영합니다</label> &nbsp;&nbsp;
	                    <a href="${contextRoot }/mypage.me">마이페이지</a>
	                    <a href="${contextRoot}/logout.me">로그아웃</a>
					</c:otherwise>                
                </c:choose>
            </div>
        </div>
        <div id="header_2">
            <ul>
                <li><a href="${contextRoot}">HOME</a></li>
                <li><a href="">공지사항</a></li>
                <li><a href="${contextRoot}/list.bo">자유게시판</a></li>
                <li><a href="${contextRoot}/list.ph">사진게시판</a></li>
            </ul>
        </div>
    </div>

    <!-- 로그인 클릭 시 뜨는 모달 (기존에는 안보이다가 위의 a 클릭 시 보임) -->
    <div class="modal fade" id="loginModal">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Login</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <form action="${contextRoot}/login.me" method="post">
                    <!-- Modal body -->
                    <div class="modal-body">
                        <label for="userId" class="mr-sm-2">ID : </label>
                        <input type="text" class="form-control mb-2 mr-sm-2" placeholder="Enter ID" id="userId" name="userId"> <br>
                        <label for="passWord" class="mr-sm-2">Password : </label>
                        <input type="password" class="form-control mb-2 mr-sm-2" placeholder="Enter Password" id="passWord" name="passWord">
                    </div>
                           
                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">로그인</button>
                        <button type="button" class="btn btn-danger" data-dismiss="modal">취소</button>
                    </div>
                </form>
            </div>
    </div>
    <br clear="both">
</body>
</html>