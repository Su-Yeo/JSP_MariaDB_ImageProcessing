<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
<%@ include file="dbconn.jsp" %>
<%
request.setCharacterEncoding("utf-8");
String u_id = request.getParameter("u_id");
String u_pass = request.getParameter("u_pass");
//String u_grade = request.getParameter("u_grade");
String u_grade = "C"; // grade : A-관리자 B-고급사용자 C-일반사용자

//conn은 교량 개념
Statement stmt = conn.createStatement(); // SQL을 실을 트럭준비
//INSERT INTO user_table(u_id, u_pass, u_grade) VALUES('admin','1234','A');
String sql = "INSERT INTO user_table(u_id, u_pass, u_grade) VALUES('";
sql += u_id + "', '" + u_pass + "', '" +  u_grade + "')";
try{
	stmt.executeUpdate(sql); // 트럭에 짐을 실어서 다리건너 부어 넣기.	
	out.println("<script>");
	out.println("location.href='login.jsp'");
	out.println("</script>");
}catch(SQLException e){
	out.println("<script>");
	out.println("alert('존재하는 아이디 입니다.');");
	out.println("location.href='signUp.jsp'");
	out.println("</script>");
}finally{
	if(stmt != null)
		stmt.close();
	if(conn != null)
		conn.close();
}
%>
</body>
</html>