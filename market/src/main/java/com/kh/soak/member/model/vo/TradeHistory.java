package com.kh.soak.member.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class TradeHistory {
	private int userNo; //	USER_NO 유저번호
	private int pdNum; // PD_NUM  상품번호
	private String pdTitle; //PD_TITLE 상품제목
	private String file; //FILED 상품내용
	private String pdImage; //PD_IMAGE 상품이미지 url
}
