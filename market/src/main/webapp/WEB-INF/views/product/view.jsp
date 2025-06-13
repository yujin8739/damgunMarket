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
		    max-width: 800px;
		    margin: 0 auto 20px auto;
		    padding: 0 30px; /* .product-detail과 같은 좌우 패딩 */
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
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<p id="category"><strong>카테고리:</strong> ${product.bigCate} > ${product.midCate} > ${product.smallCate}</p>
	<div class="product-detail">
	    <p id="enrollStatus" style="cursor: pointer; color: green; font-size: 16px;"></p>
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
	    <div class="product-info">
	        <p><strong>가격:</strong> ${product.pdPrice} 원</p>
	        <p><strong>설명:</strong> ${product.pdBoard}</p>
	        <!-- <p><strong>위치:</strong> 위도 ${product.latitude}, 경도 ${product.longitude}</p> -->
	        <!--<p><strong>랭크:</strong> ${product.pdRank}</p>-->
	        <p><strong>상태:</strong> ${product.pdStatus == 1 ? "판매중" : "판매완료"}</p>
	    </div>
	    
	    <c:if test="${sessionScope.loginUser.userNo == product.userNo}">
	        <div style="margin-top: 20px; text-align: right;">
	            <form action="${pageContext.request.contextPath}/product/delete" method="post"
	                  onsubmit="return confirm('정말 삭제하시겠습니까?');">
	                <input type="hidden" name="pdNum" value="${product.pdNum}" />
	                <input type="hidden" name="userNo" value="${sessionScope.loginUser.userNo}" />
	                <button type="submit" style="background-color: #ff5c5c; color: white; border: none; padding: 10px 16px; border-radius: 6px;">
	                    삭제
	                </button>
	            </form>
	        </div>
	    </c:if>
	    
	    <c:if test="${sessionScope.loginUser.userNo != product.userNo}">
	        <div style="margin-top: 20px; text-align: right;">
	        	<input type="hidden" name="pdNum" value="${product.pdNum}" />
	            <input type="hidden" name="userNo" value="${product.userNo}" />
	            <input type="hidden" name="enrollNo" value="${sessionScope.loginUser.userNo}" />
	            <button type="button" onclick=" location.href='${pageContext.request.contextPath}/chat/roomList'" style="cursor: pointer; background-color: black; color: white; border: none; padding: 10px 16px; border-radius: 6px;">
					채팅하기
	            </button>
	            <button id="tradeButton" type="button"  onclick="doEnrollProcess(${product.pdNum}, ${product.userNo},${sessionScope.loginUser.userNo},'거래신청')"  style="display: none; cursor: pointer; background-color: green; color: white; border: none; padding: 10px 16px; border-radius: 6px;">
					거래신청
	            </button>
	        </div>
	    </c:if>
	    
	</div>
	<br><br>
	<div class="product-detail">
	</div>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
	    const serverPath = '${pageContext.request.contextPath}';
	</script>
	<script>
	
		function selectFavorite(){
			const star = document.getElementById("favoriteStar");
			let userNo = '${loginUser.userNo}';
			 console.log("확인용")
			let pdNum = '${product.pdNum}';
			$.ajax({
                url: serverPath+"/user/selectFavorite",
                data: {
                    userNo : userNo,
                    pdNum : pdNum
                },
                success: function (fCount) {
     	            star.textContent = fCount>0 ? "★" : "☆";
                },
                error: function (){
                	 alert("저장 실패");
                }
        	});
		}
		
    	function doEnrollProcess(pdNum, userNo, enrollNo, status){
    		//거래신청
			$.ajax({
	            url: serverPath+"/product/trade-enroll",
				data: {
	                pdNum: pdNum,
	                userNo: userNo,
	                enrollNo: enrollNo,
	                status: status
	            },
				success: function (status) {
	                let loginUserNo = '${loginUser.userNo}';
	                if(status === '거래신청') {
	                	if($('#enrollStatus').text() === '판매중'){
							alert("거래 신청이 완료 되었습니다.");
	                	}
						$('#tradeButton').hide()
						$('#enrollStatus').text('판매중');
					} else if (status !== '예약중' && status !== '판매완료') {
	                	$('#enrollStatus').text(status);
						if (loginUserNo) {
							$('#tradeButton').show();
						}
					} else {
	                    $('#enrollStatus').text(status);
						if (loginUserNo) {
							$('#tradeButton').show();
						}
					}
				},
				error: function () {
					alert("거래 시도에 실패했습니다.");
				}
			});
    	}
	
		document.addEventListener("DOMContentLoaded", function() {
		    const userNo = '${sessionScope.loginUser.userNo}'; // JSP 변수 값을 문자열로 삽입
		    const pdNum = ${product.pdNum};
		    const sellerNo = ${product.userNo};

		    if (userNo && userNo !== 'null') {
		        // 로그인한 사용자가 있을 때
		    	selectFavorite();
		    	doEnrollProcess(pdNum, sellerNo, userNo, null);
		    } else{
		    	// 거래상태확인
		    	doEnrollProcess(pdNum, sellerNo, null, null);
			}
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
	        star.addEventListener("click", function () {
	        	let isFavorite = star.textContent === "★";
	        	let userNo = '${loginUser.userNo}';
	        	let pdNum = '${product.pdNum}';
	        	isFavorite = !isFavorite;
	        	if(isFavorite){
		            $.ajax({
		                url: serverPath+"/user/saveFavorite",
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
			                url: serverPath+"/user/deleteFavorite",
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
</body>
</html>
