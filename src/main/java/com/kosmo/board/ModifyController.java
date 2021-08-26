package com.kosmo.board;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import DAO.BoardDAOImpl;
import DTO.BoardDTO;

@Controller
public class ModifyController {
	
	@Autowired
	private SqlSession sqlSession;
	
	public static String getUuid() {
		String uuid = UUID.randomUUID().toString();
		System.out.println("생성된UUID-1:"+ uuid);
		uuid = uuid.replaceAll("-", "");
		System.out.println("생성된UUID-2:"+ uuid);
		return uuid;
	}
	
	//글 수정 페이지
	@RequestMapping("/board/modify.do")
	public String Modify(Model model, HttpServletRequest req) {
		
		//절대경로
		String path = req.getContextPath();
		
		int idx = Integer.parseInt(req.getParameter("idx"));
		String nowPage = req.getParameter("nowPage");
		String fileSub = null;
		
		BoardDTO modify = sqlSession.getMapper(BoardDAOImpl.class)
				.boardModify(idx);
		
		if(modify.getFilename()==null) {
			
		}
		else {
			modify.setFilename(path+ "/resources/upload/"+ modify.getFilename());
			fileSub = modify.getFilename().substring(modify.getFilename().lastIndexOf('.'));
		}
		
		
		model.addAttribute("fileSub", fileSub);
		model.addAttribute("modify", modify);
		model.addAttribute("nowPage", nowPage);
		
		return "board/modify";
	}
	
	//글 수정처리
	@RequestMapping(value="/board/modifyAction.do", method=RequestMethod.POST)
	public String modifyAction(Model model, MultipartHttpServletRequest req) {
		
		//물리적경로
		String path = req.getSession().getServletContext().getRealPath("/resources/upload");
		
		int idx2 = Integer.parseInt(req.getParameter("idx"));
		String nowPage = req.getParameter("nowPage");
		
		try {
			
			Iterator itr = req.getFileNames();
			
			MultipartFile mfile = null;
			String fileN = "";
			List resultList = new ArrayList();
			
			//폼값
			String id = req.getParameter("id");
			String title = req.getParameter("title");
			String content = req.getParameter("content");
			int idx = Integer.parseInt(req.getParameter("idx"));
			String filename = null;
			String originalName = null;
			
			File directory = new File(path);
			if(!directory.isDirectory()) {
				directory.mkdirs();
			}
			
			//업로드 폼의 file필드 갯수만큼 반복
			while(itr.hasNext()) {
				fileN = (String)itr.next();
				System.out.println("fileN = "+ fileN);
				mfile = req.getFile(fileN);
				System.out.println("mfile = "+ mfile);
				
				//한글깨짐방지
				originalName = new String(mfile.getOriginalFilename().getBytes(), "UTF-8");
				
				//서버로 전송된 파일이 없다면 while문의 처음으로 이동
				if("".equals(originalName)) {
					continue;
				}
				
				//파일명에서 확장자 가져오기
				String ext = originalName.substring(originalName.lastIndexOf("."));
				//UUID를 통해 생성한 문자열과 확장자를 합침
				String saveFileName = getUuid() + ext;
				//물리적 경로에 저장
				File serverFullName = new File(path + File.separator + saveFileName);
				
				//서버저장
				if(fileN.equals("filename")) {
					filename = saveFileName;
				}
				mfile.transferTo(serverFullName);
			}
			//첨부파잁X
			if(filename==null) {
				int result = sqlSession.getMapper(BoardDAOImpl.class)
					.modifyAction(id, title, content, idx);
				System.out.println("파일X = "+ result);
				
				model.addAttribute("idx", idx);
			}
			else {
				int result2 = sqlSession.getMapper(BoardDAOImpl.class)
					.modifyAction2(id, title, content, filename, originalName, idx);
				System.out.println("파일O = "+ result2);
				
				model.addAttribute("idx", idx);
				model.addAttribute("nowPage", nowPage);
			}
		}
		catch(IOException e) {
			e.printStackTrace();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:/board/view.do";
	}
	
	//글 수정시 기존 첨부파일 삭제
	@RequestMapping(value="/board/fileDelete.do")
	@ResponseBody
	public Map<String, Object> fileDelete(HttpServletRequest req){
		
		Map<String, Object> map = new HashMap<String, Object>();
		int idx = Integer.parseInt(req.getParameter("idx"));
		String filename = req.getParameter("filename");
		
		try {
			int result = sqlSession.getMapper(BoardDAOImpl.class)
				.fileDelete(idx);
			
			map.put("result", result);
			System.out.println(result);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return map;
	}
}
