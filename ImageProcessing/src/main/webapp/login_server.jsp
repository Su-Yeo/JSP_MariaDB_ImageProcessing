<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
<%@ include file="dbconn.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String u_id = request.getParameter("u_id");
String u_pass = request.getParameter("u_pass");


ResultSet rs = null; //조회결과의 더미
Statement stmt = conn.createStatement(); //SQL을 실을 트럭준비
//SELECT u_id, u_pass, u_grade FROM user_table WHERE u_id='';
String sql = "SELECT u_id, u_pass, u_grade FROM user_table WHERE u_id='";
sql += u_id + "'";

rs = stmt.executeQuery(sql); //트럭에 짐을 실어서 다리건너 부어 넣기

String u_id2="";
String u_pass2="";
String u_grade="";
while(rs.next()){
	u_id2 = rs.getString("u_id");
	System.out.println(u_id2);
	u_pass2 = rs.getString("u_pass");
	u_grade = rs.getString("u_grade");
}
if(u_id2.equals("")){
	out.println("<script>");
	out.println("alert('존재하지 않는 아이디 입니다.');");
	out.println("location.href='login.jsp'");
	out.println("</script>");
}else if(!u_pass.equals(u_pass2)){
	out.println("<script>");
	out.println("alert('비밀번호가 맞지 않습니다.');");
	out.println("location.href='login.jsp'");
	out.println("</script>");
}else{
	session.setAttribute("u_id", u_id); //세션 정보 설정
	session.setAttribute("u_pass", u_pass); //세션 정보 설정
	session.setAttribute("u_grade", u_grade); //세션 정보 설정
	out.println("<script>");
	out.println("location.href='index.jsp'");
	out.println("</script>");
}

	if (rs != null)
		rs.close();
	if (stmt != null)
		stmt.close();
	if (conn != null)
		conn.close();
%>
</body>
</html>