<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="viewport" content="width=device-width"/>
<link href="${ctx}/images/dream_logo.ico" rel="shortcut icon" />
<link rel="shortcut icon" href="${ctx }/images/zm_log.ico"/> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>welcome</title>
<style type="text/css">
body{
	margin:auto;
}	
.bg{
	width:100%;
	height:500px;
	background:url('${ctx }/images/welcome.jpg') repeat-x center center;
	}
</style>
</head>

<body>
<div class="bg"></div>
</body>
</html>
