package com.kosmo.board;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class FileDownload {
	
	//파일 다운로드
	@RequestMapping(value="/board/download.do", method=RequestMethod.POST)
	public ModelAndView download(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		
		
		String fileName = req.getParameter("down1").substring(req.getParameter("down1").lastIndexOf("/"));
		String oriFileName = new String(req.getParameter("down2").getBytes(), "UTF-8");
		String saveDirectory = req.getSession().getServletContext().getRealPath("/resources/upload");
		File downloadFile = new File(saveDirectory+"/"+fileName);
		
		System.out.println(fileName);
		System.out.println(oriFileName);
		System.out.println(saveDirectory);
		System.out.println(downloadFile);
		
		if(!downloadFile.canRead()) {
			throw new Exception("파일을 찾을수 없습니다.");
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("fileDownloadView");
		mv.addObject("downloadFile", downloadFile);
		mv.addObject("oriFileName", oriFileName);
		return mv;
	}
	
	@RequestMapping(value="/board/download2.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> Download(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		String fileName = req.getParameter("filename").substring(req.getParameter("filename").lastIndexOf("/"));
		String fileName2 = req.getParameter("oriFileName");
		String oriFileName = req.getParameter("oriFileName");
		String oriFileName2 = oriFileName.replace("+", "%20");
		String saveDirectory = req.getSession().getServletContext().getRealPath("/resources/upload");
		File downloadFile = new File(saveDirectory+"/"+fileName);
		
		
		System.out.println(fileName);
		System.out.println(oriFileName);
		System.out.println(saveDirectory);
		System.out.println(downloadFile);
		
		if(!downloadFile.canRead()) {
			throw new Exception("파일을 찾을수 없습니다.");
		}
		
		
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("fileDownloadView");
		mv.addObject("downloadFile", downloadFile);
		mv.addObject("oriFileName", oriFileName2);
		map.put("mv", mv);
		return map;
	}
}

