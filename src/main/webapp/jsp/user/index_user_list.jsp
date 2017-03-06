<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>用户列表</title>
	<link href="${ctx}/images/dream_logo.ico" rel="shortcut icon" />
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/metro-blue/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/icon.css">
	<script type="text/javascript" src="${ctx }/js/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx }/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx }/js/easyui/jquery.easyui.patch.js"></script>
	<script src="${ctx}/js/common.js" type="text/javascript"></script>
	
	<style type="text/css">
	body{
	margin:auto;
}	
	</style>
	<script type="text/javascript">
	$(function(){
		createDatagrid();
    });
    function createDatagrid(){
		$('#dg').datagrid({
			//title:'用户列表',
		    url:'${ctx }/user/list',
		    method:'get',
		    toolbar: [{
	            text:'新建',
	            iconCls:'icon-add',
	            handler:function(){f_add();}
	        },{
	            text:'修改',
	            iconCls:'icon-edit',
	            handler:function(){f_edit();}
	        },{
	            text:'删除',
	            iconCls:'icon-remove',
	            handler:function(){delete_row();}
	        }],
		    columns:[[
		        {field:'id',title:'id',width:80,align:'center',sortable:true},
		        {field:'name',title:'用户名',width:120,align:'left'},
			    {field:'create_time',title:'创建时间',width:180,align:'center',sortable:true,
			        formatter: function(value,row,index){
							if (row.create_time){
								 var dd = new Date(row.create_time);
		  	  	  	       		 return dd.format("yyyy-MM-dd hh:mm:ss");
							} 
							return "";
					 }},
		        {field:'update_time',title:'更新时间',width:180,align:'center',sortable:true,
			        	formatter: function(value,row,index){
							if (row.update_time){
								 var dd = new Date(row.update_time);
		  	  	  	       		 return dd.format("yyyy-MM-dd hh:mm:ss");
							} 
						return "";
				  }},
				{field:'login_time',title:'最后登录时间',width:180,align:'center',sortable:true,
			        	formatter: function(value,row,index){
							if (row.login_time){
								 var dd = new Date(row.login_time);
		  	  	  	       		 return dd.format("yyyy-MM-dd hh:mm:ss");
							} 
							return "";
				 }},
		        {field:'logout_time',title:'退出时间',width:180,align:'center',sortable:true,
			        	formatter: function(value,row,index){
							if (row.logout_time){
								 var dd = new Date(row.logout_time);
		  	  	  	       		 return dd.format("yyyy-MM-dd hh:mm:ss");
							} 
							return "";
				 }}
		    ]],
		    rownumbers:true,
		    singleSelect:true,
		    pagination:true,
		    pageSize:15,
		    pageList:[15,30,50,100]
		});
	}
    function f_add(){
    	createDialog("新建用户","add","");
    }
    function f_edit(id){
    	var dg = $('#dg').datagrid("getSelected");
    	if(dg){
    		createDialog("修改用户","edit",dg.id);
    	}else{
    		$.messager.alert('提示','请选中一行！','error');
    	}
    }
    function delete_row(){
    	var dg = $('#dg').datagrid("getSelected");
    	if(dg){
    		$.messager.confirm('删除提示', '将一起删除此用户所拥有的角色,确定删除吗?', function(r){
                if (r){
                	var id = dg.id;
                	$.post("${ctx}/user/delete",{id:id},function(data){
       		   		 	if(data.success==false){
       		   		 	$.messager.alert('提示',data.msg_desc,'error');
       		   		 	}else{
       		   		 	$('#dg').datagrid('reload');
       				 	}
        		   	});
                }
            });
    	}else{
    		$.messager.alert('提示','请选中一行！','error');
    	}
      }
    function createDialog(title,edit_type,id){
    	var url ='${ctx}/user/form?edit_type='+edit_type+'&id='+id+'&f='+new Date().getTime();
    	var content = '<iframe id="dlg_iframe" src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="no"></iframe>'; 
    	$('#edit_dialog').dialog({
    	    title: title,
    	    width: 450,
    	    height: 305,
    	    closed: false,
    	    cache: false,
    	    content:content,
    	   // href: '${ctx}/user/form?edit_type='+edit_type+'&id='+id+'&f='+new Date().getTime(),
    	    modal: true,
    	    buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){$("#dlg_iframe")[0].contentWindow.f_save();  }
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function(){$('#edit_dialog').dialog('close');$('#dg').datagrid('reload');}
			}]
    	});
    }
	</script>
</head>
<body>
	<table id="dg" ></table>
	<!--Dialog Div  -->
	<div id="edit_dialog"></div>
</body>
</html>
