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
	$(function(){
		createComboTree();
    });
	function f_save(){
		submitForm();
	}
	function submitForm(){
        $('#ff').form('submit',{
        	url:"${ctx}/function/save",
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
	function createComboTree() {
		$('#comboTree').combotree({
			url : '${ctx }/function/getFunctionTree',
			method : 'get',
			animate : true,
			required: true
		});
	}
	</script>
</head>
<body>
	<div style="width:400px; margin: 20px auto;">
		<div class="easyui-panel" style="padding:20px;">
	  <form id="ff" class="easyui-form" method="post" data-options="novalidate:true">
	  	<div style="margin-bottom:20px">
	  		<input id="comboTree" name ="parent_id"  class="easyui-textbox" label="父级节点:"  iconWidth="28" style="width:100%;height:34px;padding:10px;" value="${function.parent_id }"/>
        </div>
        <div style="margin-bottom:20px">
            <input name="name" class="easyui-textbox" label="节点名称:"  iconWidth="28" style="width:100%;height:34px;padding:10px;" data-options="required:true,validType:'length[2,10]'" value="${function.name }" />
            <input name="id" type="hidden" value="${function.id }"/>
            <input name="create_time" type="hidden" value="${function.create_time }"/>
            <input name="update_time" type="hidden" value="${function.update_time }"/>
            <input name="edit_type" type="hidden" value="${edit_type }"/>
        </div>
        <div style="margin-bottom:20px">
        	<input name="url" class="easyui-textbox" label="URL:"  iconWidth="28" style="width:100%;height:34px;padding:10px;" value="${function.url }" />
        </div>
        <div style="margin-bottom:20px">
        	<label>导航节点:&nbsp;&nbsp;</label>
        	<input name="is_navigation" class="easyui-switchbutton" <c:if test="${function.is_navigation == '1'}">checked</c:if> value="1" data-options="onText:'YES',offText:'NO'">
        </div>
        <div style="margin-bottom:20px">
        	<select class="easyui-combobox" name="type" label="类型:"  style="width:100%;">
				<option value="1" <c:if test="${function.type=='1' }">selected="selected"</c:if>>菜单功能</option>
				<option value="2" <c:if test="${function.type=='2' }">selected="selected"</c:if>>按钮事件</option>
				<option value="3" <c:if test="${function.type=='3' }">selected="selected"</c:if>>资源数据</option>
			</select>
        </div>
        <div style="margin-bottom:20px">
        	<input name="serial_num" class="easyui-textbox" label="排序号:"  iconWidth="28" style="width:100%;height:34px;padding:10px;" value="${function.serial_num }" />
        </div>
       </form>
    </div>
	</div>
</body>
</html>
