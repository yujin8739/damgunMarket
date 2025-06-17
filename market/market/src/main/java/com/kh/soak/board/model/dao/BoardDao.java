package com.kh.soak.board.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.soak.board.model.vo.Board;

@Repository
public class BoardDao {
    
    // 공지사항 전체 목록 조회
    public List<Board> selectBoardList(SqlSessionTemplate sqlSession) {
        return sqlSession.selectList("boardMapper.selectBoardList");
    }
    
    // 공지사항 상세 조회
    public Board selectBoard(SqlSessionTemplate sqlSession, int noticeNum) {
        return sqlSession.selectOne("boardMapper.selectBoard", noticeNum);
    }
    
    // 공지사항 등록
    public int insertBoard(SqlSessionTemplate sqlSession, Board board) {
        return sqlSession.insert("boardMapper.insertBoard", board);
    }
    
    // 공지사항 수정
    public int updateBoard(SqlSessionTemplate sqlSession, Board board) {
        return sqlSession.update("boardMapper.updateBoard", board);
    }
    
    // 공지사항 삭제
    public int deleteBoard(SqlSessionTemplate sqlSession, int noticeNum) {
        return sqlSession.delete("boardMapper.deleteBoard", noticeNum);
    }
    
    // 공지사항 검색
    public List<Board> searchBoard(SqlSessionTemplate sqlSession, String keyword) {
        return sqlSession.selectList("boardMapper.searchBoard", keyword);
    }
}