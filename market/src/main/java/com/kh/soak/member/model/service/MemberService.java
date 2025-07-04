package com.kh.soak.member.model.service;

import java.util.List;
import java.util.Map;

import com.kh.soak.member.model.vo.Member;

public interface MemberService {

	// 로그인 기능 (SELECT)
	Member loginMember(Member m);

	// 회원가입 기능 (INSERT)
	int insertMember(Member m);

	// 회원 정보 수정 기능 (UPDATE)
	int updateMember(Member m);

	// 회원 탈퇴 기능 (UPDATE)
	int deleteMember(Member m);

	// 아이디 중복확인 기능
	int idCheck(String userId);

	int saveFavorite(int userNo, int pdNum);

	int deleteFavorite(int userNo, int pdNum);

	int selectFavorite(int userNo, int pdNum);

	List<Member> selectEnrollMemberList(int userNo, int pdNum, String status);

	List<Member> selectHistoryMember(int userNo);

	int getUserRank(int userNo);
	int deductUserRank(int userNo, int points);

	int increaseUserRank(int userNo, int points); 
	Map<String, Object> transferUserRank(int senderUserNo, int receiverUserNo, int points);

}
