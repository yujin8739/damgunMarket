package com.kh.soak.member.model.vo;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Product {
	private int user_No; //	USER_NO
	private int pd_Num; //	PD_NUM
	private String pd_Title; //	PD_TITLE
	private String pd_Board; //	PD_BOARD
	private String pd_Price; //	PD_PRICE
	private String latitude; //	LATITUDE
	private String longitude; //	LONGITUDE
	private String big_cate; //	BIG_CATE
	private String mid_cate; //	MID_CATE
	private String small_cate; //	SMALL_CATE
	private Date update_Time; //	UPDATE_TIME
	private int pd_Rank; //	PD_RANK
	private int pd_status; //	PD_STATUS
	private String is_Sub; //	IS_SUB
}
