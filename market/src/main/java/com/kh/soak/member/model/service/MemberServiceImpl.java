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
	
	
	//로그인기능
	@Override
	public Member loginMember(Member m) {
		Member loginUser = dao.loginMember(sqlSession,m);
		return loginUser;
	}
	//회원가입 기능
	@Override
	public int insertMember(Member m) {
		// TODO Auto-generated method stub
		return 0;
	}

	//회원정보수정 기능
	@Override
	public int updateMember(Member m) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	//회원탈퇴 기능
	@Override
	public int deleteMember(Member m) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	//아이디 중복확인 기능
	@Override
	public int idCheck(String userId) {
		// TODO Auto-generated method stub
		return 0;
	}
}