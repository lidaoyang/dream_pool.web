<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="viewport" content="width=device-width"/>
<link rel="shortcut icon" href="${ctx }/images/zm_log.ico"/> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href='http://fonts.googleapis.com/css?family=Capriola' rel='stylesheet' type='text/css'>
<title>500</title>
<style type="text/css">
body{
	font-family: 'Capriola', sans-serif;
}
body{
	background:#DAD6CC;
	margin:auto;
}	
.logo h1{
	font-size:100px;
	color:#FF7A00;
	text-align:center;
	margin-bottom:5px;
	text-shadow:4px 4px 1px white;
}	
.logo p{
	color:#B1A18D;;
	font-size:20px;
	margin-top:1px;
	text-align:center;
}	
.logo p span{
	color:lightgreen;
}	
.sub a{
	color:#ff7a00;
	text-decoration:none;
	padding:5px;
	font-size:13px;
	font-family: arial, serif;
	font-weight:bold;
}	
.footer{
	color:white;
	position:absolute;
	right:10px;
	bottom:10px;
}	
.footer a{
	color:#ff7a00;
}	
</style>
</head>

<body>
<div>
		<div class="logo">
			<h1>500</h1>
			<p> Sorry - Server Internal Error!</p>
			<div class="sub">
			   <p><a href="${ctx }/user/to_login"> Back to Home</a></p>
			</div>
		</div>
	</div>
	
	<div class="footer">
	 <a href=""></a>
</div>
</body>
</html>
