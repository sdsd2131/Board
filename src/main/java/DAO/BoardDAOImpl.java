package DAO;

import java.util.ArrayList;

import DTO.BoardDTO;
import DTO.CommentDTO;

public interface BoardDAOImpl {
	
	//게시판 리스트
	public ArrayList<BoardDTO> boardList();
	//상세페이지
	public BoardDTO boardView(int num);
	//게시글 삭제처리
	public int boardDelete(int num);
	//수정페이지
	public BoardDTO boardModify(int num);
	//수정처리(파일X)
	public int modifyAction(String id, String title,
		String content, int num);
	//수정처리(파일O)
	public int modifyAction2(String id, String title,
		String content, String filename,String originalFile , int num);
	//글쓰기처리(첨부파일X)
	public int writeAction(String title, String content,
		String id, String pass);
	//글쓰기처리(첨부파일O)
	public int writeAction2(String title, String content,
		String id, String pass, String filename, String originalFile);
	
	public int getTotalCount();
	public ArrayList<BoardDTO> listPage(int s, int e);
	
	//댓글 리스트
	public ArrayList<CommentDTO> mComment(int board_idx);
	//댓글입력
	public int commentGo(int board_idx, String id, String pass,
			String content);
	//댓글수정
	public CommentDTO commentModify(int num);
	//댓글수정처리
	public int commentAction(String content, int num);
	//댓글 삭제처리
	public int commentDelete(int num);
	//게시물 삭제시 댓글도 같이 삭제
	public int commentDelete2(int board_idx);
	
	//글수정 페이지에서 기존 첨부파일 삭제
	public int fileDelete(int num);
}
