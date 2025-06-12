package com.kh.soak.board.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.soak.board.model.dao.BoardDao;
import com.kh.soak.board.model.vo.Board;

@Service
public class BoardServiceImpl implements BoardService {
    
    @Autowired
    private BoardDao dao;
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    @Override
    public List<Board> selectBoardList() {
        return dao.selectBoardList(sqlSession);
    }
    
    @Override
    public Board selectBoard(int noticeNum) {
        return dao.selectBoard(sqlSession, noticeNum);
    }
    
    @Override
    public int insertBoard(Board board) {
        return dao.insertBoard(sqlSession, board);
    }
    
    @Override
    public int updateBoard(Board board) {
        return dao.updateBoard(sqlSession, board);
    }
    
    @Override
    public int deleteBoard(int noticeNum) {
        return dao.deleteBoard(sqlSession, noticeNum);
    }
    
    @Override
    public List<Board> searchBoard(String keyword) {
        return dao.searchBoard(sqlSession, keyword);
    }
}