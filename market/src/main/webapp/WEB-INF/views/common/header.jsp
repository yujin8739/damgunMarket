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

      body {
         font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
         line-height: 1.6;
         color: #333;
         background: linear-gradient(135deg, #f8f6ff 0%, #ede7ff 100%);
         padding-top: 80px;
      }

      .container {
         max-width: 1200px;
         margin: 0 auto;
         padding: 0 20px;
      }

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

   <!-- 사이드바 -->
   <div class="sidebar" id="sidebar">
      <h3>카테고리</h3>
      <ul>
         <li>전자기기</li>
         <li>의류</li>
         <li>가구</li>
         <li>도서</li>
         <li>운동용품</li>
         <li>기타</li>
      </ul>
   </div>

   <!-- header -->
   <header>
      <div class="container">
         <nav>
            <button class="hamburger" onclick="toggleSidebar()">
               <img src="images/hamburger-icon.png" alt="메뉴" />
            </button>
            <div class="logo">담금마켓</div>
            <ul class="nav-links">
               <li><a href="#home">홈</a></li>
               <li><a href="#category">카테고리</a></li>
               <li><a href="#">해야됨</a></li>
               <li><a href="#">하하..</a></li>
            </ul>
            <div class="nav-buttons">
               <a href="#" class="btn btn-login">로그인</a>
               <a href="#" class="btn btn-join">회원가입</a>
               <a href="#" class="btn btn-chat">담금톡</a>
            </div>

         </nav>
      </div>
   </header>

   <!-- Hero Section -->
   <section class="hero" id="home">
      <div class="container">
         <h1 class="floating">담금마켓</h1>
         <p>묻고 따지지 말고 그냥 담금마켓 하세요. 후회하지 않습니다.</p>
      </div>
   </section>

   <!-- 사이드바 토글 스크립트 --> 
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
</body>

</html>