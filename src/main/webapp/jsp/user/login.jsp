<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Login</title>
	<link href="${ctx}/images/dream_logo.ico" rel="shortcut icon" />
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/metro-blue/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/icon.css">
	<script type="text/javascript" src="${ctx }/js/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx }/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx }/js/jquery.form.js"></script>
	
	<style type="text/css">
	.login_bg{
	margin-top:150px;
	padding:50px 0;
	background:url('${ctx }/images/bg.jpg') no-repeat center center;
	background-size: 100% 100%;
	}
	</style>
	<script type="text/javascript">
	$(function() {
		$("body").keydown(function() {
		    if (event.keyCode == "13") {//keyCode=13是回车键
		    	submitForm();
		    }
		}); 
		if(window!=top){
			top.location.href=location.href;
		}
	});
	function submitForm(){
        $('#ff').form('submit',{
        	url:"${ctx}/user/login",
            onSubmit:function(){
                return $(this).form('enableValidation').form('validate');
            },
        	success: function(data){
        		var data = $.parseJSON(data);
        		if(data.success){
        			location.href="${ctx}/home/index";
        		}else{
        			$.messager.alert('提示',data.msg_desc,'error');
        		}
        	}
        });
    }
	</script>
</head>
<body>
	<div class="login_bg" style="width:100%;">
		<div style=" margin: auto;width:400px;">
			<div class="easyui-panel" style="padding:50px 60px;">
			<form id="ff" class="easyui-form" method="post" data-options="novalidate:true">
		        <div style="margin-bottom:20px">
		            <input name="username" class="easyui-textbox" prompt="Username" iconWidth="28" style="width:100%;height:34px;padding:10px;" data-options="required:true,validType:'length[2,10]'">
		        </div>
		        <div style="margin-bottom:20px">
		            <input name="password" class="easyui-passwordbox" prompt="Password" iconWidth="28" style="width:100%;height:34px;padding:10px"  data-options="required:true,validType:'length[2,10]'">
		        </div>
		        <div>
		             <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="submitForm()" style="padding:5px 0px;width:100%;">
		                <span style="font-size:14px;">Login</span>
		            </a>
		        </div>
		       </form>
		    </div>
		</div>
	</div>
</body>
</html>
