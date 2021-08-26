package com.kosmo.board;

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
import DTO.CommentDTO;

@Controller
public class CommentController {
	
	@Autowired
	private SqlSession sqlSession;
	
	//댓글 수정페이지
	@RequestMapping("/board/comment.do")
	public String Comment(Model model, HttpServletRequest req) {
		
		int idx = Integer.parseInt(req.getParameter("idx"));
		
		CommentDTO comModi = sqlSession.getMapper(BoardDAOImpl.class)
				.commentModify(idx);
		
		model.addAttribute("modify", comModi);
		
		return "board/comment";
	}
	
	//댓글 등록
	@RequestMapping(value="/board/commentGo.do", method=RequestMethod.POST)
	public String commentGo(HttpServletRequest req, Model model){
		
		int board_idx = Integer.parseInt(req.getParameter("board_idx2"));
		String id = req.getParameter("id");
		String pass = req.getParameter("pass");
		String content = req.getParameter("content");
		
		int result = sqlSession.getMapper(BoardDAOImpl.class)
			.commentGo(board_idx, id, pass, content);
		System.out.println("result = "+ result);
		
		model.addAttribute("idx", board_idx);
		
		return "redirect:view.do";
	}
	
	//댓글 수정처리
	@RequestMapping(value="/board/commentAction.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> commentAc(HttpServletRequest req){
		
		Map<String, Object> map = new HashMap<String, Object>();
		int idx = Integer.parseInt(req.getParameter("idx"));
		String content = req.getParameter("content");
		try {
			
			int result = sqlSession.getMapper(BoardDAOImpl.class)
					.commentAction(content, idx);
			System.out.println("result : "+ result);
			
			map.put("result", result);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	
	//댓글 삭제확인페이지
	@RequestMapping("/board/delete.do")
	public String Delete(Model model, HttpServletRequest req) {
		
		int idx = Integer.parseInt(req.getParameter("idx"));
		
		CommentDTO delete = sqlSession.getMapper(BoardDAOImpl.class)
			.commentModify(idx);
		
		model.addAttribute("delete", delete);
		
		return "board/delete";
	}
	
	//댓글 삭제처리
	@RequestMapping(value="/board/commentDelete.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> CommentDelete(HttpServletRequest req){
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		int idx = Integer.parseInt(req.getParameter("idx"));
		try {
			
			int result = sqlSession.getMapper(BoardDAOImpl.class)
				.commentDelete(idx);
			
			map.put("result", result);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return map;
	}
}
