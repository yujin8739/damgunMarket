
package com.kh.soak.chat.model.vo;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Data
@ToString
public class MessageVO {
	private int roomNo;
	private int msgNo; // DB의 'NO' 컬럼과 매핑될 필드
	private String message;
	private String imageUrl;
	private String userId;
	private Date sendTime;
	private String type; // "chat", "enter", "leave" 등
	private String fileType; // <-- 이 필드를 추가해야 합니다!

	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX", timezone = "Asia/Seoul")
	public Date getSendTime() {
		return sendTime;
	}

	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX", timezone = "Asia/Seoul")
	public void setSendTime(Date sendTime) {
		this.sendTime = sendTime;
	}
}