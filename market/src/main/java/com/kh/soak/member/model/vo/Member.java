package com.kh.soak.member.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

//담굼마켓 멤버 DB사용시 사용할 객체
@NoArgsConstructor //기본 생성자 
@AllArgsConstructor//모든 필드를 갖는 매개변수 생성자
@Data 
public class Member {
	private int userNo;		//	USERNO	NUMBER(11,0) 유저번호 (유저 이미지나 영상 판매물품 외례키)
	private String userId;	//	USERID	VARCHAR2(255 BYTE) 유저아이디
	private String passWord;//	PASSWORD	VARCHAR2(255 BYTE) 유저비밀번호
	private String userName; //	USERNAME VARCHAR2(20 BYTE) 유저이름(닉네임)
	private String email;	//	EMAIL	VARCHAR2(255 BYTE) 이메일 
	private boolean status;//	STATUS	VARCHAR2(1 BYTE) 유저상태(회원 탈퇴 유무)
	private int userRank;	//	USERRANK	NUMBER(38,0) 유저 매너 지수
//	private String address;// ADDRESS VARCHAR2(100 BYTE)
//	private Date enrollDate;// ENROLL_DATE DATE
//	private Date modifyDate;// MODIFY_DATE DATE
}