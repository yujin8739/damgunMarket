<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 등록</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        .form-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: bold;
            margin-bottom: 8px;
        }
        .required {
            color: #dc3545;
        }
        .file-upload-area {
            border: 2px dashed #dee2e6;
            border-radius: 5px;
            padding: 20px;
            text-align: center;
            background-color: #f8f9fa;
        }
        .file-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }
        .file-preview img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 5px;
            border: 1px solid #dee2e6;
        }
        .btn-submit {
            background-color: #007bff;
            border-color: #007bff;
            padding: 12px 30px;
            font-size: 16px;
        }
        .btn-submit:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .category-select {
            margin-bottom: 15px;
        }
        .location-info {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h2 class="form-title">상품 등록</h2>
            
            <form action="${contextPath}/product/insert" method="post" enctype="multipart/form-data" id="productForm">
                
                <!-- 상품명 -->
                <div class="form-group">
                    <label for="pdTitle" class="form-label">상품명 <span class="required">*</span></label>
                    <input type="text" class="form-control" id="pdTitle" name="pdTitle" required 
                           placeholder="상품명을 입력해주세요" maxlength="100">
                </div>
                
                <!-- 카테고리 선택 -->
                <div class="form-group">
                    <label class="form-label">카테고리 <span class="required">*</span></label>
                    
                    <!-- 대분류 -->
                    <div class="category-select">
                        <select class="form-select" id="bigCate" name="bigCate" required>
                            <option value="">대분류를 선택해주세요</option>
                            <c:forEach var="bigCate" items="${bigCategoryList}">
                                <option value="${bigCate}">${bigCate}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- 중분류 -->
                    <div class="category-select">
                        <select class="form-select" id="midCate" name="midCate" required disabled>
                            <option value="">중분류를 선택해주세요</option>
                        </select>
                    </div>
                    
                    <!-- 소분류 -->
                    <div class="category-select">
                        <select class="form-select" id="smallCtae" name="smallCtae" required disabled>
                            <option value="">소분류를 선택해주세요</option>
                        </select>
                    </div>
                </div>
                
                <!-- 가격 -->
                <div class="form-group">
                    <label for="pdPrice" class="form-label">가격 <span class="required">*</span></label>
                    <div class="input-group">
                        <input type="number" class="form-control" id="pdPrice" name="pdPrice" required 
                               placeholder="0" min="0">
                        <span class="input-group-text">원</span>
                    </div>
                </div>
                
                <!-- 상품 설명 -->
                <div class="form-group">
                    <label for="pdBoard" class="form-label">상품 설명 <span class="required">*</span></label>
                    <textarea class="form-control" id="pdBoard" name="pdBoard" rows="8" required 
                              placeholder="상품에 대한 자세한 설명을 입력해주세요" maxlength="2000"></textarea>
                    <div class="form-text">최대 2000자까지 입력 가능합니다.</div>
                </div>
                
                <!-- 상품 이미지 -->
                <div class="form-group">
                    <label class="form-label">상품 이미지 <span class="required">*</span></label>
                    <div class="file-upload-area">
                        <p class="mb-2">이미지를 선택해주세요 (최대 5장)</p>
                        <input type="file" class="form-control" id="uploadFile" name="uploadFile" 
                               multiple accept="image/*" required>
                        <small class="text-muted">첫 번째 이미지가 대표 이미지로 설정됩니다.</small>
                    </div>
                    <div class="file-preview" id="filePreview"></div>
                </div>
                
                <!-- 위치 정보 -->
                <div class="form-group">
                    <label class="form-label">거래 위치</label>
                    <button type="button" class="btn btn-outline-primary" id="getLocationBtn">
                        현재 위치 가져오기
                    </button>
                    <div class="location-info" id="locationInfo" style="display: none;">
                        <p class="mb-1"><strong>설정된 위치:</strong></p>
                        <p class="mb-0" id="locationText">위치를 설정해주세요</p>
                    </div>
                    <input type="hidden" id="latitude" name="latitude">
                    <input type="hidden" id="longitude" name="longitude">
                </div>
                
                <!-- 버튼 영역 -->
                <div class="d-grid gap-2 d-md-flex justify-content-md-center mt-4">
                    <button type="button" class="btn btn-secondary me-2" onclick="history.back()">취소</button>
                    <button type="submit" class="btn btn-primary btn-submit">상품 등록</button>
                </div>
                
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        $(document).ready(function() {
            
            // 대분류 선택 시 중분류 로드
            $('#bigCate').change(function() {
                const bigCate = $(this).val();
                const midCateSelect = $('#midCate');
                const smallCateSelect = $('#smallCtae');
                
                // 하위 카테고리 초기화
                midCateSelect.empty().append('<option value="">중분류를 선택해주세요</option>');
                smallCateSelect.empty().append('<option value="">소분류를 선택해주세요</option>');
                smallCateSelect.prop('disabled', true);
                
                if (bigCate) {
                    $.ajax({
                        url: '${contextPath}/product/midCategory',
                        type: 'GET',
                        data: { bigCate: bigCate },
                        success: function(data) {
                            $.each(data, function(index, midCate) {
                                midCateSelect.append('<option value="' + midCate + '">' + midCate + '</option>');
                            });
                            midCateSelect.prop('disabled', false);
                        },
                        error: function() {
                            alert('중분류 카테고리를 불러오는데 실패했습니다.');
                        }
                    });
                } else {
                    midCateSelect.prop('disabled', true);
                }
            });
            
            // 중분류 선택 시 소분류 로드
            $('#midCate').change(function() {
                const bigCate = $('#bigCate').val();
                const midCate = $(this).val();
                const smallCateSelect = $('#smallCtae');
                
                smallCateSelect.empty().append('<option value="">소분류를 선택해주세요</option>');
                
                if (bigCate && midCate) {
                    $.ajax({
                        url: '${contextPath}/product/smallCategory',
                        type: 'GET',
                        data: { 
                            bigCate: bigCate,
                            midCate: midCate 
                        },
                        success: function(data) {
                            $.each(data, function(index, smallCate) {
                                smallCateSelect.append('<option value="' + smallCate + '">' + smallCate + '</option>');
                            });
                            smallCateSelect.prop('disabled', false);
                        },
                        error: function() {
                            alert('소분류 카테고리를 불러오는데 실패했습니다.');
                        }
                    });
                } else {
                    smallCateSelect.prop('disabled', true);
                }
            });
            
            // 파일 선택 시 미리보기
            $('#uploadFile').change(function() {
                const files = this.files;
                const preview = $('#filePreview');
                preview.empty();
                
                if (files.length > 5) {
                    alert('최대 5장까지만 업로드 가능합니다.');
                    this.value = '';
                    return;
                }
                
                for (let i = 0; i < files.length; i++) {
                    const file = files[i];
                    if (file.type.startsWith('image/')) {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const img = $('<img>').attr('src', e.target.result);
                            if (i === 0) {
                                img.css('border', '3px solid #007bff');
                                img.attr('title', '대표 이미지');
                            }
                            preview.append(img);
                        };
                        reader.readAsDataURL(file);
                    }
                }
            });
            
            // 현재 위치 가져오기
            $('#getLocationBtn').click(function() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function(position) {
                        const lat = position.coords.latitude;
                        const lng = position.coords.longitude;
                        
                        $('#latitude').val(lat);
                        $('#longitude').val(lng);
                        $('#locationText').text('위도: ' + lat.toFixed(6) + ', 경도: ' + lng.toFixed(6));
                        $('#locationInfo').show();
                        
                        alert('현재 위치가 설정되었습니다.');
                    }, function(error) {
                        alert('위치 정보를 가져올 수 없습니다. 브라우저 설정을 확인해주세요.');
                    });
                } else {
                    alert('이 브라우저는 위치 서비스를 지원하지 않습니다.');
                }
            });
            
            // 가격 입력 시 숫자만 입력되도록 포맷팅
            $('#pdPrice').on('input', function() {
                let value = $(this).val().replace(/[^0-9]/g, '');
                $(this).val(value);
            });
            
            // 폼 제출 전 유효성 검사
            $('#productForm').submit(function(e) {
                // 필수 필드 검사
                if (!$('#pdTitle').val().trim()) {
                    alert('상품명을 입력해주세요.');
                    $('#pdTitle').focus();
                    e.preventDefault();
                    return false;
                }
                
                if (!$('#bigCate').val() || !$('#midCate').val() || !$('#smallCtae').val()) {
                    alert('카테고리를 모두 선택해주세요.');
                    e.preventDefault();
                    return false;
                }
                
                if (!$('#pdPrice').val() || $('#pdPrice').val() == '0') {
                    alert('가격을 입력해주세요.');
                    $('#pdPrice').focus();
                    e.preventDefault();
                    return false;
                }
                
                if (!$('#pdBoard').val().trim()) {
                    alert('상품 설명을 입력해주세요.');
                    $('#pdBoard').focus();
                    e.preventDefault();
                    return false;
                }
                
                if (!$('#uploadFile')[0].files.length) {
                    alert('상품 이미지를 선택해주세요.');
                    e.preventDefault();
                    return false;
                }
                
                // 제출 확인
                if (confirm('상품을 등록하시겠습니까?')) {
                    $('button[type="submit"]').prop('disabled', true).text('등록 중...');
                    return true;
                } else {
                    e.preventDefault();
                    return false;
                }
            });
            
        });
    </script>
</body>
</html>