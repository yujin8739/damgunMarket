<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<style>
		#searchForm {
			margin-bottom: 30px;
			display: flex;
			gap: 15px;
			justify-content: right;
			padding-right: 5%;
			align-items: center;
		}

		#searchKeyword {
			padding: 0.8rem 1.5rem;
			border: 2px solid #e0d9ff;
			border-radius: 25px;
			font-size: 1rem;
			outline: none;
			transition: all 0.3s ease;
			min-width: 300px;
			font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
		}

		#searchKeyword:focus {
			border-color: #8b45ff;
			box-shadow: 0 0 20px rgba(139, 69, 255, 0.2);
		}

		#searchForm button {
			padding: 0.8rem 1.8rem;
			border: none;
			border-radius: 25px;
			font-weight: 500;
			cursor: pointer;
			transition: all 0.3s ease;
			text-decoration: none;
			display: inline-block;
			background: linear-gradient(45deg, #8b45ff, #b45aff);
			color: white;
			font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
		}

		#searchForm button:hover {
			transform: translateY(-2px);
			box-shadow: 0 5px 15px rgba(139, 69, 255, 0.4);
		}

		#all-container {
			max-width: 95%;
			margin: 0 auto;
			padding: 0 20px;
			margin-top: 30px;
			background: rgba(255, 255, 255, 0.7);
			backdrop-filter: blur(10px);
			border-radius: 20px;
			box-shadow: 0 8px 32px rgba(139, 69, 255, 0.1);
			padding: 2rem;
		}

		#all-container hr {
			border: none;
			height: 2px;
			background: linear-gradient(90deg, transparent, #e0d9ff, transparent);
			margin: 2rem 0;
		}

		@media (max-width: 768px) {
			#searchForm {
				flex-direction: column;
				align-items: stretch;
				padding-right: 0;
				justify-content: center;
			}

			#searchKeyword {
				min-width: auto;
				width: 100%;
			}

			#searchForm button {
				width: 100%;
			}

			#all-container {
				max-width: 98%;
				padding: 1rem;
				margin-top: 20px;
			}
		}
		#statusFilter {
		    display: flex;
		    justify-content: center;
		    gap: 10px;
		    margin-bottom: 20px;
		}
		
		#statusFilter button {
		    padding: 10px 20px;
		    border-radius: 25px;
		    background-color: #eee;
		    border: none;
		    font-weight: bold;
		    cursor: pointer;
		    transition: background-color 0.3s;
		}
		
		#statusFilter button.active,
		#statusFilter button:hover {
		    background-color: #8b45ff;
		    color: white;
		}
		
	</style>
</head>

<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<div id="all-container" >
	    <form id="searchForm" onsubmit="return false;">
			<input type="hidden" id="latitude">
			<input type="hidden" id="longitude">
	    
	        <div id="statusFilter">
			    <button data-status="거래신청">거래신청</button>
			    <button data-status="예약중">예약중</button>
			    <button data-status="판매완료">구매완료</button>
			</div>
	    </form>
	    <hr>
		<jsp:include page="/WEB-INF/views/product/myHistoryList.jsp"/>
	</div>
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>

</html>