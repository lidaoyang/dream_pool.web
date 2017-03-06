<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>角色管理</title>
	<link href="${ctx}/images/dream_logo.ico" rel="shortcut icon" />
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
		createDatagrid();
    });
    function createDatagrid(){
		$('#role_dg').datagrid({
			//title:'子节点列表',
		    url:'${ctx }/role/list',
		    method:'get',
		    columns:[[
		        {field:'id',title:'ID',width:60,align:'center',sortable:true},
		        {field:'name',title:'角色名',width:100,align:'left',sortable:true},
		        {field:'status',title:'状态',width:60,align:'center',sortable:true},
		        {field:'create_time',title:'创建时间',width:150,align:'center',sortable:true,
			        formatter: function(value,row,index){
							if (row.create_time){
								 var dd = new Date(row.create_time);
		  	  	  	       		 return dd.format("yyyy-MM-dd hh:mm:ss");
							} 
							return "";
				}}
		    ]],
		    onSelect:function(index,row){
		    	if(row.name){
		    		createDatagrid2(row.id);
		    	}
		    },
		    onLoadSuccess: function (data) {  
		        if (data.total == 0) {  
		        	$(this).datagrid('appendRow', { id:'<div style="text-align:center;color:red">没有相关记录！</div>' })
		        	.datagrid('mergeCells', { index: 0, field: 'id', colspan: 5 });
		        } else {  
		            $('#role_dg').datagrid("selectRow", 0);  
		        }
		    },
		    rownumbers:true,
		    singleSelect:true,
		    pagination:true,
		    pageSize:30,
		    pageList:[30,50,100]
		});
	}
    function createDatagrid2(roleId){
		$('#user_dg').datagrid({
			//title:'子节点列表',
		    url:'${ctx }/authorize/list?roleId='+roleId,
		    method:'get',
		    toolbar: [{
	            text:'添加',
	            iconCls:'icon-add',
	            handler:function(){f_add(roleId);}
	        },{
	            text:'删除',
	            iconCls:'icon-remove',
	            handler:function(){delete_row();}
	        }],
		    columns:[[
		        {field:'id',title:'ID',width:60,align:'center',sortable:true},
		        {field:'name',title:'用户名',width:120,align:'left',sortable:true},
		        {field:'create_time',title:'添加时间',width:150,align:'center',sortable:true,
			        formatter: function(value,row,index){
							if (row.create_time){
								 var dd = new Date(row.create_time);
		  	  	  	       		 return dd.format("yyyy-MM-dd hh:mm:ss");
							} 
							return "";
				}}
		    ]],
		    onLoadSuccess: function (data) {  
		        if (data.total == 0) {  
		        	$(this).datagrid('appendRow', { id:'<div style="text-align:center;color:red">没有相关记录！</div>' })
		        	.datagrid('mergeCells', { index: 0, field: 'id', colspan: 3 });
		        } else {  
		            $('#user_dg').datagrid("selectRow", 0);  
		        }
		    },
		    rownumbers:true,
		    singleSelect:true,
		    pagination:true,
		    pageSize:30,
		    pageList:[30,50,100]
		});
	}
    function createDatagrid3(roleId){
		$('#dlog_dg').datagrid({
		    url:'${ctx }/user/list?roleId='+roleId,
		    method:'get',
		    columns:[[
		        {field:'id',title:'ID',width:60,align:'center',sortable:true},
		        {field:'name',title:'用户名',width:120,align:'left',sortable:true},
		        {field:'create_time',title:'创建时间',width:150,align:'center',sortable:true,
			        formatter: function(value,row,index){
							if (row.create_time){
								 var dd = new Date(row.create_time);
		  	  	  	       		 return dd.format("yyyy-MM-dd hh:mm:ss");
							} 
							return "";
				}},
		    ]],
		    onLoadSuccess: function (data) {  
		        if (data.total == 0) {  
		        	$(this).datagrid('appendRow', { id:'<div style="text-align:center;color:red">没有相关记录！</div>' })
		        	.datagrid('mergeCells', { index: 0, field: 'id', colspan: 3 });
		        }
		    },
		    rownumbers:true,
		    singleSelect:false
		});
	}
    function f_add(roleId){
    	createDatagrid3(roleId);
    	$("#roleId").val(roleId);
    	$('#edit_dialog').dialog('open');
    }
    function delete_row(){
    	var dg = $('#user_dg').datagrid("getSelected");
    	if(dg){
    		$.messager.confirm('删除提示', '确定删除吗?', function(r){
                if (r){
                	var id = dg.id;
                	$.post("${ctx}/authorize/delete",{id:id},function(data){
       		   		 	if(data.success==false){
       		   		 	$.messager.alert('提示',data.msg_desc,'error');
       		   		 	}else{
       		   		 	$('#role_dg').datagrid('reload');
       				 	}
        		   	});
                }
            });
    	}else{
    		$.messager.alert('提示','请选中一行！','error');
    	}
      }
    function saveUserRole(){
    	var rows = $('#dlog_dg').datagrid('getSelections');
    	var roleId = $("#roleId").val();
    	$("#roleId").val("");
    	var users = JSON.stringify(rows);
    	$.post("${ctx}/authorize/save",{roleId:roleId,users:users},
				function(data){
	   		 	if(data.success){
	   		 	$('#edit_dialog').dialog('close');
	   		 	$('#user_dg').datagrid('reload');
	   		 	}else{
	   		 		$.messager.alert('提示',data.msg_desc,'error');
	   		 	}
	   	});
    }
	</script>
</head>
<body>
	<div class="easyui-layout" style="width:700px;height:350px;" data-options="fit:true">
        <div data-options="region:'center',split:true" style="width:30%;">
            <table id="role_dg" ></table>
        </div>
        <div data-options="region:'east',split:true,collapsible:false" style="width:65%;">
            <table id="user_dg" ></table>
        </div>
    </div>
	<!--Dialog Div  -->
	<div id="edit_dialog" class="easyui-dialog" style="width:450px;height:305px"
		data-options="title:'选择用户',modal:true,closed:true,
			buttons:[{
				text:'确定',
				iconCls:'icon-ok',
				handler:function(){saveUserRole();}
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function(){$('#edit_dialog').dialog('close');$('user_dg').datagrid('reload');}
			}]">
		<div style="width:400px; margin: 20px auto;">
			<table id="dlog_dg" ></table>
		</div>
	</div>
	<input id="roleId" name="roleId" type="hidden"/>
</body>
</html>
