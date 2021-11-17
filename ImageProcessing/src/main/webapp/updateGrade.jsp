<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>등급 업데이트</title>
</head>
<body>
<%@ include file="dbconn.jsp" %>
<%
String u_id = (String)session.getAttribute("u_id");

// conn은 교량 개념
Statement stmt = conn.createStatement(); // SQL을 실을 트럭준비
//UPDATE user_table SET u_grade = 'B' WHERE u_id='kim';
String sql = "UPDATE user_table SET u_grade = 'B' WHERE u_id='" + u_id + "';";
stmt.executeUpdate(sql); // 트럭에 짐을 실어서 다리건너 부어 넣기.

if(stmt != null)
	stmt.close();
if(conn != null)
	conn.close();

session.setAttribute("u_grade", "B"); //세션 정보 설정

out.println("<script>");
out.println("location.href='index.jsp'");
out.println("</script>");
%>
</body>
</html>