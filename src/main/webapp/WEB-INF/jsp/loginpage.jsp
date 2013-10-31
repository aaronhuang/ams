<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Activity Management System</title>
<link rel="stylesheet" href="/ams/resources/bootstrap/css/bootstrap.css">
</head>
<body>

<div class="container-fluid" align="center">
	
	<form action="../../j_spring_security_check" method="post" >
	  	<div class="row-fluid">
	    	<div class="span13">
		    	<h3>Login</h3>
				<table>
				  	<tr>
				  		<td width="30%"><label for="j_username">Username:</label></td>
				  		<td width="70%"><input id="j_username" name="j_username" type="text" placeholder="Enter username" autofocus/></td>
				  	</tr>
				  	<tr>
				  		<td><label for="j_password">Password:</label></td>
				  		<td><input id="j_password" name="j_password" type="password" placeholder="Enter password"/></td>
				  	</tr>
			  	</table>
	  		</div>
		</div>
		<span id="login-error" class="alert-error">${error}</span>
		<div>
			<input  class="btn btn-info" type="submit" value="Login"/>	
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input  class="btn btn-info" type="button" value="Register" onclick="javascript:window.location='/ams/web/register'"/>	
		</div>	
	</form>
	</div>

</body>
</html>