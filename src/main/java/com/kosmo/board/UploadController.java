package com.kosmo.board;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import DAO.BoardDAOImpl;

@Controller
public class UploadController {
	
	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping("/board/write.do")
	public String Write(Model model) {
		
		return "board/write";
	}
	
	public static String getUuid() {
		String uuid = UUID.randomUUID().toString();
		System.out.println("생성된UUID-1:"+ uuid);
		uuid = uuid.replaceAll("-", "");
		System.out.println("생성된UUID-2:"+ uuid);
		return uuid;
	}
	
	//파일업로드 처리
	@RequestMapping(value="/board/writeAction.do", method=RequestMethod.POST)
	public String writeAction(Model model, MultipartHttpServletRequest req) {
		
		//서버의 물리적경로 얻어오기
		String path = req.getSession().getServletContext().getRealPath("/resources/upload");
		System.out.println(path);
		
		try {
			//업로드폼의 file속성의 필드를 가져온다.
			Iterator itr = req.getFileNames();
			
			MultipartFile mfile = null;
			String fileN = "";
			List resultList = new ArrayList();
			
			//파일외에 폼값 받음
			String id = req.getParameter("id");
			String pass = req.getParameter("pass");
			String title = req.getParameter("title");
			String content = req.getParameter("content");
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
				
				//한글깨짐방지 처리 후 파일 가져오기
				originalName = new String(mfile.getOriginalFilename().getBytes(), "UTF-8");
				//서버로 전송된 파일이 없다면 while문의 처음으로 이동
				if("".equals(originalName)) {
					continue;
				}
				
				//파일명에서 확장자를 가져옴
				String ext = originalName.substring(originalName.lastIndexOf('.'));
				//UUID를 통해 생성한 문자열과 확장자를 합침
				String saveFileName = getUuid() + ext;
				//물리적 경로에 파일 저장
				File serverFullName = new File(path + File.separator + saveFileName);
				
				
				//서버 저장
				if(fileN.equals("filename")) {
					filename = saveFileName;
				}
				mfile.transferTo(serverFullName);
				
			}
			originalName = originalName.replaceAll(" ", "");
			//첨부파일X
			if(filename==null) {
				int result = sqlSession.getMapper(BoardDAOImpl.class)
					.writeAction(title, content, id, pass);
				System.out.println("파일X = "+ result);
			} 
			else {
				int result2 = sqlSession.getMapper(BoardDAOImpl.class)
					.writeAction2(title, content, id, pass, filename, originalName);
				System.out.println("파일O = "+ result2);
			}
			
		}
		catch(IOException e) {
			e.printStackTrace();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:list.do";
	}
	
}
