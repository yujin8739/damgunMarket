<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
    <title>상품 상세 정보</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }
        .product-detail {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .product-detail h1 {
            font-size: 28px;
            margin-bottom: 20px;
        }
        .product-detail img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
        }
        .product-info {
            margin-top: 20px;
        }
        .product-info p {
            margin: 10px 0;
        }
        .product-info strong {
            display: inline-block;
            width: 120px;
        }
		#updateTime {
		    font-size: 12px;  
		    color: #888888;  
		}
		#category {
		}
		.image-scroll-wrapper {
			overflow-x: auto;
			white-space: nowrap;
			padding: 10px 0;
		}
		.image-scroll-wrapper img {
			display: inline-block;
			margin-right: 10px;
			max-height: 700px;
		}
	</style>
</head>
<body>
<p id="category"><strong>카테고리:</strong> ${product.bigCate} > ${product.midCate} > ${product.smallCate}</p>
<div class="product-detail">
    <p>
    <h1 style="display: flex; justify-content: space-between; align-items: center;">
    	${product.pdTitle}
    	<span id="favoriteStar" style="cursor: pointer; color: gold; font-size: 24px;">☆</span>
	</h1>
    
	<p id="updateTime"><strong>업데이트:</strong> ${product.updateTime}</p>
	<c:if test="${not empty fileListJson}">
	    <div class="image-scroll-wrapper">
	        <div id="imageContainer"></div>
	    </div>
	</c:if>
	
	<div id="json-data" data-json='${fileListJson}' style="display:none;"></div>
	
	<script>
		document.addEventListener("DOMContentLoaded", function() {
	        // 기존 이미지 로딩 스크립트
	        const imageContainer = document.getElementById("imageContainer");
	        const jsonData = document.getElementById("json-data").dataset.json;
	        const fileList = JSON.parse(jsonData);
	        console.log("fileList:", fileList);

	        fileList.forEach(url => {
	            const img = document.createElement("img");
	            img.src = url;
	            img.alt = "상품 이미지";
	            img.style.margin = "5px";
	            img.style.maxWidth = "700px";
	            imageContainer.appendChild(img);
	        });

	        // 즐겨찾기 별 클릭 처리
	        const star = document.getElementById("favoriteStar");
	        let isFavorite = false;
	        star.addEventListener("click", function () {
	        	let userNo = 0;
	        	let pdNum = product.pdNum;
	        	isFavorite = !isFavorite;
	        	if(favorite){
		            $.ajax({
		                url: "user/seveFavorite",
		                data: {
		                    userNo : userNo,
		                    pdNum : pdNum
		                },
		                success: function (favorite) {
		     	            star.textContent = isFavorite ? "★" : "☆";
		                },
		                error: function (){
		                	 alert("저장 실패");
		                }
		        	});
	        	} else {
	        		 $.ajax({
			                url: "user/Favorite",
			                data: {
			                    userNo : userNo,
			                    pdNum : pdNum
			                },
			                success: function (favorite) {
			     	            star.textContent = isFavorite ? "★" : "☆";
			                },
			                error: function (){
			                	 alert("저장 실패");
			                }
			        	});
	        	}
	        });
	    });

	</script>
	

    <div class="product-info">
        <p><strong>가격:</strong> ${product.pdPrice} 원</p>
        <p><strong>설명:</strong> ${product.pdBoard}</p>
        <!-- <p><strong>위치:</strong> 위도 ${product.latitude}, 경도 ${product.longitude}</p> -->
        <!--<p><strong>랭크:</strong> ${product.pdRank}</p>-->
        <p><strong>상태:</strong> ${product.pdStatus == 1 ? "판매중" : "판매완료"}</p>
    </div>
</div>
</body>
</html>
