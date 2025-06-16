package com.kh.soak.member.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.soak.member.model.dao.MemberDao;
import com.kh.soak.member.model.vo.Member;

@Service // String이 관리하는 Bean으로 등록되어야하기 때문에 구현체인 ServiceImpl에 Service 어노테이션 부여해야한다.
public class MemberServiceImpl implements MemberService {

	// dao도 스프링이 관리할 수 있도록 bean 등록처리 해주기

	@Autowired
	private MemberDao dao;

	// sqlSession 객체도 스프링이 관리할 수 있도록 의존성 주입

	// root-context에서 만들어 둔 sqlSession 의존성 주입
	@Autowired
	private SqlSessionTemplate sqlSession;
	// 스프링 컨테이너가 sqlSession의 생명주기도 관리하기 때문에 직접 close할 필요 없고
	// 트랜잭션 처리 또한 스프링이 직접 처리하기 때문에 생략한다.
	// 단 트랜잭션 처리를 직접해야되는 경우엔 해당 메소드에
	// @Transactional 어노테이션을 부여하고 직접 관리하면 된다.

	@Override
	public Member loginMember(Member m) {

		Member loginUser = dao.loginMember(sqlSession, m);

		return loginUser;
	}

	// 회원가입
	@Override
	public int insertMember(Member m) {
		// 한줄 처리
//		int result = dao.insertMember(sqlSession,m);
//		return result;
		return dao.insertMember(sqlSession, m); // 한줄처리
	}

	// 회원 수정
	@Override
	public int updateMember(Member m) {

		return dao.updateMember(sqlSession, m);
	}

	// 회원 탈퇴
	@Override
	public int deleteMember(Member m) {

		return dao.deleteMember(sqlSession, m);
	}

	// 아이디 중복확인
	@Override
	public int idCheck(String userId) {

		return dao.idCheck(sqlSession, userId);
	}

	@Override
	public int saveFavorite(int userNo, int pdNum) {
		Map<String, Object> param = new HashMap<>();
		param.put("pdNum", pdNum);
		param.put("userNo", userNo);
		return dao.saveFavorite(sqlSession, param);
	}

	@Override
	public int deleteFavorite(int userNo, int pdNum) {
		Map<String, Object> param = new HashMap<>();
		param.put("pdNum", pdNum);
		param.put("userNo", userNo);
		return dao.deleteFavorite(sqlSession, param);
	}

	@Override
	public int selectFavorite(int userNo, int pdNum) {
		Map<String, Object> param = new HashMap<>();
		param.put("pdNum", pdNum);
		param.put("userNo", userNo);
		return dao.selectFavorite(sqlSession, param);
	}

	@Override
	public List<Member> selectEnrollMemberList(int userNo, int pdNum, String status) {
		Map<String, Object> param = new HashMap<>();
		param.put("pdNum", pdNum);
		param.put("userNo", userNo);
		param.put("status", status);
		return dao.selectEnrollMemberList(sqlSession, param);
	}

	@Override
	public List<Member> selectHistoryMember(int userNo) {
		return dao.selectHistoryMember(sqlSession, userNo);
	}

	@Override
	public int deductUserRank(int userNo, int points) {
		Map<String, Object> params = new HashMap<>();
		params.put("userNo", userNo);
		params.put("rankChange", -points); // Deduct points
		return dao.updateUserRank(sqlSession, params); // Ensure this DAO method takes SqlSession and Map
	}

	@Override
	public int increaseUserRank(int userNo, int points) {
		Map<String, Object> params = new HashMap<>();
		params.put("userNo", userNo);
		params.put("rankChange", points); // Add points
		return dao.updateUserRank(sqlSession, params); // Ensure this DAO method takes SqlSession and Map
	}


    @Override
    public int getUserRank(int userNo) {
        return dao.selectUserRank(sqlSession, userNo); // Delegate to DAO
    }
	@Override
	public Map<String, Object> transferUserRank(int senderUserNo, int receiverUserNo, int points) {
		Map<String, Object> resultMap = new HashMap<>();

		// 1. Deduct points from sender
		Map<String, Object> senderParams = new HashMap<>();
		senderParams.put("userNo", senderUserNo);
		senderParams.put("rankChange", -points); // Deduct
		int updateSenderResult = dao.updateUserRank(sqlSession, senderParams); // Pass sqlSession

		// 2. Add points to receiver
		Map<String, Object> receiverParams = new HashMap<>();
		receiverParams.put("userNo", receiverUserNo);
		receiverParams.put("rankChange", points); // Add
		int updateReceiverResult = dao.updateUserRank(sqlSession, receiverParams); // Pass sqlSession

		if (updateSenderResult > 0 && updateReceiverResult > 0) {
			int updatedSenderRank = dao.selectUserRank(sqlSession, senderUserNo); // Pass sqlSession
			resultMap.put("status", "success");
			resultMap.put("message", points + "포인트를 성공적으로 담구었습니다.");
			resultMap.put("currentRank", updatedSenderRank);
			System.out.println(
					"INFO: Rank transfer successful. Sender " + senderUserNo + " new rank: " + updatedSenderRank);
		} else {
			resultMap.put("status", "error");
			resultMap.put("message", "포인트 담구기 중 시스템 오류가 발생했습니다.");
			System.err.println(
					"ERROR: Rank transfer failed for sender " + senderUserNo + " to receiver " + receiverUserNo);
			throw new RuntimeException("Failed to transfer rank points.");
		}
		return resultMap;
	}

}
