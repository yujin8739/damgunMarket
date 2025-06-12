<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 수정</title>
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
<%@ include file="/WEB-INF/views/common/header.jsp"%>

<div class="container">
    <div class="form-container">
        <h2 class="form-title">상품 수정</h2>

        <form action="${pageContext.request.contextPath}/product/update" method="post" enctype="multipart/form-data">
            <input type="hidden" name="pdNum" value="${product.pdNum}" />

            <!-- 상품명 -->
            <div class="form-group">
                <label for="pdTitle" class="form-label">상품명 <span class="required">*</span></label>
                <input type="text" class="form-control" id="pdTitle" name="pdTitle" required
                       value="${product.pdTitle}" maxlength="100">
            </div>

            <!-- 카테고리 -->
            <div class="form-group">
                <label class="form-label">카테고리 <span class="required">*</span></label>

                <!-- 대분류 -->
                <div class="category-select">
                    <select class="form-select" id="bigCate" name="bigCate" required>
                        <option value="">대분류를 선택해주세요</option>
                        <c:forEach var="bigCate" items="${bigCategoryList}">
                            <option value="${bigCate}" ${bigCate == product.bigCate ? 'selected' : ''}>${bigCate}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 중분류 -->
                <div class="category-select">
                    <select class="form-select" id="midCate" name="midCate" required>
                        <option value="${product.midCate}" selected>${product.midCate}</option>
                    </select>
                </div>

                <!-- 소분류 -->
                <div class="category-select">
                    <select class="form-select" id="smallCtae" name="smallCtae" required>
                        <option value="${product.smallCtae}" selected>${product.smallCtae}</option>
                    </select>
                </div>
            </div>

            <!-- 가격 -->
            <div class="form-group">
                <label for="pdPrice" class="form-label">가격 <span class="required">*</span></label>
                <div class="input-group">
                    <input type="number" class="form-control" id="pdPrice" name="pdPrice" required
                           value="${product.pdPrice}" min="0">
                    <span class="input-group-text">원</span>
                </div>
            </div>

            <!-- 상품 설명 -->
            <div class="form-group">
                <label for="pdBoard" class="form-label">상품 설명 <span class="required">*</span></label>
                <textarea class="form-control" id="pdBoard" name="pdBoard" rows="8" required maxlength="2000">${product.pdBoard}</textarea>
                <div class="form-text">최대 2000자까지 입력 가능합니다.</div>
            </div>

            <!-- 이미지 업로드 -->
            <div class="form-group">
                <label class="form-label">상품 이미지 <span class="required">*</span></label>
                <div class="file-upload-area">
                    <p class="mb-2">이미지를 새로 업로드하거나 기존 이미지를 유지할 수 있습니다 (최대 5장)</p>
                    <input type="file" class="form-control" id="uploadFile" name="uploadFile" multiple accept="image/*">
                    <small class="text-muted">첫 번째 이미지가 대표 이미지로 설정됩니다.</small>
                </div>
                <div class="file-preview" id="filePreview">
                    <c:forEach var="img" items="${product.imageList}">
                        <img src="${pageContext.request.contextPath}/upload/${img.savedName}" title="${img.originName}" />
                    </c:forEach>
                </div>
            </div>

            <!-- 수정 버튼 -->
            <div class="d-grid gap-2 d-md-flex justify-content-md-center mt-4">
                <a href="javascript:history.back()" class="btn btn-secondary me-2">취소</a>
                <button type="submit" class="btn btn-primary btn-submit">수정 완료</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp"%>

<!-- jQuery & Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
    const serverPath = '${pageContext.request.contextPath}';

    $(document).ready(function() {
        // 대분류 변경 시 중분류 로딩
        $('#bigCate').change(function() {
            const bigCate = $(this).val();
            const midCate = $('#midCate');
            const smallCate = $('#smallCtae');

            midCate.empty().append('<option value="">중분류를 선택해주세요</option>').prop('disabled', true);
            smallCate.empty().append('<option value="">소분류를 선택해주세요</option>').prop('disabled', true);

            if (bigCate) {
                $.get(serverPath + '/category/mid', { bigCate }, function(data) {
                    $.each(data, function(i, mid) {
                        midCate.append('<option value="' + mid + '">' + mid + '</option>');
                    });
                    midCate.prop('disabled', false);
                });
            }
        });

        // 중분류 변경 시 소분류 로딩
        $('#midCate').change(function() {
            const bigCate = $('#bigCate').val();
            const midCate = $(this).val();
            const smallCate = $('#smallCtae');

            smallCate.empty().append('<option value="">소분류를 선택해주세요</option>').prop('disabled', true);

            if (bigCate && midCate) {
                $.get(serverPath + '/category/small', { bigCate, midCate }, function(data) {
                    $.each(data, function(i, small) {
                        smallCate.append('<option value="' + small + '">' + small + '</option>');
                    });
                    smallCate.prop('disabled', false);
                });
            }
        });

        // 이미지 미리보기
        $('#uploadFile').change(function() {
            const files = this.files;
            const preview = $('#filePreview');
            preview.empty();

            if (files.length > 5) {
                alert('최대 5장까지만 업로드 가능합니다.');
                this.value = '';
                return;
            }

            Array.from(files).forEach((file, index) => {
                if (file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const img = $('<img>').attr('src', e.target.result);
                        if (index === 0) img.css('border', '3px solid #007bff');
                        preview.append(img);
                    };
                    reader.readAsDataURL(file);
                }
            });
        });

        // 가격 숫자만 입력
        $('#pdPrice').on('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    });
</script>
</body>
</html>
