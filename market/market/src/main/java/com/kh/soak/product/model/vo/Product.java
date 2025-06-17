package com.kh.soak.product.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Product {
	private int userNo; //	USER_NO
	private int pdNum; //	PD_NUM
	private String pdTitle; //	PD_TITLE
	private String pdBoard; //	PD_BOARD
	private String pdPrice; //	PD_PRICE
	private String latitude; //	LATITUDE
	private String longitude; //	LONGITUDE
	private String bigCate; //	BIG_CATE
	private String midCate; //	MID_CATE
	private String smallCate; //	SMALL_CATE
	private Date updateTime; //	UPDATE_TIME
	private int pdRank; //	PD_RANK
	private int pdStatus; //	PD_STATUS
	private String isSub; //	IS_SUB
	private String pd_url;
	
	
	
	
	
}
