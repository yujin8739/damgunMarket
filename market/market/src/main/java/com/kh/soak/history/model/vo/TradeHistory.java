package com.kh.soak.history.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class TradeHistory {
	private int user_No; //	USER_NO 유저번호
	private int pd_Num; // PD_NUM  상품번호
	private String pd_Title; //PD_TITLE 상품제목
	private int pd_Price;
	private String filed; //FILED 상품내용
	private String pd_Image; //PD_IMAGE 상품이미지 url
}
