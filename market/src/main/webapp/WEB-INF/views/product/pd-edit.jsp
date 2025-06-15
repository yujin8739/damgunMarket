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
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="container">
    <div class="form-container">
        <h2 class="form-title">상품 수정</h2>

        <form action="${pageContext.request.contextPath}/product/update" method="post" enctype="multipart/form-data">
            <!-- 숨겨진 상품 번호 -->
            <input type="hidden" name="pdNum" value="${product.pdNum}" />

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

            <!-- 기존 이미지 미리보기 (선택적) -->
            <c:if test="${not empty product.pd_url}">
                <div class="form-group">
                    <label class="form-label">기존 대표 이미지</label><br>
                    <img src="${product.pd_url}"
                         alt="기존 이미지" width="150" style="border:1px solid #ccc; border-radius:8px;" />
                </div>
            </c:if>

            <!-- 새 이미지 업로드 -->
            <div class="form-group">
                <label class="form-label">상품 이미지 수정</label>
                <input type="file" class="form-control" name="uploadFile" accept="image/*" />
                <small class="text-muted">수정할 경우 새 이미지를 선택해주세요.</small>
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
    });
</script>
</body>
</html>
