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
                  <li><a href="#">중고거래</a></li>
                  <li><a href="#">배송서비스</a></li>
                  <li><a href="#">판매자인증</a></li>
                   <li><a href="#">광고문의</a></li>
               </ul>
            </div>
            <div class="footer-section">
               <h3>고객지원</h3>
               <ul>
                  <li><a href="#">FAQ</a></li>
                  <li><a href="#">공지사항</a></li>
                  <li><a href="#">문의사항</a></li>
                  <li><a href="#">신고하기</a></li>
               </ul>
            </div>
            <div class="footer-section">
               <h3>정보</h3>
               <ul> 
                  <li><a href="">팀소개</a></li>
                  <li><a href="">이용약관</a></li>
                  <li><a href="">개인정보처리방침</a></li>
               </ul>
            </div>
         </div>
         <div class="footer-bottom">
            <p>&copy; 2025 DamgeumMarket. All rights reserved.</p>
         </div>
      </div>
   </footer>
</body>
</html>