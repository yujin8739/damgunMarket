package com.kh.soak.board.model.service;

import java.util.List;

import com.kh.soak.board.model.vo.Board;

public interface BoardService {
    
    // 공지사항 전체 목록 조회
    List<Board> selectBoardList();
    
    // 공지사항 상세 조회
    Board selectBoard(int noticeNum);
    
    // 공지사항 등록
    int insertBoard(Board board);
    
    // 공지사항 수정
    int updateBoard(Board board);
    
    // 공지사항 삭제
    int deleteBoard(int noticeNum);
    
    // 공지사항 검색
    List<Board> searchBoard(String keyword);
}