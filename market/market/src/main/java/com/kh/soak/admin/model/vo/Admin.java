package com.kh.soak.admin.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Getter
@Setter

public class Admin {
    private int adminNum;       // ADMIN_NUM NUMBER(11) - 관리자 번호
    private String adminId;     // ADMIN_ID VARCHAR2(20) - 관리자 아이디
    private String adminPw;     // ADMIN_PW VARCHAR2(20) - 관리자 비밀번호
    private String adminName;   // ADMIN_NAME VARCHAR2(20) - 관리자 이름
}