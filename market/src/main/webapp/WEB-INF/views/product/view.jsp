<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
    <title>상품 상세 정보</title>
    <style>
        .product-detail {
        	font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
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
		.station-section {
		    background-color: #f9f5ff;
		    padding: 20px;
		    border-radius: 15px;
		    box-shadow: 0 4px 12px rgba(106, 13, 173, 0.1);
		    margin: 0 auto;
		}
		
		.station-label {
		    display: block;
		    margin-bottom: 15px;
		    font-size: 1.4rem;
		    color: #6a0dad;
		    font-weight: 600;
		    text-align: center;
		    border-bottom: 2px solid #d8bfff;
		    padding-bottom: 10px;
		}
		
		.station-list {
		    display: flex;
		    flex-direction: column;
		    gap: 12px;
		}
		
		.station-item {
		    background-color: #fff;
		    padding: 10px 15px;
		    border-radius: 12px;
		    border: 1px solid #ddd;
		    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
		    display: flex;
		    align-items: center;
		    justify-content: space-between;
		    font-size: 1rem;
		    color: #333;
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
		
		<div id="json-data" data-json='${fileListJson}' style="display:inline-block; ;"></div>
	    <div class="product-info">
	        <p><strong>가격:</strong> ${product.pdPrice} 원</p>
	        <p><strong>설명:</strong> ${product.pdBoard}</p>
	        <!-- <p><strong>위치:</strong> 위도 ${product.latitude}, 경도 ${product.longitude}</p> -->
	        <!--<p><strong>랭크:</strong> ${product.pdRank}</p>-->
	        <%-- <p><strong>상태:</strong> ${product.pdStatus == 1 ? "판매중" : "판매완료"}</p> --%>
		    <div id="stationSelectionWrapper" style="display: none; margin-top: 20px;">
		    <br><br>
			<div class="station-section">
			    <label class="station-label">거래 가능역</label>
			    <div id="stationList" class="station-list">
			        <!-- 역 정보가 여기에 들어갑니다 -->
			    </div>
			</div>
	    </div>
	    
	    <c:if test="${sessionScope.loginUser.userNo == product.userNo && enrollStatus != '판매완료'}">
	        <div style="margin-top: 20px; text-align: right;">
				<div id="editBtnBox" style="display: flex; gap: 10px; text-align: right;justify-content: flex-end;">
				    <form action="${pageContext.request.contextPath}/product/delete" method="post"
				          onsubmit="return confirm('정말 삭제하시겠습니까?');" style="margin: 0;">
				        <input type="hidden" name="pdNum" value="${product.pdNum}" />
				        <input type="hidden" name="userNo" value="${sessionScope.loginUser.userNo}" />
				        <button id="deleteBtn"  type="submit" style="background-color: #ff5c5c; color: white; border: none; padding: 10px 16px; border-radius: 6px;">
				            삭제
				        </button>
				    </form>
				    <form action="${pageContext.request.contextPath}/product/pdedit" method="get"
				          onsubmit="return confirm('정말 수정하시겠습니까?');" style="margin: 0;">
				        <input type="hidden" name="pdNum" value="${product.pdNum}" />
				        <input type="hidden" name="userNo" value="${product.userNo}" />
				        <button id="editBtn" type="submit" style="background-color: green; color: white; border: none; padding: 10px 16px; border-radius: 6px;">
				            수정
				        </button>
				    </form>
				</div>

	        </div>
	    </c:if>
	    
	    <c:if test="${sessionScope.loginUser.userNo != product.userNo}">
	        <div style="margin-top: 20px; text-align: right;">
	        	<input type="hidden" name="pdNum" value="${product.pdNum}" />
	            <input type="hidden" name="userNo" value="${product.userNo}" />
	            <input type="hidden" name="enrollNo" value="${sessionScope.loginUser.userNo}" />
	            <input type="hidden" name="userNo" value="${product.userNo}" />         <input type="hidden" name="enrollNo" value="${sessionScope.loginUser.userNo}" /> <button id="chatButton" type="button" 
                onclick="startChatWithSeller(${product.userNo}, ${sessionScope.loginUser.userNo})"  style="cursor: pointer; background-color: black; color: white; border: none; padding: 10px 16px; border-radius: 6px;">
           			채팅하기
        		</button>
	            <button id="tradeButton" type="button"  onclick="doEnrollProcess(${product.pdNum}, ${product.userNo},${sessionScope.loginUser.userNo},'거래신청')"  style="display: none; cursor: pointer; background-color: green; color: white; border: none; padding: 10px 16px; border-radius: 6px;">
					거래신청
	            </button>
	            <button id="enrollEndButton" type="button"  onclick="doEnrollProcess(${product.pdNum}, ${product.userNo},${sessionScope.loginUser.userNo},'거래신청')"  style="display: none; cursor: pointer; background-color: gray; color: white; border: none; padding: 10px 16px; border-radius: 6px;">
					신청완료
	            </button>
	        </div>
	    </c:if>
	  </div>
	</div>
	<br><br>
	

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
	    const serverPath = '${pageContext.request.contextPath}';
	</script>
	<script>
	
	 function checkStation() {
	        if (navigator.geolocation) {
	            navigator.geolocation.getCurrentPosition(function(position) {
	    			let userNo = '${product.userNo}';
	   				let pdNum = '${product.pdNum}';
	                $.ajax({
		                url: serverPath+'/product/get-station',
		                data: { 
		                	pdNum: pdNum,
		 	                userNo: userNo
		                },
		                success: function(station) {
		                    //console.log('데이터:', data);
		                    $('#stationList').empty();
	
		                    if (!Array.isArray(station) || station.length === 0) {
		                        $('#stationList').append('<p>조회된 역이 없습니다.</p>');
		                        return;
		                    }
	
		                    $.each(station, function(index, station) {
		                        $('#stationList').append(
		                            '<label class="station-item">' +
		                            '<p type="text" name="station" value="' + station.stationNum + '" min="1"> ' +
		                            station.stationName + ' (' + station.lineName + ')' +
		                            '</label>'
		                        );
		                    });
	
		                    $('#stationList').prop('disabled', false);
		                    $('#stationSelectionWrapper').show();  // 또는
		                },
		                error: function() {
		                	alert('상품의 거래가능역 정보를 가져올 수 없습니다. 브라우저 설정을 확인해주세요.');
		                }
		            });
	                $('#locationInfo').show();
	            }, function(error) {
	                alert('상품의 거래가능역 정보를 가져올 수 없습니다. 브라우저 설정을 확인해주세요.');
	            });
	        } else {
	        	alert('상품의 거래가능역 정보를 가져올 수 없습니다. 브라우저 설정을 확인해주세요.');
	        }
	    }
	
		function selectFavorite(){
			const star = document.getElementById("favoriteStar");
			let userNo = '${loginUser.userNo}';
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
						if (loginUserNo) {
							$('#enrollEndButton').show()
						}
						$('#enrollStatus').text('판매중');
					} else if (status !== '예약중' && status !== '판매완료') {
	                	$('#enrollStatus').text(status);
						if (loginUserNo) {
							$('#tradeButton').show();
							$('#enrollEndButton').hide()
						}
					} else {
	                    $('#enrollStatus').text(status);
						if (loginUserNo) {
							$('#tradeButton').show();
							$('#enrollEndButton').hide()
						}
					}
	    		    
	    		    if (status === '판매완료') {
	    		    	$('#editBtn').hide();
	    		    	$('#deleteBtn').hide()
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
		    	// 로그인한 사용자가 없을때
		    	$('#chatButton').hide()
		    	doEnrollProcess(pdNum, sellerNo, null, null);
			}
		    checkStation();
		    
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

		    // 담구기 버튼 클릭 이벤트 핸들러
		    $('#dampgugiButton').on('click', function() {
		        const points = parseInt($('#dampgugiPoints').val());
		        const currentUserNo = ${sessionScope.loginUser.userNo};
		        const productSellerNo = ${product.userNo};
		        const pdNum = ${product.pdNum};

		        if (!currentUserNo || currentUserNo === 'null') {
		            alert('로그인 후 이용해주세요.');
		            return;
		        }

		        if (currentUserNo === productSellerNo) {
		            alert('자신의 상품에는 포인트를 담글 수 없습니다.');
		            return;
		        }

		        if (isNaN(points) || points <= 0) {
		            alert('유효한 포인트를 입력해주세요 (1 이상의 숫자).');
		            return;
		        }

		        $.ajax({
		            url: serverPath + '/product/dampgugi',
		            type: 'POST',
		            data: {
		                pdNum: pdNum,
		                senderUserNo: currentUserNo,
		                receiverUserNo: productSellerNo,
		                points: points
		            },
		            success: function(response) {
		                if (response.status === 'success') {
		                    alert(points + '포인트를 상품에 담구었습니다!\n현재 상품 랭크: ' + response.updatedProductRank);
		                    $('#productRankDisplay').text(response.updatedProductRank);
		                } else {
		                    alert(response.message);
		                }
		            },
		            error: function() {
		                alert('포인트 담구기 중 오류가 발생했습니다.');
		            }
		        });
		    });

		</script>
	<script>
    function startChatWithSeller(productSellerNo, loginUserNo) {
        // ChatController의 새로운 엔드포인트로 이동
        // userNo를 쿼리 파라미터로 전달 -채팅하기로 바로이동할 수 있는 스크립트.
        location.href = '${pageContext.request.contextPath}/chat/startChat?productSellerNo=' + productSellerNo + '&loginUserNo=' + loginUserNo;
    }
  </script>
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
</body>
</html>

