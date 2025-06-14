<%@ page contentType="text/html;charset=UTF-8" %>
<div id="product-container"></div>
<div id="loading" style="display:none;">로딩 중...</div>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script type="text/javascript">
	const serverPath = '${pageContext.request.contextPath}';
</script>
<script>
	/*
		2025-06-02 장유진 생성 및 작성
	*/
	
    let offset = 0;
    const limit = 16;
    let status = '거래신청';
    let isLoading = false;
    let noMoreData = false;

    function startSearch() {
    	userNo = '${loginUser.userNo}';
        offset = 0;
        noMoreData = false;
        $("#product-container").empty();
        loadProducts();
    }

    function loadProducts() {
        if (isLoading || noMoreData) return;
        isLoading = true;
        $('#loading').show();

        $.ajax({
            url: serverPath + "/product/HistoryList",
            data: {
                offset: offset,
                limit: limit,
                userNo: userNo,
                status: status
            },
            success: function (products) {
                if (products.length === 0) {
                    if (offset === 0) {
                        $("#product-container").html("<p>검색 결과가 없습니다.</p>");
                    } else {
                        $("#loading").text("더 이상 상품이 없습니다.");
                    }
                    noMoreData = true;
                    isLoading = false;
                    $('#loading').hide();
                    return;
                }

                products.forEach(function (product) {
                    const $productDiv = $('<div>')
                        .addClass('product')
                        .attr('data-pdnum', product.pdNum)
                        .attr('data-userno', product.userNo);

                    // 상품 클릭 시 유저 정보 모달 표시
					$productDiv.on('click', function () {
					    const pdNum = $(this).data('pdnum');
					    const userNo = $(this).data('userno');
					
					    $.ajax({
					        url: serverPath + "/user/e-list",
					        data: {
					            userNo,
					            pdNum,
					            status,
					        },
					        success: function (userInfoList) {
					            if (!userInfoList || userInfoList.length === 0) {
					                alert("신청한 유저 정보가 없습니다.");
					                return;
					            }
					
					            // 이전 모달 제거
					            $('#geoModal').remove();
					
					            let userListHtml = '';
					
					            userInfoList.forEach((user, index) => {
					                let actionButtons = "";

					                if (status === "거래신청") {
					                	console.log(user.userNo);
					                  	console.log(product.pdNum);
					                    actionButtons = `
					                        <button style="
					                            padding: 10px 20px;
					                            border: none;
					                            background-color: #7a4fff;
					                            color: white;
					                            border-radius: 6px;
					                            font-size: 14px;
					                            cursor: pointer;
					                            transition: background-color 0.3s;
					                        " class="enableBtn" data-enrollNo="\${user.userNo}" data-pdNum="\${product.pdNum}" >
					                            거래승인
					                        </button>
					                    `;
					                } else if (status === "예약중") {
					                    actionButtons = `
					                        <button style="
					                            padding: 10px 20px;
					                            margin-right: 10px;
					                            border: none;
					                            background-color: #28a745;
					                            color: white;
					                            border-radius: 6px;
					                            font-size: 14px;
					                            cursor: pointer;
					                            transition: background-color 0.3s;
					                        " class="completeBtn" data-enrollNo="\${user.userNo}" data-pdNum="\${product.pdNum}">
					                            거래완료
					                        </button>
					                        <button style="
					                            padding: 10px 20px;
					                            border: none;
					                            background-color: #dc3545;
					                            color: white;
					                            border-radius: 6px;
					                            font-size: 14px;
					                            cursor: pointer;
					                            transition: background-color 0.3s;
					                        " class="cancelBtn" data-enrollNo="\${user.userNo}" data-pdNum="\${product.pdNum}">
					                            거래취소
					                        </button>
					                    `;
					                } else if (status === "판매완료") {
					                    actionButtons = `
					                        <button style="
					                            padding: 10px 20px;
					                            border: none;
					                            background-color: #6c757d;
					                            color: white;
					                            border-radius: 6px;
					                            font-size: 14px;
					                            cursor: not-allowed;
					                            opacity: 0.7;
					                        " disabled>
					                            판매완료
					                        </button>
					                    `;
					                }

					                userListHtml += `
					                    <div style="
					                        border: 1px solid #ddd;
					                        border-radius: 10px;
					                        margin-bottom: 16px;
					                        padding: 16px;
					                        background-color: #f9f9ff;
					                        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
					                    ">
					                        <!-- 상단 정보 -->
					                        <div style="
					                            display: flex;
					                            justify-content: space-between;
					                            align-items: center;
					                            flex-wrap: wrap;
					                            row-gap: 10px;
					                        ">
					                            <div>
					                                <p style="margin: 0 0 4px 0; font-size: 16px;"><strong>이름:</strong> \${user.userName}</p>
					                                <p style="margin: 0; font-size: 14px; color: #555;"><strong>이메일:</strong> \${user.email}</p>
					                            </div>
					                            <div>\${actionButtons}</div>
					                        </div>

					                        <hr style="margin: 15px 0; border: none; border-top: 1px solid #eee;">

					                        <!-- 주소 정보 -->
					                        <div style="
					                            display: flex;
					                            justify-content: space-between;
					                            align-items: center;
					                            flex-wrap: wrap;
					                            row-gap: 10px;
					                        ">
					                            <p class="parcel" style="margin: 0; font-size: 14px;"><strong>주소:</strong> </p>
					                            <button style="
					                                padding: 10px 20px;
					                                border: none;
					                                background-color: #7a4fff;
					                                color: white;
					                                border-radius: 6px;
					                                font-size: 14px;
					                                cursor: pointer;
					                                transition: background-color 0.3s;
					                            " class="geoBtn" data-lat="\${user.latitude}" data-lng="\${user.longitude}">
					                                주소보기
					                            </button>
					                        </div>
					                    </div>
					                `;
					            });

					
					            const $modal = $(`
					                <div id="geoModal" style="position:fixed; top:0; left:0; width:100%; height:100%;
					                     background:rgba(0,0,0,0.6); z-index:9999; display:flex; justify-content:center; align-items:center;">
					                    <div style="background:white; padding:20px; width:90%; max-width:600px; max-height:80%; overflow-y:auto; position:relative;">
						                    <div style="display: flex;justify-content: space-between;align-items: center;flex-wrap: wrap;row-gap: 10px;">
						                    	<h2 style="margin-top:10px;margin-left:10px;color: #7a4fff">신청자 목록</h2>
						                        <button style="margin-right:10px; padding:10px 20px; border:none; background-color:#7a4fff; color:#fff; border-radius:5px; cursor:pointer;"
						                            onclick="$('#geoModal').remove()">닫기</button>
					                        </div>
					                        \${userListHtml}
					                       
					                    </div>
					                </div>
					            `);
					
					            $('body').append($modal);
					        },
					        error: function () {
					            alert("사용자 정보 불러오기 실패");
					        }
					    });
					});


                    // 상품 이미지
                    if (product.pd_url != null) {
                        const $img = $('<img>').attr('src', product.pd_url)
                            .attr('alt', product.pdTitle + ' 이미지');
                        $productDiv.append($img);
                    }

                    // 상품 정보
                    const $infoDiv = $('<div>').addClass('info');
                    $infoDiv.append($('<h3>').text(product.pdTitle));
                    $infoDiv.append($('<p>').text(product.pdBoard));
                    $infoDiv.append($('<p>').text(`가격: \${product.pdPrice}원`));
                    $productDiv.append($infoDiv);
 
                    // 상세 보기 버튼
                    const $goDetailBtn = $('<button>')
                        .text('상세 보기')
                        .css({
                            'padding': '8px 16px',
                            'border': 'none',
                            'background-color': '#8b45ff',
                            'color': '#fff',
                            'border-radius': '5px',
                            'cursor': 'pointer'
                        })
                        .on('click', function (e) {
                            e.stopPropagation(); // 부모 div 클릭 방지
                            const pdNum = product.pdNum;
                            const userNo = product.userNo;
                            window.location.href = `/soak/product/view?pdNum=\${pdNum}&userNo=\${userNo}`;
                        });
                    $productDiv.append($goDetailBtn);

                    $('#product-container').append($productDiv);
                });

                offset += limit;
                isLoading = false;
                $("#loading").hide();
            },
            error: function () {
                alert("불러오기 실패");
                isLoading = false;
                $("#loading").hide();
            }
        });
    }

    $(window).scroll(function () {
        if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
            loadProducts();
        }
    });

    $(document).ready(function () {
        $('#statusFilter button').on('click', function () {
            $('#statusFilter button').removeClass('active');
            $(this).addClass('active');
            status = $(this).data('status');
            startSearch(); // 상태 변경 후 검색 다시 실행
        });

        startSearch();  // 처음 진입 시 전체 상품 로드
    });
    
    $(document).on('click', '.geoBtn', function () {
        const lat = $(this).data('lat');
        const lng = $(this).data('lng');
        const $parcel = $(this).siblings('.parcel'); // 같은 div 안의 parcel 요소 찾기

        $('#latitude').val(lat);
        $('#longitude').val(lng);

        $.ajax({
            url: serverPath + "/Gecoding",
            data: { longitude: lng, latitude: lat },
            success: function (result) {
                $parcel.text("주소: " + result.parcel);
            },
            error: function () {
                $parcel.text("주소를 가져오지 못했습니다. 다시 시도해주세요");
                alert("주소 정보를 가져오지 못했습니다.");
            }
        });
    });

    $(document).on('click', '.enableBtn', function () {
        const enrollNo = $(this).data('enrollno');
        const pdNum = $(this).data('pdnum');
        updateHistoryStatus(pdNum, userNo, '예약중', enrollNo)
    });
    $(document).on('click', '.completeBtn', function () {
        const enrollNo = $(this).data('enrollno');
        const pdNum = $(this).data('pdnum');
        updateHistoryStatus(pdNum, userNo, '판매완료', enrollNo)
    });
    $(document).on('click', '.cancelBtn', function () {
        const enrollNo = $(this).data('enrollno');
        const pdNum = $(this).data('pdnum');
        updateHistoryStatus(pdNum, userNo, '거래신청', enrollNo)
    });

    function updateHistoryStatus(pdNum, userNo, status, enrollNo = null) {
        $.ajax({
            url: serverPath +'/product/History-update',
            method: 'POST',
            data: {
                pdNum: pdNum,
                userNo: userNo,
                status: status,
                enrollNo: enrollNo // null이면 자동으로 빠짐
            },
            success: function(result) {
                if (result > 0) {
                    alert("상태가 성공적으로 업데이트되었습니다.");
                    // 필요 시 화면 갱신
                    location.reload();
                } else {
                    alert("상태 업데이트 실패 또는 변경사항 없음.");
                }
            },
            error: function(xhr, status, error) {
                console.error("❌ 상태 변경 실패:", error);
            }
        });
    }

</script>

<style>
	#product-container {
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	}
	.product {
	    border: 1px solid #ccc;
	    padding: 20px;
	    margin: 10px 0;
	    width: 90%;
	    max-width: 900px;
	    display: flex;
	    flex-direction: row;
	    align-items: center;
	    gap: 20px;
	    background-color: #fff !important;
	    border-radius: 10px;
	    box-shadow: 0 4px 8px rgba(139, 69, 255, 0.1);
	    cursor: pointer;
	}
	
	.product img {
	    width: 200px;
	    height: 200px;
	    object-fit: cover;
	    border-radius: 10px;
	}
	
	.product .info {
	    flex: 1;
	    text-align: left;
	}
	
	#button {
		padding: 10px 20px;
		border-radius: 25px;
		background-color: #eee;
		border: none;
		font-weight: bold;
		cursor: pointer;
		transition: background-color 0.3s;
	}
</style>
