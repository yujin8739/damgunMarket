package com.kh.soak.etc.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Station {
	private int stationNum;//		STATION_NUM	NUMBER(11,0)
	private String stationName;//		STATION_NAME	VARCHAR2(255 BYTE)
	private String lineName;//		LINE_NAME	VARCHAR2(255 BYTE)
	private int latitude;//		LATITUDE	NUMBER(38,8)
	private int longitde;//		LONGITDE	NUMBER(38,7)
	private String address;//		ADDRESS	VARCHAR2(255 BYTE)
}
