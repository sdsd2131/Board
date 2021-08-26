<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

	<script>
		function Close(){
			window.close();
		}
		function Validate(){
			var f = eval("document.deleteFrm");
			if(f.pass.value==""){
				alert("패스워드를 입력해주세요");
				f.pass.focus();
				return false;
			}
			if($('#pass').val()!=$('#password').val()){
				alert("패스워드가 틀렸습니다");
				f.pass.focus();
				return false;
			}
			$.ajax({
				url : "./commentDelete.do",
				type : "post",
				contentType : "application/x-www-form-urlencoded;charset:utf-8",
				data : { idx : $('#idx').val()},
				dataType : "json",
				success : function sucFunc(d){
					alert("삭제되었습니다.");
					window.opener.location.reload();
					window.close();
				},
				error : function errFunc(error){
					alert("error : "+ error);
				}
			});
		}
	</script>
</head>
<body>
<div class="container">
	<br /><br />
	<form name="deleteFrm" method="post">
	<input type="hidden" name="idx" id="idx" value=${delete.num } />
	<input type="hidden" name="password" id="password" value=${delete.pass } />
	<input type="hidden" name="board_idx" id="board_idx" value=${delete.board_idx } />
	<div class="row">
		<div class="col-2"></div>
		<div class="col-6">
			<label>비밀번호를 입력해주세요</label>
			<input type="password" class="form-control" value="" style="font-size:16px;"
				name="pass" id="pass" />
		</div>
		<div class="col-2"></div>
	</div>	
	<div class="row">
		<div class="col-2"></div>
		<div class="col-6">
			<div class="d-flex flex-row-reverse" style="margin-top:15px;">
				<div>
					<button type="button" class="btn btn-secondary" 
						onclick="Close();">
						취소
					</button>
				</div>
				<div style="margin-right:5px;">
					<a class="btn btn-secondary" onclick="Validate();">
						등록
					</a>
				</div>
			</div>
		</div>
		<div class="col-2"></div>
	</div>
	</form>
</div>	
</body>
</html>