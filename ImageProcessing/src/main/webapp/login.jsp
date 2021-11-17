<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인</title>
<link rel="stylesheet" type="text/css" href="semantic/semantic.css">
<script src="https://code.jquery.com/jquery-3.1.1.min.js" integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8=" crossorigin="anonymous"></script>
<script src="semantic/semantic.js"></script>
<style type="text/css">
	body {
	  background-color: #373B44;
	}
	body > .grid {
	  height: 100%;
	}
	.column {
	  max-width: 450px;
	}
</style>
<script>
$(document).ready(function() {
	$('.ui.form').form({
	    fields: {
	        email: {
	            identifier: 'u_id',
	            rules: [{
	                    type: 'empty',
	                    prompt: '아이디를 입력해주세요'
	                }
	            ]
	        },
	        password: {
	            identifier: 'u_pass',
	            rules: [{
	                    type: 'empty',
	                    prompt: '비밀번호를 입력해주세요'
	                },
	                {
	                    type: 'length[4]',
	                    prompt: '비밀번호는 4~10자리 입니다'
	                }
	            ]
	        }
	    }
	});
});
</script>
</head>
<body>
<div class="ui middle aligned center aligned grid">
  <div class="column">
    <h2 style="color:#4ECDC4">
      <span class="content">
        로그인
      </span>
    </h2>
	<form class="ui large form" method="post" action="login_server.jsp">
      <div class="ui stacked segment">
        <div class="field">
          <div class="ui left icon input">
            <i class="user icon"></i>
            <input type="text" name="u_id" placeholder="ID">
          </div>
        </div>
        <div class="field">
          <div class="ui left icon input">
            <i class="lock icon"></i>
            <input type="password" name="u_pass" placeholder="Password">
          </div>
        </div>
        <input class="ui fluid large teal submit button" style="background-color:#4ECDC4" type="submit" value="로그인">
      </div>

      <div class="ui error message"></div>

    </form>

    <div class="ui message">
      New to us? <a href="signUp.jsp">회원가입</a>
    </div>
  </div>
</div>
</body>
</html>