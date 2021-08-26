<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 리스트</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container">
	<br />
	<div class="row">
		<div style="margin-left: 15px;">
			<h5 style="margin-left: 3px;">boardList</h5>
			<h2>게시판</h2>
			<br />
		</div>
	</div>
	<input type="hidden" name="nowPage" id="nowPage" value="${nowPage }" />
	<table class="table table-hover" style="width:90%;" border="1">
		<colgroup>
			<col width="10%"/>
			<col width="auto"/>
			<col width="15%"/>
			<col width="20%" />
		</colgroup>
		<thead>
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
		</tr>
		</thead>
		<c:forEach items="${lists }" var="list">
		<tbody>
		<tr>
			<input type="hidden" name="idx" id="idx" value="${list.num }" />
			<td>${list.rn }</td>
			<td onclick="location.href='./view.do?idx=${list.num}&nowPage=${nowPage }'" style="cursor:pointer">
				${list.title }
				
			</td>
			<td>${list.id }</td>
			<td>${list.regidate }</td>
		</tr>
		</tbody>
		</c:forEach>
	</table>
	<div class="d-flex flex-row-reverse" style="margin-top: 20px;">
		<div style="margin-right:110px;">
			<button type="button" class="btn btn-secondary"
				onclick="location.href='./write.do'">
				글쓰기
			</button>
		</div>
	</div>
	<br /><br />
	<div>
		<ul class="pagingImg jusify-content-center" style="margin-left:350px;">
			${pagingImg }
		</ul>
	</div>
</div> 
</body>
</html>