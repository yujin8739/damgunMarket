package com.kh.soak.product.model.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class PdFile {
	 private int userNo;
	 private int pdNum;
	 private String pdUrl;
	 private String fileType = "IMG";
	 private String isThumbnail = "N";
	 private String isSub;
	 private int fileNo;
}
