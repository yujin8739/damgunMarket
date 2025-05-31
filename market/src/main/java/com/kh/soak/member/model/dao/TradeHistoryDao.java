package com.kh.soak.member.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.soak.member.model.vo.Member;
import com.kh.soak.member.model.vo.TradeHistory;

@Repository

public class TradeHistoryDao {
	//로그인 기능
	public List<TradeHistory> myHistory(SqlSessionTemplate sqlSession, int user_No) {
		//sqlSession.selectOne() : 조회구문중 결과값이 하나만 나올때 사용할 수 있는 메소드
				//첫번째 매개변수에는 매퍼별칭.구문키값 으로 해당 구문을 지정한다.
				//두번째 매개변수에는 전달값이 있을경우 해당 전달값을 작성한다.(단, 하나의 전달값만 가능-묶어보내기)
		List<TradeHistory> tradeHistory = sqlSession.selectList("historyMapper.myHistory",user_No);
		return tradeHistory; 
		
	}
	public TradeHistory selectHistory(SqlSessionTemplate sqlSession, int pd_Num) {
		//sqlSession.selectOne() : 조회구문중 결과값이 하나만 나올때 사용할 수 있는 메소드
				//첫번째 매개변수에는 매퍼별칭.구문키값 으로 해당 구문을 지정한다.
				//두번째 매개변수에는 전달값이 있을경우 해당 전달값을 작성한다.(단, 하나의 전달값만 가능-묶어보내기)
		TradeHistory tradeHistory = sqlSession.selectOne("historyMapper.selectHistory",pd_Num);
		return tradeHistory; 
	}
}
