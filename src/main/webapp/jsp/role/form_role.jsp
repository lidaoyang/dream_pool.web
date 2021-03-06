<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>编辑</title>
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/metro-blue/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/icon.css">
	<script type="text/javascript" src="${ctx }/js/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx }/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx }/js/easyui/jquery.easyui.patch.js"></script>
	<script src="${ctx}/js/common.js" type="text/javascript"></script>
	
	<style type="text/css">
	</style>
	<script type="text/javascript">
	function f_save(){
		submitForm();
	}
	function submitForm(){
        $('#ff').form('submit',{
        	url:"${ctx}/role/save",
            onSubmit:function(){
                return $(this).form('enableValidation').form('validate');
            },
        	success: function(data){
        		var data = $.parseJSON(data);
        		if(data.success){
        			$.messager.alert('提示',data.msg_desc,'info');
        		}else{
        			$.messager.alert('提示',data.msg_desc,'error');
        		}
        	}
        });
    }
	</script>
</head>
<body>
	<div style="width:400px; margin: 45px auto;">
		<div class="easyui-panel" style="padding:20px;">
	  <form id="ff" class="easyui-form" method="post" data-options="novalidate:true">
        <div style="margin-bottom:20px">
            <input name="name" class="easyui-textbox" label="角色名称:"  iconWidth="28" style="width:100%;height:34px;padding:10px;" data-options="required:true,validType:'length[2,10]'" value="${role.name }" />
            <input name="id" type="hidden" value="${role.id }"/>
            <input name="create_time" type="hidden" value="${role.create_time }"/>
            <input name="update_time" type="hidden" value="${role.update_time }"/>
            <input name="status" type="hidden" value="${role.status }"/>
            <input name="edit_type" type="hidden" value="${edit_type }"/>
        </div>
       </form>
    </div>
	</div>
</body>
</html>
