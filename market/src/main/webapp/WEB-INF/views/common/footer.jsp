<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
   <title>Document</title>
   <style>
      footer {
         background: #333;
         color: white;
         padding: 3rem 0 1rem;
         margin-top: 4rem;
      }

      .footer-content {
         display: grid;
         grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
         gap: 2rem;
         margin-bottom: 2rem;
      }

      .footer-section h3 {
         margin-bottom: 1rem;
         color: #b45aff;
      }

      .footer-section ul {
         list-style: none;
      }

      .footer-section ul li {
         margin-bottom: 0.5rem;
      }

      .footer-section ul li a {
         color: #ccc;
         text-decoration: none;
         transition: color 0.3s ease;
      }

      .footer-section ul li a:hover {
         color: #b45aff;
      }

      .footer-bottom {
         text-align: center;
         padding-top: 2rem;
         border-top: 1px solid #555;
         color: #999;
      }

      .footer-logo {
         width: 120px;
         /* 또는 원하는 크기 */
         margin: 0.5rem 0;
         display: block;
      }

      .social-icons {
         margin-top: 1rem;
      }

      .social-icons a {
         color: #ccc;
         font-size: 1.5rem;
         margin-right: 1rem;
         transition: color 0.3s ease;
      }

      .social-icons a:hover {
         color: #b45aff;
      }
   </style>
</head>

<body>
   <!-- Footer -->
   <footer>
      <div class="container">
         <div class="footer-content">
            <div class="footer-section">
               <h3>담금마켓</h3>

               <!-- SNS 아이콘 -->
               <div class="social-icons">
                  <a href="https://www.facebook.com/daangn" target="_blank" aria-label="Facebook">
                     <i class="fab fa-facebook-square"></i>
                  </a>
                  <a href="https://www.instagram.com/daangnmarket/" target="_blank" aria-label="Instagram">
                     <i class="fab fa-instagram"></i>
                  </a>
               </div>
            </div>
            <div class="footer-section">
               <h3>서비스</h3>
               <ul>
                  <li><a href="#">판매자인증</a></li>
                   <li><a href="#">광고문의</a></li>
               </ul>
            </div>
            <div class="footer-section">
               <h3>고객지원</h3>
               <ul>
                  <li><a href="#">FAQ</a></li>
                  
                  <!-- 공지사항 링크 -->
                  <c:choose>
                     <c:when test="${not empty loginAdmin}">
                        <!-- 관리자 로그인시 - 관리 기능 포함 -->
                        <li>
                           <a href="${contextRoot}/board/list.bo">공지사항 조회</a>
                           <span class="divider">|</span>
                           <a href="${contextRoot}/board/enrollForm.bo" class="admin-menu">작성</a>
                        </li>
                     </c:when>
                     <c:otherwise>
                        <!-- 일반 유저 또는 비로그인시 - 조회만 -->
                        <li><a href="${contextRoot}/board/list.bo">공지사항</a></li>
                     </c:otherwise>
                  </c:choose>
                  
                  <!-- 문의사항 링크 -->
                  <c:choose>
                     <c:when test="${not empty loginAdmin}">
                        <!-- 관리자 로그인시 - 관리 기능 포함 -->
                        <li>
                           <a href="${contextRoot}/userqna/list.uq">문의사항 관리</a>
                           <span class="divider">|</span>
                           <a href="${contextRoot}/answer/list.an" class="admin-menu">답변 관리</a>
                        </li>
                     </c:when>
                     <c:when test="${not empty loginUser}">
                        <!-- 일반 유저 로그인시 -->
                        <li>
                           <a href="${contextRoot}/userqna/list.uq">문의사항</a>
                           <span class="divider">|</span>
                           <a href="${contextRoot}/userqna/enrollForm.uq">문의하기</a>
                        </li>
                     </c:when>
                     <c:otherwise>
                        <!-- 비로그인시 -->
                        <li><a href="${contextRoot}/userqna/list.uq">문의사항</a></li>
                     </c:otherwise>
                  </c:choose>
                  
                  <li><a href="#">신고하기</a></li>
               </ul>
            </div>
            <div class="footer-section">
               <h3>정보</h3>
               <ul> 
                  <li><a href="">팀소개</a></li>
                  <li><a href="">이용약관</a></li>
                  <li><a href="">개인정보처리방침</a></li>
                  
                  <!-- 관리자 전용 메뉴 -->
                  <c:if test="${not empty loginAdmin}">
                     <li><a href="${contextRoot}/admin/main.ad" class="admin-menu">관리자 메인</a></li>
                     <li><a href="${contextRoot}/admin/insert.ad" class="admin-menu">관리자 등록</a></li>
                  </c:if>
               </ul>
            </div>
         </div>
         <div class="footer-bottom">
            <p>&copy; 2025 DamgeumMarket. All rights reserved.</p>
            <c:if test="${not empty loginAdmin}">
               <p style="color: #ff6b35; font-size: 12px; margin-top: 5px;">
                  <i class="fas fa-user-shield"></i> 관리자 모드로 접속중
               </p>
            </c:if>
         </div>
      </div>
   </footer>
</body>
</html>