package com.kh.soak.member.model.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.soak.member.model.dao.MemberDao;
import com.kh.soak.member.model.vo.Member;

@Service
@Transactional 
public class MemberServiceImpl implements MemberService{
	@Autowired
	private MemberDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;  //추가 수정필요  
	//스프링 컨테이너가 sqlSession의 생명주기도 관리하기 때문에 직접 close할 필요 없고
	//트랜잭션 처리 또한 스프링이 직접 처리하기 때문에 생략한다.
	//단 트랜잭션 처리를 직접해야되는 경우엔 해당 메소드에 
	//@Transactional 어노테이션을 부여하고 직접 관리하면 된다.
	@Override
	public Member loginMember(Member m) {
		Member loginUser = dao.loginMember(sqlSession,m);
		return loginUser;
	}
	
	@Override
	public int insertMember(Member m) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateMember(Member m) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteMember(Member m) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int idCheck(String userId) {
		// TODO Auto-generated method stub
		return 0;
	}
}