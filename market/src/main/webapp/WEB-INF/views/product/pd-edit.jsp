<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 수정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* pd-regist.jsp 스타일 그대로 복사 */
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
        }
        .required {
            color: #dc3545;
        }
        .btn-submit {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-submit:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .image-preview {
        position: relative;
        display: inline-block;
	    }
	    .image-preview .delete-btn {
	        position: absolute;
	        top: 5px;
	        right: 5px;
	        font-size: 16px;
	        line-height: 1;
	        padding: 4px 8px;
	        border-radius: 50%;
	    }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="container">
    <div class="form-container">
        <h2 class="form-title">상품 수정</h2>

        <form action="${pageContext.request.contextPath}/product/edit" method="post" enctype="multipart/form-data">
            <!-- 숨겨진 상품 번호 -->
            <input type="hidden" name="pdNum" value="${product.pdNum}" />
			<input type="hidden" name="userNo" value="${product.userNo}" />
            <!-- 상품명 -->
            <div class="form-group">
                <label for="pdTitle" class="form-label">상품명 <span class="required">*</span></label>
                <input type="text" class="form-control" id="pdTitle" name="pdTitle"
                       value="${product.pdTitle}" required maxlength="100" />
            </div>

            <!-- 가격 -->
            <div class="form-group">
                <label for="pdPrice" class="form-label">가격 <span class="required">*</span></label>
                <div class="input-group">
                    <input type="number" class="form-control" id="pdPrice" name="pdPrice"
                           value="${product.pdPrice}" min="0" required />
                    <span class="input-group-text">원</span>
                </div>
            </div>

            <!-- 카테고리: 대분류/중분류/소분류 -->
            <div class="form-group"> 
                <label class="form-label">카테고리 <span class="required">*</span></label>
                
                <select class="form-select mb-2" id="bigCate" name="bigCate" required>
                    <option value="">대분류 선택</option>
                    <c:forEach var="big" items="${bigCategoryList}">
                        <option value="${big}" ${big == product.bigCate ? 'selected' : ''}>${big}</option>
                    </c:forEach>
                </select>
                
                <select class="form-select mb-2" id="midCate" name="midCate" required>
                    <option value="${product.midCate}">${product.midCate}</option>
                </select>
                
                <select class="form-select" id="smallCate" name="smallCate" required>
                    <option value="${product.smallCate}">${product.smallCate}</option>
                </select>
            </div>

            <!-- 상품 설명 -->
            <div class="form-group">
                <label for="pdBoard" class="form-label">상품 설명 <span class="required">*</span></label>
                <textarea class="form-control" id="pdBoard" name="pdBoard" rows="6"
                          required maxlength="2000">${product.pdBoard}</textarea>
            </div>
            
           <div class="form-group">
                    <label class="form-label">상품 이미지 <span class="required">*</span></label>
                    <div class="file-upload-area">
                        <p class="mb-2">이미지를 선택해주세요 (최대 5장)</p>
                       <input type="file" class="form-control" id="uploadFile" name="uploadFiles" multiple accept="image/*">
                        <small class="text-muted">첫 번째 이미지가 대표 이미지로 설정됩니다.</small>
                    </div>
                    <div class="file-preview" id="filePreview"></div>
           </div>

            <!-- 수정 버튼 -->
            <div class="d-grid gap-2 d-md-flex justify-content-md-center mt-4">
                <button type="button" class="btn btn-secondary me-2" onclick="history.back()">취소</button>
                <button type="submit" class="btn btn-primary btn-submit">수정 완료</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    const serverPath = '${pageContext.request.contextPath}';
    const fileList = JSON.parse('${fileListJson}');
    
    $(document).ready(function () {
        $('#bigCate').change(function () {
            const bigCate = $(this).val();
            $.ajax({
                url: serverPath + '/category/mid',
                type: 'GET',
                data: { bigCate: bigCate },
                success: function (data) {
                    $('#midCate').empty().append('<option value="">중분류 선택</option>');
                    $('#smallCate').empty().append('<option value="">소분류 선택</option>');
                    data.forEach(function (item) {
                        $('#midCate').append('<option value="' + item + '">' + item + '</option>');
                    });
                }
            });
        });

        $('#midCate').change(function () {
            const bigCate = $('#bigCate').val();
            const midCate = $(this).val();
            $.ajax({
                url: serverPath + '/category/small',
                type: 'GET',
                data: { bigCate: bigCate, midCate: midCate },
                success: function (data) {
                    $('#smallCate').empty().append('<option value="">소분류 선택</option>');
                    data.forEach(function (item) {
                        $('#smallCate').append('<option value="' + item + '">' + item + '</option>');
                    });
                }
            });
        });
     // 기존 파일 미리보기 추가
        fileList.forEach(function (fileName, index) {
            const previewHtml = `
                <div class="image-preview position-relative d-inline-block me-2 mb-2">
                    <img src="\${fileName}" class="img-thumbnail" style="width: 150px; height: 150px; object-fit: cover;">
                    <button type="button" class="btn btn-danger btn-sm rounded-circle position-absolute top-0 end-0 delete-btn"
                        data-file="\${fileName}" style="transform: translate(50%, -50%);">
                        &times;
                    </button>
                    <input type="hidden" name="existingFiles" value="\${fileName}">
                </div>`;
            $('#filePreview').append(previewHtml);
        });
     	
        $('#uploadFile').on('change', function (event) {
            const files = event.target.files;
            const previewContainer = $('#filePreview');

            for (let i = 0; i < files.length; i++) {
                const file = files[i];

                // 이미지 파일만 처리
                if (!file.type.startsWith('image/')) continue;

                const reader = new FileReader();

                reader.onload = function (e) {
                    const previewHtml = `
                        <div class="image-preview position-relative d-inline-block me-2 mb-2">
                            <img src="\${e.target.result}" class="img-thumbnail" style="width: 150px; height: 150px; object-fit: cover;">
                            <button type="button" class="btn btn-danger btn-sm rounded-circle position-absolute top-0 end-0 delete-btn"
                                style="transform: translate(50%, -50%);">
                                &times;
                            </button>
                        </div>`;
                    previewContainer.append(previewHtml);
                };

                reader.readAsDataURL(file);
            }
        });
        
        // 기존 이미지 삭제
        $(document).on('click', '.delete-btn', function () {
            const $preview = $(this).closest('.image-preview');
            $preview.remove();
        });
    });
</script>
</body>
</html>
