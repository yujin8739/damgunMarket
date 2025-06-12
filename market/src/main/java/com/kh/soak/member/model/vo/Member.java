package com.kh.soak.member.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@NoArgsConstructor 
@AllArgsConstructor
@Data 
public class Member {
	private int userNo;		//	USERNO	NUMBER(11,0))
	private String userId;	//	USERID	VARCHAR2
	private String passWord;//	PASSWORD	VARCHAR
	private String userName; //	USERNAME VARCHAR2(20
	private String email;	//	EMAIL	VARCHAR2(25
	private String status;//	STATUS	VARCHAR2(
	private int userRank;	//	USERRANK	NUMBER(38,0
//	private String address;// ADDRESS VARCHAR2(100 BYTE)
//	private Date enrollDate;// ENROLL_DATE DATE
//	private Date modifyDate;// MODIFY_DATE DATEs
	}
