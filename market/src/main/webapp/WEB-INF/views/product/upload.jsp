<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>중고거래 글쓰기 - 당근마켓</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
            color: #212529;
            line-height: 1.6;
        }

        .container {
            max-width: 680px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            min-height: 100vh;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 0;
            border-bottom: 1px solid #e9ecef;
            margin-bottom: 24px;
        }

        .header h1 {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
        }

        .btn-complete {
            background-color: #ff6f0f;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-complete:hover {
            background-color: #e55a00;
        }

        .btn-complete:disabled {
            background-color: #dee2e6;
            cursor: not-allowed;
        }

        .form-group {
            margin-bottom: 32px;
        }

        .form-label {
            display: block;
            font-size: 16px;
            font-weight: 600;
            color: #212529;
            margin-bottom: 12px;
        }

        .required {
            color: #ff6f0f;
        }

        /* 이미지 업로드 영역 */
        .image-upload-container {
            display: flex;
            gap: 8px;
            overflow-x: auto;
            padding-bottom: 8px;
        }

        .image-upload-box {
            min-width: 80px;
            width: 80px;
            height: 80px;
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            background-color: #f8f9fa;
            transition: border-color 0.2s;
        }

        .image-upload-box:hover {
            border-color: #ff6f0f;
        }

        .image-upload-box i {
            font-size: 24px;
            color: #6c757d;
            margin-bottom: 4px;
        }

        .image-count {
            font-size: 12px;
            color: #6c757d;
        }

        .image-preview {
            position: relative;
            width: 80px;
            height: 80px;
            border-radius: 8px;
            overflow: hidden;
        }

        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .image-remove {
            position: absolute;
            top: 4px;
            right: 4px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background-color: rgba(0, 0, 0, 0.6);
            color: white;
            border: none;
            font-size: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        #imageUpload {
            display: none;
        }

        /* 입력 필드 스타일 */
        .form-input {
            width: 100%;
            padding: 16px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.2s;
        }

        .form-input:focus {
            border-color: #ff6f0f;
        }

        .form-textarea {
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        .price-input-container {
            position: relative;
        }

        .price-input {
            padding-right: 40px;
        }

        .price-unit {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 16px;
        }

        /* 카테고리 선택 */
        .category-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 40px;
        }

        /* 거래 희망 지역 */
        .location-input {
            background-color: #f8f9fa;
            cursor: pointer;
        }

        .location-input:focus {
            background-color: white;
        }

        /* 추가 옵션 */
        .checkbox-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .checkbox-item input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #ff6f0f;
        }

        .checkbox-item label {
            font-size: 14px;
            color: #495057;
            cursor: pointer;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .container {
                padding: 16px;
            }
            
            .header {
                padding: 12px 0;
            }
            
            .form-group {
                margin-bottom: 24px;
            }
        }

        /* 도움말 텍스트 */
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 8px;
        }

        /* 에러 메시지 */
        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 4px;
        }

        /* 아이콘 스타일 */
        .icon {
            width: 24px;
            height: 24px;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>중고거래 등록</h1>
            <button type="submit" form="uploadForm" class="btn-complete" id="submitBtn" disabled>완료</button>
        </div>

        <form id="uploadForm" enctype="multipart/form-data">
            <!-- 이미지 업로드 -->
            <div class="form-group">
                <label class="form-label">상품 이미지 <span class="required">*</span></label>
                <div class="image-upload-container" id="imageContainer">
                    <div class="image-upload-box" onclick="document.getElementById('imageUpload').click()">
                        <div class="icon">📷</div>
                        <div class="image-count" id="imageCount">0/10</div>
                    </div>
                </div>
                <input type="file" id="imageUpload" name="images" multiple accept="image/*">
                <div class="help-text">상품 이미지는 640x640에 최적화 되어 있습니다. (최대 10장)</div>
            </div>

            <!-- 제목 -->
            <div class="form-group">
                <label for="title" class="form-label">글 제목 <span class="required">*</span></label>
                <input type="text" id="title" name="title" class="form-input" placeholder="상품의 제목을 입력해주세요" maxlength="50">
                <div class="help-text">50자 이내로 입력해주세요</div>
            </div>

            <!-- 카테고리 -->
            <div class="form-group">
                <label for="category" class="form-label">카테고리 <span class="required">*</span></label>
                <select id="category" name="category" class="form-input category-select">
                    <option value="">카테고리를 선택해주세요</option>
                    <option value="digital">디지털기기</option>
                    <option value="appliances">생활가전</option>
                    <option value="furniture">가구/인테리어</option>
                    <option value="kids">유아동</option>
                    <option value="sports">스포츠/레저</option>
                    <option value="women-fashion">도서/음반</option>
                    <option value="women-accessories">패션의류</option>
                    <option value="men-fashion">패션잡화</option>
                    <option value="beauty">반려동물</option>                    
                </select>
            </div>

            <!-- 거래지역 -->
            <div class="form-group">
                <label for="location" class="form-label">거래 희망 지역 <span class="required">*</span></label>
                <input type="text" id="location" name="location" class="form-input location-input" placeholder="지역을 선택해주세요" readonly>
                <div class="help-text">우리동네 설정 지역으로 자동 설정됩니다</div>
                
            </div>


            <!-- 상품 상태 -->
            <div class="form-group">
                <label class="form-label">상품 상태 <span class="required">*</span></label>
                <div style="display: flex; gap: 16px;">
                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                        <input type="radio" name="condition" value="new" style="accent-color: #ff6f0f;">
                        <span>새상품</span>
                    </label>
                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                        <input type="radio" name="condition" value="used" style="accent-color: #ff6f0f;">
                        <span>중고상품</span>
                    </label>
                </div>
            </div>

            <!-- 가격 -->
            <div class="form-group">
                <label for="price" class="form-label">가격 <span class="required">*</span></label>
                <div class="price-input-container">
                    <input type="number" id="price" name="price" class="form-input price-input" placeholder="가격을 입력해주세요" min="0">
                    <span class="price-unit">원</span>
                </div>
                <div class="checkbox-group" style="margin-top: 12px;">
                    <div class="checkbox-item">
                        <input type="checkbox" id="negotiable" name="negotiable">
                        <label for="negotiable">가격 제안받기</label>
                    </div>
                </div>
            </div>

            <!-- 설명 -->
            <div class="form-group">
                <label for="description" class="form-label">자세한 설명 <span class="required">*</span></label>
                <textarea id="description" name="description" class="form-input form-textarea" placeholder="상품에 대한 자세한 설명을 입력해주세요.&#10;&#10;- 구매 시기, 사용감, 하자 유무 등을 적어주세요.&#10;- 다른 중고거래 사이트 언급 시 게시글이 제재될 수 있어요." maxlength="2000"></textarea>
                <div class="help-text">2000자 이내로 입력해주세요</div>
            </div>

        </form>
    </div>

    <script>
        // 전역 변수
        let selectedImages = [];
        let maxImages = 10;

        // DOM 요소
        const imageUpload = document.getElementById('imageUpload');
        const imageContainer = document.getElementById('imageContainer');
        const imageCount = document.getElementById('imageCount');
        const submitBtn = document.getElementById('submitBtn');
        const form = document.getElementById('uploadForm');

        // 필수 필드 요소들
        const requiredFields = {
            images: () => selectedImages.length > 0,
            title: document.getElementById('title'),
            category: document.getElementById('category'),
            location: document.getElementById('location'),
            condition: () => document.querySelector('input[name="condition"]:checked'),
            price: document.getElementById('price'),
            description: document.getElementById('description')
        };

        // 이미지 업로드 처리
        imageUpload.addEventListener('change', function(e) {
            const files = Array.from(e.target.files);
            
            files.forEach(file => {
                if (selectedImages.length >= maxImages) {
                    alert(`최대 ${maxImages}장까지 업로드 가능합니다.`);
                    return;
                }
                
                if (file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const imageData = {
                            file: file,
                            url: e.target.result,
                            id: Date.now() + Math.random()
                        };
                        
                        selectedImages.push(imageData);
                        renderImages();
                        updateImageCount();
                        validateForm();
                    };
                    reader.readAsDataURL(file);
                }
            });
            
            // input 값 초기화
            e.target.value = '';
        });

        // 이미지 렌더링
        function renderImages() {
            // 기존 이미지들 제거 (업로드 박스는 유지)
            const existingPreviews = imageContainer.querySelectorAll('.image-preview');
            existingPreviews.forEach(preview => preview.remove());
            
            // 새 이미지들 추가
            selectedImages.forEach((imageData, index) => {
                const previewDiv = document.createElement('div');
                previewDiv.className = 'image-preview';
                previewDiv.innerHTML = `
                    <img src="${imageData.url}" alt="상품 이미지 ${index + 1}">
                    <button type="button" class="image-remove" onclick="removeImage(${index})">×</button>
                `;
                imageContainer.appendChild(previewDiv);
            });
        }

        // 이미지 제거
        function removeImage(index) {
            selectedImages.splice(index, 1);
            renderImages();
            updateImageCount();
            validateForm();
        }

        // 이미지 개수 업데이트
        function updateImageCount() {
            imageCount.textContent = `${selectedImages.length}/${maxImages}`;
        }

        // 폼 유효성 검사
        function validateForm() {
            let isValid = true;
            
            // 이미지 체크
            if (selectedImages.length === 0) {
                isValid = false;
            }
            
            // 다른 필수 필드들 체크
            for (let key in requiredFields) {
                if (key === 'images') continue;
                
                if (typeof requiredFields[key] === 'function') {
                    if (!requiredFields[key]()) {
                        isValid = false;
                        break;
                    }
                } else {
                    if (!requiredFields[key].value.trim()) {
                        isValid = false;
                        break;
                    }
                }
            }
            
            submitBtn.disabled = !isValid;
        }

        // 입력 필드 이벤트 리스너
        document.getElementById('title').addEventListener('input', validateForm);
        document.getElementById('category').addEventListener('change', validateForm);
        document.getElementById('location').addEventListener('input', validateForm);
        document.getElementById('price').addEventListener('input', validateForm);
        document.getElementById('description').addEventListener('input', validateForm);
        
        // 라디오 버튼 이벤트 리스너
        document.querySelectorAll('input[name="condition"]').forEach(radio => {
            radio.addEventListener('change', validateForm);
        });

        // 지역 선택 클릭 이벤트
        document.getElementById('location').addEventListener('click', function() {
            // 실제 구현에서는 지역 선택 모달이나 API 호출
            this.value = '서울시 강남구 역삼동';
            validateForm();
        });

        // 폼 제출 처리
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!validateForm()) {
                alert('필수 정보를 모두 입력해주세요.');
                return;
            }
            
            // FormData 생성
            const formData = new FormData();
            
            // 이미지 파일들 추가
            selectedImages.forEach((imageData, index) => {
                formData.append('images', imageData.file);
            });
            
            // 다른 폼 데이터 추가
            formData.append('title', document.getElementById('title').value);
            formData.append('category', document.getElementById('category').value);
            formData.append('location', document.getElementById('location').value);
            formData.append('condition', document.querySelector('input[name="condition"]:checked').value);
            formData.append('price', document.getElementById('price').value);
            formData.append('description', document.getElementById('description').value);
            formData.append('negotiable', document.getElementById('negotiable').checked);
            formData.append('delivery', document.getElementById('delivery').checked);
            formData.append('safePay', document.getElementById('safePay').checked);
            
            // 서버로 전송 (실제 구현에서는 AJAX 요청)
            console.log('폼 데이터 전송:', Object.fromEntries(formData));
            alert('상품이 등록되었습니다!');
            
            // 실제 서버 전송 코드
            /*
            fetch('/api/products', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                alert('상품이 등록되었습니다!');
                window.location.href = '/products/' + data.id;
            })
            .catch(error => {
                console.error('Error:', error);
                alert('등록에 실패했습니다. 다시 시도해주세요.');
            });
            */
        });

        // 초기 폼 상태 설정
        document.addEventListener('DOMContentLoaded', function() {
            updateImageCount();
            validateForm();
        });
    </script>
</body>
</html>