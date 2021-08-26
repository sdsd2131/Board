<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 상세</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<script>
	//댓글 수정창
	function cmUpdateOpen(idx){
		
		window.open("./comment.do?idx="+ idx, "comment", "width=600, height=600, left=700, top=300");
	}
	//댓글 삭제창
	function cmDeleteOpen(idx){
		
		window.open("./delete.do?idx="+ idx, "delete", "width=600, height=600, left=700, top=300");
	}
	//게시물 삭제창
	function boardDelete(idx){
		
		window.open("./boardDelete.do?idx="+ idx, "boardDelete", "width=600, height=600, left=700, top=300");
		
	}
	
	function commentValidate(f){
		if(f.id.value==""){
			alert("작성자를 입력해주세요");
			f.id.focus();
			return false;
		}
		if(f.pass.value==""){
			alert("패스워드를 입력해주세요");
			f.pass.focus();
			return false;
		}
	}
</script>
</head>
<body>
<script>
function Download(){
	$.ajax({
		url : "./download2.do",
		type : "post",
		contentType : "application/x-www-form-urlencoded;charset:utf-8",
		data : { filename : $('#down1').val(),
				oriFileName : $('#down2').val()},
		dataType : "json",
		success : function(d){
			d.mv;
		},
		error : function(error){
			alert("error = "+ error);
		}
	});
}
</script>
<div class="container">
	<form name="viewFrm" method="post" action='<c:url value="./download.do"/>'
		enctype="multipart/form-data">
	<input type="hidden" name="idx" id="idx" value="${view.num }" />
	<input type="hidden" name="nowPage" id="nowPage" value=${nowPage } />
	<input type="hidden" name="down1" id="down1" value=${view.filename } />
	<input type="hidden" name="down2" id="down2" value=${view.originalFile } />
	<br />
	<div class="row">
		<div style="margin-left: 32px;">
			<h5 style="margin-left: 5px;">boardView</h5>
			<h2>게시판 상세페이지</h2>
		</div>
	</div><br /><br />
	<!-- 상세내용 -->
	<div class="col-12">
		<table class="table" style="width:83%;">
			<colgroup>
				<col width="55%"/>
				<col width="25%"/>
				<col width="20%"/>
			</colgroup>
			<thead class="thead-dark">
				<tr>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>${view.title }</td>
					<td>${view.id }</td>
					<td>${view.regidate }</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-10">
		<hr size="13px"/>
	</div>
	<div class="row">
		<div class="col-10">
			<div class="form-group" style="overflow:auto;
				height:500px; padding:12px; margin-left:13px;">
				${view.content }
			</div>
		</div>
	</div>
	<div class="col-10">
		<hr />
	</div>
	<div class="row">
		<div class="col-10">
			<c:choose>
				<c:when test="${view.filename eq null }">
					<span style="margin-left:15px;">첨부파일이 없습니다.</span>
				</c:when>
				<c:otherwise>
					<div style="margin-bottom:20px;">
						<span style="border-bottom: solid 1px; font-size:24px; ">
							첨부파일
						</span>
					</div>
					<div>
					<ul>
						<li>
							파일명 : ${view.originalFile }
							&nbsp;&nbsp;
							<button type="submit" class="btn btn-secondary"
								style="height:25pt;">다운로드</button>
						</li>
					</ul>
					</div>
					<br />
					<c:if test='${fileSub eq ".jpg" or ".img" or ".png" }'>
						<img src="${view.filename }" alt="사진" width="250px" height="250px" />
					</c:if>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	<div class="d-flex flex-row-reverse" style="margin-top: 30px;">
		<div style="margin-right:200px;">
			<button type="button" class="btn btn-secondary"
				onclick="boardDelete(${view.num});">
				삭제하기
			</button>
		</div>
		<div style="margin-right:10px;">
			<button type="button" class="btn btn-secondary"
				onclick="location.href='./modify.do?idx=${view.num}&nowPage=${nowPage }'">
				수정하기
			</button>
		</div>
		<div style="margin-right:10px;">
			<button type="button" class="btn btn-secondary"
				onclick="location.href='./list.do?nowPage=${nowPage}'">
				목록
			</button>
		</div>
	</div>
	</form>
	<div class="col-10">
		<hr size="13px"/>
	</div>
	
	<br /><br />
	<!-- Comment -->
	<div class="row">
		<div class="col-10">
			<h5>Comment</h5><br />
		</div>
	</div>
	<form method="post" name="commentFrm" action='<c:url value="./commentGo.do"/>'
		onsubmit="return commentValidate(this);">
		<input type="hidden" name="board_idx2" value="${view.num }" />
	<div class="row">
		<div class="col-3">
			<label>작성자</label>
			<input type="text" class="form-control" name="id" value="" style="font-size:16px;" />
		</div>
		<div class="col-3">
			<label>패스워드</label>
			<input type="password" class="form-control" name="pass" value="" style="font-size:16px;" />
		</div>
	</div>
	<br />
	<div class="row">
		<div class="col-6">
			<label>댓글작성</label>
			<textarea class="form-control" rows="3" name="content"></textarea>
		</div>
		<div class="col-4">
			<button type="submit" class="btn btn-secondary" style="margin-top:80px; width:60pt;">
				등록
			</button>
		</div>
	</div>
	<br />
	<table class="table" style="width:83%;">
	<colgroup>
		<col width="15%"/>
		<col width="75%"/>
		<col width="20%"/>
		<col width="20%"/>
	</colgroup>
    <thead>
		<tr>
		  <th>작성자</th>
		  <th colspan="2">내용</th>
		  <th></th>
		</tr>
    </thead>
    <tbody>
    	<c:forEach items="${comments }" var="com">
		<tr>
		  <td>${com.id }</td>
		  <td colspan="2">
		  	<div style="overflow: auto; height:78px;">
		  		${com.content }
		  	</div>
		  </td>
		  <td>
		  	<button type="button" class="btn btn-secondary" style="width:50pt;" onclick="cmUpdateOpen(${com.num})">
				수정
			</button>
			<button type="button" class="btn btn-secondary" style="width:50pt; margin-top:3px;" onclick="cmDeleteOpen(${com.num})">
				삭제
			</button>
		  </td>
		</tr>
    	</c:forEach>
    </tbody>
	</table>
	</form>
	<br /><br /><br /><br /><br /><br />
</div>

</body>
</html>