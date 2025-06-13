<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">

<head>
   <meta charset="UTF-8" />
   <meta name="viewport" content="width=device-width, initial-scale=1.0" />
   <title>담금마켓</title>

	<style>
	body {
		font-family: 'Noto Sans KR', sans-serif;
		margin: 0;
		padding: 0;
		background: #fafafa;
	}
	
	/* 햄버거 버튼 */
	#hamburger {
		position: fixed;
		top: 15px;
		left: 15px;
		font-size: 28px;
		background: transparent;
		border: none;
		cursor: pointer;
		color: #7b68ee;
		z-index: 1100;
		outline: none;
	}
	
	/* 사이드바 */
	.sidebar {
		position: fixed;
		top: 0;
		left: -260px;
		width: 260px;
		height: 100vh;
		background-color: #e6e6fa;
		box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
		padding: 20px;
		box-sizing: border-box;
		transition: left 0.3s ease;
		z-index: 1050;
	}
	
	.sidebar.open {
		left: 0;
	}
	
	.sidebar h3 {
		margin-top: 0;
		color: #5a4fcf;
		margin-bottom: 20px;
	}
	
	.sidebar ul {
		list-style: none;
		padding: 0;
		margin: 0;
	}
	
	.sidebar ul li {
		padding: 12px 0;
		border-bottom: 1px solid #cfcfff;
		cursor: pointer;
		color: #4b3bdb;
		font-weight: 600;
	}
	
	#categorySearch {
		width: 100%;
		padding: 8px 10px;
		margin-bottom: 15px;
		border: 1px solid #cfcfff;
		border-radius: 4px;
		font-size: 14px;
		box-sizing: border-box;
	}
	
	/* header */
	#header {
		width: 100%;
		background-color: #a798f7;
		padding-top: 60px;
		box-sizing: border-box;
		color: white;
	}
	
	#header_1 {
		position: relative;
		height: 100px;
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 0 20px;
		box-sizing: border-box;
	}
	
	#header_1_center {
		position: absolute;
		left: 50%;
		transform: translateX(-50%);
		text-align: center;
	}
	
	#header_1_center h1 {
		font-size: 32px;
		margin: 0;
	}
	
	#header_1_center p {
		margin: 5px 0 0;
		font-size: 16px;
		color: #f0f0f0; /* 연보라 배경에서 잘 보이도록 */
	}
	
	#header_1_right {
		position: absolute;
		right: 20px;
		top: 50%;
		transform: translateY(-50%);
	}
	
	#header_1_right a {
		color: white;
		margin-left: 15px;
		text-decoration: none;
		font-weight: 500;
		cursor: pointer;
	}
	
	#header_1_right label {
		font-weight: 600;
	}
	
	#header_2 {
		background-color: #8c7ae6;
		padding: 0 20px;
		display: flex;
		align-items: center;
		justify-content: flex-end;
	}
	
	#header_2 ul {
		display: flex;
		justify-content: flex-end;
		list-style: none;
		padding: 0;
		margin: 0;
		gap: 20px;
	}
	
	#header_2 ul li a {
		color: white;
		text-decoration: none;
		font-weight: 600;
		padding: 6px 10px;
		display: inline-block;
		line-height: 1;
	}
	
	#header_2 ul li a:hover {
		text-decoration: underline;
	}
	
	/* Hero Section */
	.hero {
		padding: 10px 20px;
		min-height: 200px;
		background: linear-gradient(135deg, #d3cce3 0%, #e9e4f0 100%);
		text-align: center;
		color: #5a4fcf;
		position: relative;
		z-index: 1;
	}
	
	.hero h1 {
		font-size: 20px;
		margin-bottom: 15px;
		font-weight: 700;
		color: #5a4fcf;
	}
	
	.hero p {
		font-size: 20px;
		font-weight: 500;
		color: #7b68ee;
	}
	
	/* 로그인 모달 스타일 */
	.modal {
		display: none;
		position: fixed;
		top: 0;
		left: 0;
		width: 100vw;
		height: 100vh;
		background: rgba(0, 0, 0, 0.5);
		justify-content: center;
		align-items: center;
		z-index: 1200;
	}
	
	.modal.show {
		display: flex;
	}
	
	.modal-content {
		background: white;
		padding: 20px 30px;
		border-radius: 8px;
		width: 320px;
		box-sizing: border-box;
		position: relative;
		box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
	}
	
	.modal-content h4 {
		margin-top: 0;
		margin-bottom: 20px;
		color: #5a4fcf;
		font-weight: 700;
		text-align: center;
	}
	
	.modal-content label {
		display: block;
		margin-bottom: 5px;
		font-weight: 600;
		color: #4b3bdb;
	}
	
	.modal-content input[type="text"], .modal-content input[type="password"]
		{
		width: 100%;
		padding: 8px 10px;
		margin-bottom: 15px;
		border: 1px solid #ccc;
		border-radius: 4px;
		box-sizing: border-box;
		font-size: 14px;
	}
	
	.modal-content button {
		padding: 10px 18px;
		border: none;
		border-radius: 4px;
		font-weight: 600;
		cursor: pointer;
		font-size: 14px;
	}
	
	.btn-primary {
		background-color: #7b68ee;
		color: white;
		margin-right: 10px;
	}
	
	.btn-primary:hover {
		background-color: #5a4fcf;
	}
	
	.btn-danger {
		background-color: #e57373;
		color: white;
	}
	
	.btn-danger:hover {
		background-color: #d32f2f;
	}
	
	.close-btn {
		position: absolute;
		top: 10px;
		right: 15px;
		font-size: 24px;
		font-weight: bold;
		color: #7b68ee;
		cursor: pointer;
	}
	</style>
</head>

<body>
   <c:set var="contextRoot" value="${pageContext.request.contextPath}" />

   <script>
      var msg = "${alertMsg}";
      if (msg != "") {
         alert(msg);
      }
   </script>
   <c:remove var="alertMsg" />

   <!-- 햄버거 버튼 -->
   <button id="hamburger" onclick="toggleSidebar()">☰</button>

    <!-- 사이드바 -->
   <div class="sidebar" id="sidebar">
      <h3>카테고리</h3>
      <input type="text" id="categorySearch" placeholder="카테고리 검색"/>
      <ul id="categoryList">
         <li data-category="디지털기기">디지털기기</li>
         <li data-category="생활가전">생활가전</li>
         <li data-category="가구/인테리어">가구/인테리어</li>
         <li data-category="유아동">유아동</li>
         <li data-category="스포츠/레저">스포츠/레저</li>
         <li data-category="도서/음반">도서/음반</li>
         <li data-category="패션의류">패션의류</li>
         <li data-category="패션잡화">패션잡화</li>
         <li data-category="반련동물">반려동물</li>
         <li data-category="게임/취미">게임/취미</li>
      </ul>
   </div>

   <!-- header -->
   <div id="header">
      <div id="header_1">
         <div id="header_1_center">
         	<h1 class="floating">담금마켓</h1>
         	<p>묻고 따지지 말고 그냥 담금마켓 하세요. 후회하지 않습니다.</p>
         </div>		   	
         <div id="header_1_right">
				<c:choose>
					<c:when test="${empty loginUser and empty loginAdmin}">
						<a href="${contextRoot}/insert.me">회원가입</a> 
						<a href="#"id="loginLink">로그인</a>
						<a href="#" id="adminLoginLink">관리자로그인</a>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${not empty loginUser}">
								<span>${loginUser.userName}님 환영합니다.</span>
								<a href="${contextRoot}/mypage.me">마이페이지</a>
								<a href="${contextRoot}/logout.me">로그아웃</a>
							</c:when>
							<c:when test="${not empty loginAdmin}">
								<span>${loginAdmin.adminName}님 환영합니다.</span>
								<a href="${contextRoot}/admin/main.ad">관리자 페이지</a>
								<a href="${contextRoot}/admin/logout.ad">로그아웃</a>
							</c:when>
						</c:choose>

					</c:otherwise>
				</c:choose>
			</div>
      </div>

      <div id="header_2">
         <ul>
         <li><a href="${contextRoot}">HOME</a></li>
	       <c:choose>
				<c:when test="${not empty loginUser or not empty loginAdmin}">
					<li><a href="${contextRoot}/product/pd-view">내상품</a>
		         	<li><a href="${contextRoot}/user/FavoriteList">찜목록</a></li>
		        </c:when>
	        </c:choose>
         </ul>
      </div>
   </div>
 
   <!-- Hero -->
   <section class="hero" id="home">
      <div class="container">
         <h1 class="floating">광고</h1>
      </div>
   </section>

	
   <!-- 로그인 모달 -->
   <div class="modal" id="loginModal">
      <div class="modal-content">
         <span class="close-btn" id="closeModal">&times;</span>
         <h4>Login</h4>
         <form action="${contextRoot}/login.me" method="post">
            <label for="userId">ID:</label>
            <input type="text" id="userId" name="userId" required />

            <label for="passWord">Password:</label>
            <input type="password" id="passWord" name="passWord" required />

            <div style="text-align: center;">
               <button type="submit" class="btn-primary">로그인</button>
               <button type="button" class="btn-danger" id="cancelBtn">취소</button>
            </div>
         </form>
      </div>
   </div>


	<!-- 관리자 로그인 모달 -->
   <div class="modal" id="adminLoginModal">
      <div class="modal-content">
         <span class="close-btn" id="closeAdminModal">&times;</span>
         <h4>관리자 로그인</h4>
         <form action="${contextRoot}/admin/login.ad" method="post">
            <label for="adminId">관리자 ID:</label>
            <input type="text" id="adminId" name="adminId" required />

            <label for="adminPw">비밀번호:</label>
            <input type="password" id="adminPw" name="adminPw" required />

            <div style="text-align: center;">
               <button type="submit" class="btn-primary">관리자 로그인</button>
               <button type="button" class="btn-danger" id="cancelAdminBtn">취소</button>
            </div>
         </form>
      </div>
   </div>




   <br clear="both" />

   <!-- 사이드바 자동 닫힘 스크립트 -->
   <script>
      let sidebarTimer;

      function toggleSidebar() {
         const sidebar = document.getElementById('sidebar');
         sidebar.classList.toggle('open');

         if (sidebar.classList.contains('open')) {
            clearTimeout(sidebarTimer);
            sidebarTimer = setTimeout(() => {
               sidebar.classList.remove('open');
            }, 5000);
         }
      }
   </script>

   <!-- 로그인 모달 제어 스크립트 -->
   <script>
      const loginLink = document.getElementById('loginLink');
      const modal = document.getElementById('loginModal');
      const closeBtn = document.getElementById('closeModal');
      const cancelBtn = document.getElementById('cancelBtn');

      // 로그인 링크 클릭 시 모달 열기
      loginLink.addEventListener('click', (e) => {
         e.preventDefault();
         modal.classList.add('show');
      });

      // 닫기 버튼 클릭 시 모달 닫기
      closeBtn.addEventListener('click', () => modal.classList.remove('show'));

      // 취소 버튼 클릭 시 모달 닫기
      cancelBtn.addEventListener('click', () => modal.classList.remove('show'));

      // 모달 바깥 클릭 시 모달 닫기
      modal.addEventListener('click', (e) => {
         if (e.target === modal) {
            modal.classList.remove('show');
         }
      });
   </script>
   
   
   <!-- 관리자 로그인 모달 제어 스크립트 -->
   <script>
      const adminLoginLink = document.getElementById('adminLoginLink');
      const adminModal = document.getElementById('adminLoginModal');
      const closeAdminBtn = document.getElementById('closeAdminModal');
      const cancelAdminBtn = document.getElementById('cancelAdminBtn');

      // 관리자 로그인 링크 클릭 시 모달 열기
      if (adminLoginLink) {
         adminLoginLink.addEventListener('click', (e) => {
            e.preventDefault();
            adminModal.classList.add('show');
         });
      }

      // 닫기 버튼 클릭 시 모달 닫기
      if (closeAdminBtn) {
         closeAdminBtn.addEventListener('click', () => adminModal.classList.remove('show'));
      }

      // 취소 버튼 클릭 시 모달 닫기
      if (cancelAdminBtn) {
         cancelAdminBtn.addEventListener('click', () => adminModal.classList.remove('show'));
      }

      // 모달 바깥 클릭 시 모달 닫기
      adminModal.addEventListener('click', (e) => {
         if (e.target === adminModal) {
            adminModal.classList.remove('show');
         }
      });
   </script>
   
   
</body>

</html>