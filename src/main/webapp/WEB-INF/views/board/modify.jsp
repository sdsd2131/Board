<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 수정하기</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>

<script>
var modiValidate = function(f){
	
	var pw = $('#pass').val();
	
	if(f.id.value==""){
		alert("작성자를 입력해주세요.");
		f.id.focus();
		return false;
	}
	if(f.title.value==""){
		alert("제목을 입력해주세요.");
		f.title.focus();
		return false;
	}
	if(f.content.value==""){
		alert("내용을 입력해주세요.");
		f.content.focus();
		return false;
	}
	if(pw.search(/\s/) != -1){
		alert("비밀번호는 공백 없이 입력해주세요");
		f.pass.focus();
		return false;
	}
	if(f.pass.value!=f.ps.value){
		alert("비밀번호가 잘못되었습니다.");
		f.pass.focus();
		return false;
	}
	else if(f.pass.value=""){
		alert("비밀번호를 입력해주세요.");
		f.pass.focus();
		return false;
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

function Delete(){
	
	$.ajax({
		url : "./fileDelete.do",
		type : "post",
		contentType : "application/x-www-form-urlencoded;charset:utf-8",
		data : { idx : $('#idx').val(),
				filename : $('#fileD').val() },
		dataType : "json",
		success : function(d){
			alert("첨부파일 삭제되었습니다.");
			location.reload();
		},
		error : function(d){
			alert("error = "+ d);
		}
	});
}
</script>

<div class="container">
	<br />
	<div class="row">
		<div style="margin-left: 15px;">
			<h5 style="margin-left: 3px;">boardModify</h5>
			<h2>게시판 수정</h2>
		</div>
	</div><br /><br />
	
	<!-- 상세내용 -->
	<form method="post" name="modiform" enctype="multipart/form-data"
		action='<c:url value="/board/modifyAction.do"/>'
		onsubmit="return modiValidate(this);">
	<div class="row">
	<input type="hidden" name="idx" id="idx" value="${modify.num }" />
	<input type="hidden" name="ps" id="ps" value="${modify.pass }" />
	<input type="hidden" name="nowPage" id="nowPage" value=${nowPage } />
	<input type="hidden" name="fileD" id="fileD" value=${modify.filename } />
		<div class="col-5">
			<div class="form-group">
				<label>제목</label>
				<input type="text" class="form-control" name="title"
					value="${modify.title }" style="font-size: 16px;" />
			</div>
		</div>
		<div class="col-5">
			<div class="form-gorup">
				<label>작성자</label>
				<input type="text" class="form-control" name="id"
					value="${modify.id }" style="font-size: 16px;" />
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-5">
			<div class="form-group">
				<label>비밀번호</label>
				<input type="password" class="form-control" name="pass" id="pass"
					value="" style="font-size: 16px;" />
			</div>
		</div>
		<div class="col-5">
			<div class="form-group">
				<label>작성일</label>
				<input type="text" class="form-control" name="regidate"
					value="${modify.regidate }" readonly style="font-size: 16px;" />
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
			<div class="form-group">
				<textarea class="form-control" rows="10" id="content"
					name="content">${modify.content }</textarea>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-10">
			<br />
			<c:choose>
				<c:when test="${modify.filename eq null }">
				<div>
					<ul>
						<li style="margin-left:15px;">기존 첨부파일이 없습니다.</li>
					</ul>
				</div>
				</c:when>
				<c:otherwise>
				<div>
					기존파일 : &nbsp;&nbsp;
					${modify.originalFile } &nbsp;
					<i class='far fa-trash-alt' style="cursor:pointer;"
						id="fileDelete" onclick="Delete();"></i>
					<br />
					<c:if test='${fileSub eq ".jpg" or ".img" or ".png" }'>
						<img src="${modify.filename }" alt="사진" width="250px" height="250px"
						style="margin-top:10px;" />
					</c:if>
				</div>
				</c:otherwise>
			</c:choose>
			<br />
			<div>
				<input type="file" class="form-control" name="filename" id="input_file"
					style="cursor:pointer;"/>
				<img id="img_preview" class="inline-block"/>
			</div>
		</div>
	</div>
	<div class="d-flex flex-row-reverse" style="margin-top: 30px;">
		<div style="margin-right:200px;">
			<button type="submit" class="btn btn-secondary">
				수정
			</button>
		</div>
		<div style="margin-right:10px;">
			<button type="button" class="btn btn-secondary"
				onclick="location.href='./view.do?idx=${modify.num}'">
				취소
			</button>
		</div>
	</div>
	</form>
</div>
</body>
</html>