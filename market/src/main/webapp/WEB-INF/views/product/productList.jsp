<%@ page contentType="text/html;charset=UTF-8" %>
<!--
	상품을 올린 사용자가 상품을 삭제할 수 있게  
	로그인 사용자 번호를 JS에 전달 
-->
<%
    int sessionUserNo = (session.getAttribute("userNo") != null) ? (int) session.getAttribute("userNo") : -1;
%>
<script>
    const sessionUserNo = <%= sessionUserNo %>; // JS에서 로그인한 사용자 번호 확인용
</script>

<div id="product-container"></div>
<div id="loading" style="display:none;">로딩 중...</div>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script>
	/*
		2025-06-02 장유진 생성 및 작성
	*/
	
    let offset = 0;
    const limit = 16;
    let keyword = '';
    let isLoading = false;
    let noMoreData = false;

    function startSearch() {
        keyword = $("#searchKeyword").val();
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
                keyword: keyword
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
                    
                    
                    // 상품 삭제버튼, 로그인한 사용자가 본인 상품일 때만 표시 // 김진우작성
                    if (product.userNo === sessionUserNo) {
                        const $deleteBtn = $('<button>')
                            .text('삭제')
                            .addClass('btn btn-danger btn-sm')
                            .css({ marginTop: '10px' })
                            .on('click', function (e) {
                                e.stopPropagation(); // 상품 div 클릭 이벤트 막음
                                if (!confirm('정말 삭제하시겠습니까?')) return;

                                $.ajax({
                                    type: 'POST',
                                    url: '/soak/product/delete',
                                    data: { pdNum: product.pdNum, userNo: sessionUserNo },
                                    success: function (res) {
                                        alert('삭제되었습니다.');
                                        $productDiv.remove(); // 화면에서 해당 상품 제거
                                    },
                                    error: function () {
                                        alert('삭제 실패');
                                    }
                                });
                            });

                        $productDiv.append($deleteBtn);
                    }

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
    
    <!-- 삭제버튼 css -->
    
    .btn-danger {
        background-color: #dc3545;
        color: white;
        border: none;
        padding: 5px 10px;
        border-radius: 4px;
        cursor: pointer;
    }
</style>
