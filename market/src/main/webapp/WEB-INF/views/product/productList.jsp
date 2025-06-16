<%@ page contentType="text/html;charset=UTF-8" %>
<div id="product-container"></div>
<div id="loading" style="display:none;">로딩 중...</div>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script>
	/*
		2025-06-02 장유진 생성 및 작성
		2025-06-15 수정: 위도/경도 값 없을 경우 현재 위치 자동 설정
	*/

    let offset = 0;
    const limit = 16;
    let keyword = '';
    let category = '';
    let latitude = 0.00; 
    let longitude = 0.00;
    let isLoading = false;
    let noMoreData = false;

    function startSearch() {
        category = $("#searchCategory").val();
        keyword = $("#searchKeyword").val();

        latitude = $("#latitude").val();
        longitude = $("#longitude").val();

        // 위도, 경도 값이 비어있거나 0일 경우 현재 위치 자동 설정
        if (!latitude || !longitude || latitude == 0 || longitude == 0) {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    latitude = position.coords.latitude;
                    longitude = position.coords.longitude;

                    // 히든 input에도 넣어줌 (혹시 다른 곳에서 쓸 수도 있으니)
                    $("#latitude").val(latitude);
                    $("#longitude").val(longitude);

                    offset = 0;
                    noMoreData = false;
                    $("#product-container").empty();
                    loadProducts();
                }, function (error) {
                    alert("위치 정보를 가져올 수 없습니다.");
                    console.warn(error);
                    // 위치 못 가져왔을 경우에도 검색은 실행
                    offset = 0;
                    noMoreData = false;
                    $("#product-container").empty();
                    loadProducts();
                });
                return; // 위치 설정 후 검색 실행할 것이므로 여기서 종료
            } else {
                alert("브라우저에서 위치 정보를 지원하지 않습니다.");
            }
        }

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
            url: "product/load",
            data: {
                offset: offset,
                limit: limit,
                keyword: keyword,
                category: category,
                latitude: latitude,
                longitude: longitude
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
                    return;
                }

                products.forEach(function (product) {
                    const $productDiv = $('<div>')
                        .addClass('product')
                        .attr('data-pdnum', product.pdNum)
                        .attr('data-userno', product.userNo);
                    console.log(product.pdNum, product.userNo)

                    $productDiv.on('click', function () {
                        const pdNum = $(this).data('pdnum');
                        const userNo = $(this).data('userno');
                        window.location.href = `/soak/product/view?pdNum=\${pdNum}&userNo=\${userNo}`;
                    });

                    $('<h4>').text(product.pdTitle).appendTo(\$productDiv);

                    if (product.pd_url != null) {
                        const $imgWrapper = $('<div>').css({
                            width: '300px',
                            height: '300px',
                            overflow: 'hidden',
                            display: 'flex',
                            justifyContent: 'center',
                            alignItems: 'center',
                            margin: '0 auto'
                        });

                        const $img = $('<img>').attr('src', product.pd_url)
                            .attr('alt', product.pdTitle + ' 이미지')
                            .css({ maxHeight: '100%', maxWidth: '100%' });
                        $imgWrapper.append($img);
                        $productDiv.append($imgWrapper);
                    }

                    $('<p>').text(product.pdBoard).appendTo($productDiv);
                    $('<p>').text(`가격: \${product.pdPrice}원`).appendTo($productDiv);

                    $('#product-container').append($productDiv);
                });
                
                offset += limit;
                isLoading = false;
                $("#loading").hide();
            },
            error: function () {
                alert("불러오기 실패(로그인 후 사용해주세요)");
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
        startSearch();  // 처음 진입 시 전체 상품 로드
    });
</script>


<style>
    .product {
        border: 1px solid #ccc;
        padding: 10px;
        margin: 10px;
        display: inline-block;
        height: 500px;
        width: 400px;
        vertical-align: top;
        border-radius: 8px;
        color: black !important;
  		background-color: #fff !important;
    }
    #product-container {
        text-align: center;
    }
</style>
