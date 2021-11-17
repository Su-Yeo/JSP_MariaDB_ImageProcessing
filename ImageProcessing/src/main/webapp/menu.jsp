<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<form name='fileForm' method='post' action='loadImage.jsp' enctype='multipart/form-data'>
<div class="ui huge menu" style="background-color:#373B44;">
	<div class="ui dropdown item">
		<div id="draw">메뉴<i class="dropdown icon"></i></div>
   		<div id="drawMenu" class="menu">
     		<div class="item"><input type='file' name='filename' onchange="loadImage()"></div>
     		<%
     			String u_grade = (String)session.getAttribute("u_grade");
				String outName = (String)session.getAttribute("outName");
				if(outName!=null && u_grade!=null && !u_grade.equals("C")){ 
					String url="http://192.168.56.102:8080/ImgProcessing/download.jsp?file=";
				%>
					<a class="item" href="<%=url+outName%>">저장하기</a>
				<%}else if(u_grade!=null && u_grade.equals("C")){%>
					<a class="item" onclick="alert('구독자만 가능합니다.');">저장하기</a>
				<%}else{%>
					<a class="item" onclick="msg('로그인이 필요한 서비스입니다.');">저장하기</a>
				<%}%>
   		</div>
   	</div>
    <div class="item" onclick="selectAlgorithm(101);">반전</div>
    <div class="item" onclick="selectAlgorithm(102);">밝게/어둡게</div>
    <div class="item" onclick="selectAlgorithm(103);">그레이스케일</div>
    <div class="item" onclick="selectAlgorithm(104);">흑백(127기준)</div>
    <div class="item" onclick="selectAlgorithm(108);">파라볼라</div>
    <div class="item" onclick="selectAlgorithm(202);">축소/확대</div>
    <div class="item" onclick="selectAlgorithm(203);">상하반전</div>
    <div class="item" onclick="selectAlgorithm(204);">좌우반전</div>
    <div class="item" onclick="selectAlgorithm(205);">회전</div>
    <div class="item" onclick="selectAlgorithm(401);">엠보싱</div>
    <div class="item" onclick="selectAlgorithm(402);">블러링</div>
    <div class="item" onclick="selectAlgorithm(408);">경계선</div>
    
  	<div class="right menu">
	<%
	// 세션을 확인해서 통과 여부 시키기
	String u_id = (String)session.getAttribute("u_id");
	String u_pass = (String)session.getAttribute("u_pass");
	if (u_id == null || u_pass == null) {
	%>
		<a class="item" href="login.jsp">로그인</a>
	<%
	}else{
	%>
    	<a class="item" href="logout.jsp">로그아웃</a>
    <%
	}
	%>
	<%
	// 세션을 확인해서 통과 여부 시키기
	if (u_grade != null && u_grade.equals("C")) {
	%>
    	<a class="item" href="updateGrade.jsp">구독+</a>
    <%
	}else if(u_grade != null && !u_grade.equals("C")){
	%>
		<a class="item">구독중(<%=u_grade %>)</a>
	<%
	}else{
	%>
		<a class="item" onclick="msg('로그인이 필요한 서비스입니다.');">구독+</a>
	<%
	}
	%>
  	</div>
</div>
<input id="submitVal" name="algo" type="text" value="0" style="display:none">
</form>
<script>
$('#draw').hover(function(){
	$('.dropdown').dropdown('show');
	$('#draw').css({"color": "#4ECDC4"});
});
$('#drawMenu').mouseleave(function(){
	$('.dropdown').dropdown('hide');
});
$('#drawMenu').hover(function(){
	$('#draw').css({"color": "#4ECDC4"});
},function(){
	$('#draw').css({"color": "#ffffff"});
});
function loadImage(){
	var form = document.fileForm;
	$("#submitVal").val("0");
	form.submit();
}
function selectAlgorithm(algo){
	var form = document.fileForm;
	$("#submitVal").val(algo);
	form.submit();
}
function msg(txt){
	alert(txt);
	location.href="login.jsp";
}
</script>