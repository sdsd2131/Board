<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 수정</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
	<script>
		function self(){
			window.close();
		}
		function Validate(){
			var f = eval("document.modiFrm")
			if(f.pass.value==""){
				alert("패스워드를 입력해주세요");
				f.pass.focus();
				return false;
			}
			if(f.pass.value!=f.password.value){
				alert("패스워드가 틀렸습니다.");
				f.pass.focus();
				return false;
			}
			console.log($("#content"));
			$.ajax({
				url : "./commentAction.do",
				type : "post",
				contentType : "application/x-www-form-urlencoded;charset:utf-8",
				data : { idx : $('#idx').val(),
					content : $('#content').val()},
				dataType : "json",
				success: function sucFunc(d){
					alert("수정되었습니다.");
					window.opener.location.reload();
					window.close();
				},
				error: function errFunc(error){
					alert("error : "+ error);
				}
			});
		}
	</script>
</head>
<body>
<div class="container">
	<br /><br />
	<form name="modiFrm" method="post">
	<input type="hidden" name="idx" id="idx" value="${modify.num }" />
	<input type="hidden" name="password" id="password" value="${modify.pass }" />
	<input type="hidden" name="board_idx" id="board_idx" value="${modify.board_idx }" />
	<div class="row">
		<div class="col-5">
			<label>작성자</label>
			<input type="text" class="form-control" value="${modify.id }" readonly
				style="font-size: 16px;" name="id"/>
		</div>
		<div class="col-5">
			<label>패스워드</label>
			<input type="password" class="form-control" value="" style="font-size:16px;"
				name="pass" />
		</div>
	</div>
	<div class="row">
		<div class="col-10">
			<label>내용</label>
			<textarea name="content" id="content" class="form-control" rows="10">${modify.content }</textarea>
			<div class="d-flex flex-row-reverse" style="margin-top: 15px;">
				<div>
					<button type="button" class="btn btn-secondary"
						onclick="self();">
						취소
					</button>
				</div>
				<div style="margin-right: 5px;">
					<a class="btn btn-secondary" onclick="Validate();">
						등록
					</a>
				</div>
			</div>
		</div>
	</div>
	</form>
</div>
</body>
</html>