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
    let keyword = 0;
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
            url: serverPath + "/product/myPdList",
            data: {
                offset: offset,
                limit: limit,
                userNo: userNo
            },
            success: function (products) {
                if (products.length === 0) {
                    if (offset === 0) {
                        $("#product-container").html("<p>검색 결과가 없습니다.</p>");
                    } else {
                        $("#loading").text("더 이상 상품이 없습니다.");
                    }
                    noMoreData = true;
                    return;
                }

                products.forEach(function (product) {
                    const $productDiv = $('<div>')
                        .addClass('product')
                        .attr('data-pdnum', product.pdNum)
                        .attr('data-userno', product.userNo);

                    $productDiv.on('click', function () {
                        const pdNum = $(this).data('pdnum');
                        const userNo = $(this).data('userno');
                        console.log("clicked pdNum:", pdNum, "userNo:", userNo);
                        window.location.href = `/soak/product/view?pdNum=\${pdNum}&userNo=\${userNo}`;
                    });

                    $('<h4>').text(product.pdTitle).appendTo($productDiv);
                    
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
