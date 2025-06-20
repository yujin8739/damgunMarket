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
	
	#hamburger.hide {
		opacity: 0;
		visibility: hidden;
		pointer-events: none;
		transition: all 0.1s ease;
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
		transition: all 0.3s ease;
	}
	
	#categorySearch:focus {
		border-color: #7b68ee;
		box-shadow: 0 0 8px rgba(123, 104, 238, 0.3);
		outline: none;
		background-color: #f8f7ff;
	}
	
	#categorySearch.active-search {
		border-color: #5a4fcf;
		background-color: #f0efff;
		box-shadow: 0 0 12px rgba(90, 79, 207, 0.4);
	}
	
	/* header */
	#header {
		width: 100%;
		background-color: #a798f7;
		padding-top: 8px;
		box-sizing: border-box;
		color: white;
	}
	
	#header_1 {
		position: relative;
		height: 75px;
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
		display: flex;
		align-items: center;
		gap: 2px;
		align-items: flex-end;
	}
	
	.title-icon {
		width: 50px;
		height: 50px;
		background: transparent;
		border-radius: 12px;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.jar-icon {
		position: relative;
		transform: scale(0.8);
	}
	
	/* 항아리 뚜껑 */
	.jar-lid {
		width: 30px;
		height: 8px;
		background: white;
		border-radius: 15px 15px 4px 4px;
		position: relative;
		margin: 0 auto;
	}
	
	/* 뚜껑 손잡이 */
	.jar-handle {
		width: 12px;
		height: 4px;
		background: white;
		border-radius: 6px 6px 2px 2px;
		position: absolute;
		top: -3px;
		left: 50%;
		transform: translateX(-50%);
	}
	
	/* 항아리 몸체 */
	.jar-body {
		width: 28px;
		height: 32px;
		background: white;
		border-radius: 3px 3px 10px 10px;
		position: relative;
		margin: 2px auto 0;
	}
	
	/* 항아리 내부 */
	.jar-inner {
		width: 20px;
		height: 24px;
		background: #a798f7;
		border-radius: 2px 2px 8px 8px;
		position: absolute;
		top: 4px;
		left: 50%;
		transform: translateX(-50%);
	}
	
	#header_1_center h1 {
		font-size: 39px;
		margin: 0;
	}
	
	#header_1_center p {
		margin: 5px 0 0;
		font-size: 16px;
		color: #f0f0f0;
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
	
	/* 광고 영역 */
	.hero {
		padding: 15px 20px;
		min-height: 300px;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		color: white;
		position: relative;
		overflow: hidden;
	}
	
	.hero::before {
		content: '';
		position: absolute;
		top: -50%;
		right: -50%;
		width: 200%;
		height: 200%;
		background:
			url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="2" fill="rgba(255,255,255,0.1)"/></svg>')
			repeat;
		animation: float 20s linear infinite;
	}
	
	@keyframes float {
		0% {
			transform: translateX(-50px) translateY(-50px);
		}
		100% {
			transform: translateX(50px) translateY(50px);
		}
	}
	
	.banner-content {
		display: flex;
		justify-content: space-between;
		align-items: center;
		max-width: 1200px;
		margin: 0 auto;
		position: relative;
		z-index: 2;
	}
	
	.banner-text {
		flex: 1;
		max-width: 600px;
	}
	
	.banner-badge {
		background: #ff6b35;
		color: white;
		padding: 8px 20px;
		border-radius: 25px;
		font-size: 14px;
		font-weight: bold;
		display: inline-block;
		margin-bottom: 20px;
		animation: pulse 2s infinite;
	}
	
	@keyframes pulse {
		0%, 100% {
			transform: scale(1);
		}
		50% {
			transform: scale(1.05);
		}
	}
	
	.banner-text h1 {
		font-size: 2.8rem;
		font-weight: 700;
		line-height: 1.2;
		margin-bottom: 20px;
	}
	
	.highlight {
		color: #ff6b35;
		text-shadow: 0 0 20px rgba(255, 107, 53, 0.5);
	}
	
	.banner-text p {
		font-size: 1.2rem;
		margin-bottom: 30px;
		opacity: 0.9;
		line-height: 1.6;
	}
	
	.banner-buttons {
		display: flex;
		gap: 20px;
		flex-wrap: wrap;
	}
	
	.btn-primary, .btn-secondary {
		padding: 15px 30px;
		border-radius: 30px;
		text-decoration: none;
		font-weight: 600;
		font-size: 16px;
		transition: all 0.3s ease;
		display: inline-block;
		text-align: center;
		min-width: 150px;
	}
	
	.btn-primary {
		background: #ff6b35;
		color: white;
		box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
	}
	
	.btn-primary:hover {
		background: #e55a2b;
		transform: translateY(-3px);
		box-shadow: 0 6px 20px rgba(255, 107, 53, 0.4);
	}
	
	.btn-secondary {
		background: transparent;
		color: white;
		border: 2px solid rgba(255, 255, 255, 0.8);
	}
	
	.btn-secondary:hover {
		background: rgba(255, 255, 255, 0.1);
		border-color: white;
		transform: translateY(-3px);
	}
	
	.banner-stats {
		display: flex;
		gap: 30px;
		margin-left: 40px;
	}
	
	.stat-item {
		text-align: center;
		padding: 20px;
		background: rgba(255, 255, 255, 0.1);
		border-radius: 15px;
		backdrop-filter: blur(10px);
		border: 1px solid rgba(255, 255, 255, 0.2);
		min-width: 100px;
	}
	
	.stat-item h3 {
		font-size: 2rem;
		font-weight: bold;
		margin-bottom: 5px;
		color: #ff6b35;
	}
	
	.stat-item p {
		font-size: 0.9rem;
		opacity: 0.8;
		margin: 0;
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
	
	.modal-content input[type="text"], .modal-content input[type="password"] {
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
	.dropdown {
    	position: relative;
    	display: inline-block;
	}
	
	.dropdown-content {
	    display: none;
	    position: absolute;
	    min-width: 160px;
	    box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
	    z-index: 1;
	    border-radius: 4px;
	}
	
	.dropdown-content a {
	    color: black;
	    padding: 10px 16px;
	    text-decoration: none;
	    display: block;
	}
	
	.dropdown-content a:hover {
	    background-color: #f1f1f1;
	}
	
	.dropdown:hover .dropdown-content {
	    display: block;
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
         <li data-category="반려동물">반려동물</li>
         <li data-category="게임/취미">게임/취미</li>
      </ul>
   </div>

   <!-- header -->
   <div id="header">
      <div id="header_1">
      	  <div id="header_1_center">
      	  	<a href="${contextRoot}" style="text-decoration: none; color: white; display: flex; align-items: center; gap: 2px; align-items: flex-end;">
	            <div class="title-icon">
	               <div class="jar-icon">
	                  <div class="jar-lid">
	                     <div class="jar-handle"></div>
	                  </div>
	                  <div class="jar-body">
	                     <div class="jar-inner"></div>
	                  </div>
	               </div>
	            </div>	            
      			<h1 class="floating">담금마켓</h1>
   		 	</a>
         </div>		   	
         <div id="header_1_right">
				<c:choose>
					<c:when test="${empty loginUser and empty loginAdmin}">
						<a href="${contextRoot}/insert.me">회원가입</a> 
						<a href="#" id="loginLink">로그인</a>
						<a href="#" id="adminLoginLink">관리자로그인</a>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${not empty loginUser}">
								<span>${loginUser.userName}님 환영합니다.</span>
								<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;내 담구기 포인트 : ${loginUser.userRank}</span>
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
					<li><a href="${contextRoot}/product/pd-view">내상품</a></li>
		         	<li><a href="${contextRoot}/user/FavoriteList">찜목록</a></li>
		         	<li class="dropdown">
			            <a href="javascript:void(0)">거래신청내역</a>
			            <div class="dropdown-content">
			                <a href="${contextRoot}/product/History-view?role=seller">판매자</a>
			                <a href="${contextRoot}/product/History-view?role=buyer">구매자</a>
			            </div>
			        </li>
		        </c:when>
	        </c:choose>
         </ul>
      </div>
   </div>
 
   <!-- 광고 영역 -->
	<section class="hero" id="home">
	   <div class="container">
	      <div class="banner-content">
	         <div class="banner-text">
	            <span class="banner-badge">🔥 HOT</span>
	            <h1>담금으로 시작해서<br><span class="highlight">담금으로 끝나는 중고거래</span></h1>
	            <p>합리적인 가격으로 담궈드립니다. 우리 동네 안전한 거래</p>
	         </div>
	         <div class="banner-stats">
	            <div class="stat-item">
	               <h3>8,000원</h3>
	               <p>100 포인트(20%할인)</p>
	            </div>
	            <div class="stat-item">
	               <h3>5,000원</h3>
	               <p>50 포인트</p>
	            </div>
	            <div class="stat-item">
	               <h3>95%</h3>
	               <p>거래 만족도</p>
	            </div>
	         </div>
	      </div>
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

   <!-- 수정: 사이드바 스마트 자동 닫힘 스크립트 -->
   <script>
      let sidebarTimer;
      let inputTimer;

 
      function toggleSidebar() {
          const sidebar = document.getElementById('sidebar');
          const hamburger = document.getElementById('hamburger');
          const searchInput = document.getElementById('categorySearch'); 
          
          sidebar.classList.toggle('open');

          if (sidebar.classList.contains('open')) {
              hamburger.classList.add('hide');
              clearTimeout(sidebarTimer);
              clearTimeout(inputTimer); // 
              

              function startSmartCloseTimer() {
                  sidebarTimer = setTimeout(() => {
                      if (document.activeElement !== searchInput && !searchInput.value.trim()) {
                          sidebar.classList.remove('open');
                          hamburger.classList.remove('hide');
                          cleanupSearchEvents();
                      } else {
                          startSmartCloseTimer();
                      }
                  }, 5000); 
              }
              

              function setupSearchEvents() {
                  searchInput.addEventListener('focus', function() {
                      clearTimeout(sidebarTimer);
                      clearTimeout(inputTimer);
                      this.classList.add('active-search');
                  });
                  
                  searchInput.addEventListener('blur', function() {
                      this.classList.remove('active-search');
                      if (!this.value.trim()) {
                          startSmartCloseTimer();
                      }
                  });
                  
                  searchInput.addEventListener('input', function() {
                      clearTimeout(sidebarTimer);
                      clearTimeout(inputTimer);
                      
                      inputTimer = setTimeout(() => {
                          if (document.activeElement !== searchInput) {
                              startSmartCloseTimer();
                          }
                      }, 3000);
                  });
                  
                  searchInput.addEventListener('keypress', function(e) {
                      if (e.key === 'Enter') {
                              sidebar.classList.remove('open');
                              hamburger.classList.remove('hide');
                              cleanupSearchEvents();                        
                      }
                  });
              }
              
              function cleanupSearchEvents() {
                  searchInput.classList.remove('active-search');
              }
              
              setupSearchEvents();
              startSmartCloseTimer();
              
          } else {
              hamburger.classList.remove('hide');
              clearTimeout(sidebarTimer);
              clearTimeout(inputTimer);
          }
      }
   </script>

   <!-- 통합된 DOM 로딩 완료 후 초기화 스크립트 -->
   <script>
   document.addEventListener('DOMContentLoaded', function() {
	    // 로그인 모달 초기화
	    initLoginModal();	    
	    // 관리자 모달 초기화
	    initAdminModal();	    
	    // 카테고리 이벤트 초기화
	    initCategoryEvents();
	});

	// 로그인 모달 관련 함수
	function initLoginModal() {
	    const loginLink = document.getElementById('loginLink');
	    const modal = document.getElementById('loginModal');
	    const closeBtn = document.getElementById('closeModal');
	    const cancelBtn = document.getElementById('cancelBtn');

	    if (loginLink && modal) {
	        loginLink.addEventListener('click', (e) => {
	            e.preventDefault();
	            modal.classList.add('show');
	        });
	    }

	    if (closeBtn && modal) {
	        closeBtn.addEventListener('click', () => modal.classList.remove('show'));
	    }

	    if (cancelBtn && modal) {
	        cancelBtn.addEventListener('click', () => modal.classList.remove('show'));
	    }

	    if (modal) {
	        modal.addEventListener('click', (e) => {
	            if (e.target === modal) {
	                modal.classList.remove('show');
	            }
	        });
	    }
	}

	// 관리자 모달 관련 함수
	function initAdminModal() {
	    const adminLoginLink = document.getElementById('adminLoginLink');
	    const adminModal = document.getElementById('adminLoginModal');
	    const closeAdminBtn = document.getElementById('closeAdminModal');
	    const cancelAdminBtn = document.getElementById('cancelAdminBtn');

	    if (adminLoginLink && adminModal) {
	        adminLoginLink.addEventListener('click', (e) => {
	            e.preventDefault();
	            adminModal.classList.add('show');
	        });
	    }

	    if (closeAdminBtn && adminModal) {
	        closeAdminBtn.addEventListener('click', () => adminModal.classList.remove('show'));
	    }

	    if (cancelAdminBtn && adminModal) {
	        cancelAdminBtn.addEventListener('click', () => adminModal.classList.remove('show'));
	    }

	    if (adminModal) {
	        adminModal.addEventListener('click', (e) => {
	            if (e.target === adminModal) {
	                adminModal.classList.remove('show');
	            }
	        });
	    }
	}

	function initCategoryEvents() {
	    const categoryItems = document.querySelectorAll('#categoryList li[data-category]');
	    
	    categoryItems.forEach(function(item) {
	        item.addEventListener('click', function() {
	            const category = this.getAttribute('data-category');
	            console.log('카테고리 선택:', category);
	            
	            const searchInput = document.getElementById('searchCategory');
	            if (searchInput) {
	                searchInput.value = category;
	            }
	            
	            const sidebar = document.getElementById('sidebar');
	            const hamburger = document.getElementById('hamburger');
	            if (sidebar) {
	                sidebar.classList.remove('open');
	            }
	            if (hamburger) {
	                hamburger.classList.remove('hide');
	            }
	            
	            clearTimeout(sidebarTimer);
	            clearTimeout(inputTimer);
	            
	            if (typeof window.startSearch === 'function') {
	                window.startSearch();
	            } else {
	                console.warn('startSearch 함수를 찾을 수 없습니다.');
	            }
	        });
	    });
	}
   </script>

</body>

</html>