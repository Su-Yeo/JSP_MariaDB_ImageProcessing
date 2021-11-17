<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ImageProcessing</title>
<link rel="stylesheet" type="text/css" href="semantic/semantic.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js" integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8=" crossorigin="anonymous"></script>
<script src="semantic/semantic.js"></script>
<style type="text/css">
	body {
	  background-color: #373B44;
	}
	.ui.menu .item {
	  background-color: #373B44;
      color: white;
      font-weight:bold;
	}
	.ui.menu a.item:hover {
      color: #4ECDC4;
	}
	#draw:hover{
      color: #4ECDC4;
	}
	.ui.menu .item:hover {
	  color: #4ECDC4;
	}
	::selection {
	  color: #4ECDC4;
	}
</style>

</head>
<body>
<%@ include file="menu.jsp"%>
<%
String fileName = (String)session.getAttribute("fileName");
//outName = (String)session.getAttribute("outName");
System.out.println("fileName: "+fileName);
System.out.println("outName: "+outName);
if(fileName!=null && outName==null){ %>
<div style="text-align:center; display:grid; place-items:center; min-height:100vh;">
<img src='/Upload/<%=fileName%>'>
</div>
<%}else if(outName!=null){ %>
<div style="text-align:center; display:grid; place-items:center; min-height:100vh;">
<img src='/Out/<%=outName%>'>
</div>
<%} %>
</body>
</html>