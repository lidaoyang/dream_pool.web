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
		//createTree();
    });
    function createDatagrid(){
		$('#dg').datagrid({
			//title:'子节点列表',
		    url:'${ctx }/role/list',
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
		        {field:'id',title:'id',width:60,align:'center',sortable:true},
		        {field:'name',title:'角色名',width:100,align:'left',sortable:true},
		        {field:'status',title:'状态',width:60,align:'center',sortable:true},
				{field:'create_time',title:'创建时间',width:150,align:'center',sortable:true,
				        formatter: function(value,row,index){
								if (row.create_time){
									 var dd = new Date(row.create_time);
			  	  	  	       		 return dd.format("yyyy-MM-dd hh:mm:ss");
								} 
								return "";
					}},
		         {field:'update_time',title:'更新时间',width:150,align:'center',sortable:true,
			        	formatter: function(value,row,index){
							if (row.update_time){
								 var dd = new Date(row.update_time);
		  	  	  	       		 return dd.format("yyyy-MM-dd hh:mm:ss");
							} 
						return "";
				  }}
		    ]],
		    onSelect:function(index,row){
		    	if(row.name){
		    		createTree(row.id);
		    	}
		    },
		    onLoadSuccess: function (data) {  
		        if (data.total == 0) {  
		        	$(this).datagrid('appendRow', { id:'<div style="text-align:center;color:red">没有相关记录！</div>' })
		        	.datagrid('mergeCells', { index: 0, field: 'id', colspan: 5 });
		        } else {  
		            $('#dg').datagrid("selectRow", 0);  
		        }
		    },
		    rownumbers:true,
		    singleSelect:true,
		    pagination:true,
		    pageSize:30,
		    pageList:[30,50,100]
		});
	}
    function createTree(roleId) {
		$('#menuTree').tree({
			url : '${ctx }/function/getFunctionTree?roleId='+roleId,
			method : 'get',
			checkbox:true,
			animate : true,
			onCheck:function(node, checked){
				saveRoleFun(node, checked,roleId);
			}
		});
	}
    function saveRoleFun(node, checked,roleId){
    	var _children = $('#menuTree').tree('getChildren', node.target);
		_children.push(node);
		var nodes = JSON.stringify(_children);
		$.post("${ctx}/role_function/save",{roleId:roleId,nodes:nodes,add_flag:checked},
				function(data){
	   		 	if(data.success){
	   		 	$.messager.alert('提示',data.msg_desc,'error');
	   		 	}
	   	});
    }
    function f_add(){
    	createDialog("新建角色","add","");
    }
    function f_edit(id){
    	var dg = $('#dg').datagrid("getSelected");
    	if(dg){
    		createDialog("修改角色","edit",dg.id);
    	}else{
    		$.messager.alert('提示','请选中一行！','error');
    	}
    }
    function delete_row(){
    	var dg = $('#dg').datagrid("getSelected");
    	if(dg){
    		$.messager.confirm('删除提示', '确定删除吗?', function(r){
                if (r){
                	var id = dg.id;
                	$.post("${ctx}/role/delete",{id:id},function(data){
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
    	var url ='${ctx}/role/form?edit_type='+edit_type+'&id='+id+'&f='+new Date().getTime();
    	var content = '<iframe id="dlg_iframe" src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="no"></iframe>'; 
    	$('#edit_dialog').dialog({
    	    title: title,
    	    width: 450,
    	    height: 280,
    	    closed: false,
    	    cache: false,
    	    content:content,
    	    modal: true,
    	    buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					$("#dlg_iframe")[0].contentWindow.f_save();  }
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function(){
					$('#edit_dialog').dialog('close');
					$('#dg').datagrid('reload');
					$('#menuTree').tree('reload');}
			}]
    	});
    }
	</script>
</head>
<body>
	<div class="easyui-layout" style="width:700px;height:350px;" data-options="fit:true">
        <div data-options="region:'center',split:true" style="width:40%;">
            <table id="dg" ></table>
        </div>
        <div data-options="region:'east',split:true,collapsible:false" style="width:53%;">
            <ul id="menuTree"></ul>
        </div>
    </div>
	<!--Dialog Div  -->
	<div id="edit_dialog"></div>
</body>
</html>
