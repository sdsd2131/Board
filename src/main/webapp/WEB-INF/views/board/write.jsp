<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기 페이지</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<script>
var writeValidate = function(f){
	if(f.id.value==""){
		alert("닉네임를 입력하세요.");
		f.id.focus();
		return false;
	}
	if(f.pass.value==""){
		alert("비밀번호를 입력하세요");
		f.pass.focus();
		return false;
	}
	if(f.title.value==""){
		alert("제목을 입력하세요.");
		f.title.focus();
		return false;
	}
	if(f.content.value==""){
		alert("내용을 입력하세요.");
		f.content.focus();
		return false;
	}
	
	//다른 확장자 업로드시 경고창
	if($('#filename').val 1= ""){
		var ext = $('#filename').val().split('.').pop().toLowerCase();
		if($.inArray(ext, ['jpeg', 'jpg', 'png', 'img', 'pdf'])==1){
			alert("지정된 확장자의 파일만 업로드 가능합니다.");
			$('filename').val("");
			return false;
		}
	}
}
</script>
</head>
<body>
<script> 
$.fn.setPreview = function(opt){
	"use strict" 
	var defaultOpt = { 
			inputFile: $(this), 
			img: $('#img_preview'), 
			w: 300, 
			h: 250 
	}; 
	$.extend(defaultOpt, opt); 
	
	var previewImage = function(){ 
		if (!defaultOpt.inputFile || !defaultOpt.img) return; 
		
		var inputFile = defaultOpt.inputFile.get(0); 
		var img = defaultOpt.img.get(0); 
		
		// FileReader 
		if (window.FileReader) { 
			// image 파일만 
			if (!inputFile.files[0].type.match(/image\//)) return; 
			
			// preview 
			try { 
				var reader = new FileReader(); 
				reader.onload = function(e){ 
					img.src = e.target.result; 
					img.style.width = defaultOpt.w+'px'; 
					img.style.height = defaultOpt.h+'px'; 
					img.style.display = ''; 
				} 
				reader.readAsDataURL(inputFile.files[0]);
			} catch (e) { 
				// exception... 
			} 
		// img.filters (MSIE) 
		}else if (img.filters) { 
			inputFile.select(); 
			inputFile.blur(); 
			var imgSrc = document.selection.createRange().text;
			
			img.style.width = defaultOpt.w+'px'; 
			img.style.height = defaultOpt.h+'px'; 
			img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enable='true',sizingMethod='scale',src=\""+imgSrc+"\")"; 
			img.style.display = ''; 
			
		// no support 
		} else { 
			// Safari5, ... 
		} 
	}; 
	
	// onchange 
	$(this).change(function(){ 
		previewImage(); 
	}); 
}; 
		
$(document).ready(function(){ 
	var opt = { 
		img: $('#img_preview'), 
		w: 250, 
		h: 250 
	}; 
	$('#input_file').setPreview(opt); 
});
</script>

<div class="container">
	<br />
	<div class="row">
		<div style="margin-left: 15px;">
			<h5 style="margin-left: 3px;">boardWrite</h5>
			<h2>글쓰기</h2>
		</div>
	</div><br /><br />
	
	<form name="wrtieFrm" method="post" enctype="multipart/form-data"
		onsubmit="return writeValidate(this);"
		action='<c:url value="./writeAction.do"/>'>
	<div class="row">
		<div class="col-5">
			<div class="form-group">
				<label>작성자</label>
				<input type="text" class="form-control" name="id" id="id" value="" />
			</div>
		</div>
		<div class="col-5">
			<div class="form-group">
				<label>비밀번호</label>
				<input type="password" class="form-control" name="pass" id="pass" value="" />
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-5">
			<div class="form-group">
				<label>제목</label>
				<input type="text" class="form-control" name="title" id="title" value="" />
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-5">
			<label>내용</label>
		</div>
	</div>
	<div class="row">
		<div class="col-10">
			<textarea class="form-control" rows="10"
				id="content" name="content"></textarea>
		</div>
	</div>
	<div class="row">
		<div class="col-5">
			<input type="file" class="form-control" name="filename" id="input_file"/>
			<img id="img_preview" class="inline-block"/>
		</div>
	</div>
	
	<div class="d-flex flex-row-reverse" style="margin-top: 30px;">
		<div style="margin-right:200px;">
			<button type="submit" class="btn btn-secondary">
				등록하기
			</button>
		</div>
		<div style="margin-right:10px;">
			<button type="button" class="btn btn-secondary"
			onclick="location.href='./list.do'">
				취소
			</button>
		</div>
	</div>
	</form>
</div>
</body>
</html>