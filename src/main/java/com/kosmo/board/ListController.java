package com.kosmo.board;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import DAO.BoardDAOImpl;
import DTO.BoardDTO;
import DTO.CommentDTO;
import DTO.ParameterDTO;
import util.PagingUtil;

@Controller
public class ListController {
	
	@Autowired
	private SqlSession sqlSession;
	
	//게시판 리스트
	@RequestMapping("/board/list.do")
	public String List(Model model, HttpServletRequest req) {
		
		//파라미터 저장을 위한 DTO객체 생성
		BoardDTO boardDTO = new BoardDTO();
		ParameterDTO parameterDTO = new ParameterDTO();
		
		//게시물의 갯수를 카운트
		int totalRecordCount = sqlSession.getMapper(BoardDAOImpl.class)
				.getTotalCount();
		
		int pageSize = 5;
		int blockPage = 4;
		
		int totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);
		
//		int nowPage = req.getParameter("nowPage")==null ? 1 :
//			Integer.parseInt(req.getParameter("nowPage"));
		
		int nowPage = (req.getParameter("nowPage")==null || req.getParameter("nowPage").equals(""))
				? 1 : Integer.parseInt(req.getParameter("nowPage"));
		model.addAttribute("nowPage", nowPage);
		
		int start = (nowPage-1) * pageSize + 1;
		int end = nowPage * pageSize;
		
		boardDTO.setStart(start);
		boardDTO.setEnd(end);
		
		ArrayList<BoardDTO> lists = sqlSession.getMapper(BoardDAOImpl.class)
				.listPage(start, end);
		
		String sql = sqlSession.getConfiguration()
				.getMappedStatement("listPage")
				.getBoundSql(boardDTO).getSql();
				
		
		String pagingImg = PagingUtil.pagingImg(totalRecordCount, pageSize,
				blockPage, nowPage, req.getContextPath()
				+ "/board/list.do?");
		model.addAttribute("pagingImg", pagingImg);
		
		for(BoardDTO dto : lists) {
			String temp = dto.getContent().replace("/r/n", "<br/>");
			dto.setContent(temp);
		}
		
		model.addAttribute("lists", lists);
		return "board/list";
	}
	
	//게시판 상세
	@RequestMapping("/board/view.do")
	public String View(Model model, HttpServletRequest req) {
		
		//절대경로
		String path = req.getContextPath();
		
		int board_idx = Integer.parseInt(req.getParameter("idx")); 
		String fileSub = null;
		
		//Mapper호출
		BoardDTO view = sqlSession.getMapper(BoardDAOImpl.class)
				.boardView(Integer.parseInt(req.getParameter("idx")));
		
		String temp = null;
		if(view.getContent()!=null) {
			temp = view.getContent().replace("\r\n", "<br/>");
		}
		view.setContent(temp);
		
		if(view.getFilename()==null) {
		}
		else {
			view.setFilename(path+ "/resources/upload/"+ view.getFilename());
			fileSub = view.getFilename().substring(view.getFilename().lastIndexOf('.'));
		}
		
		
		ArrayList<CommentDTO> comments = sqlSession.getMapper(BoardDAOImpl.class)
				.mComment(board_idx);
		
		int nowPage = (req.getParameter("nowPage")==null || req.getParameter("nowPage").equals(""))
				? 1 : Integer.parseInt(req.getParameter("nowPage"));
		
		model.addAttribute("fileSub", fileSub);
		model.addAttribute("nowPage", nowPage);
		model.addAttribute("comments", comments);
		model.addAttribute("view", view);
		
		
		return "board/view";
	}
	
	//게시물 삭제페이지
	@RequestMapping("/board/boardDelete.do")
	public String boardDelete(Model model, HttpServletRequest req) {
		
		int idx = Integer.parseInt(req.getParameter("idx"));
		
		BoardDTO viewDel = sqlSession.getMapper(BoardDAOImpl.class)
			.boardView(idx);
		
		model.addAttribute("viewDel", viewDel);
		
		return "board/boardDelete";
	}
	
	//게시물 삭제처리
	@RequestMapping(value="/board/boardDeleteAction.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> boardDeleteAction(HttpServletRequest req){
		
		Map<String, Object> map = new HashMap<String, Object>();
		int idx = Integer.parseInt(req.getParameter("idx"));
		
		try {
			
			int result2 = sqlSession.getMapper(BoardDAOImpl.class)
					.commentDelete2(idx);
			int result = sqlSession.getMapper(BoardDAOImpl.class)
				.boardDelete(idx);
			
			map.put("result2", result2);
			map.put("result", result);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	
}
