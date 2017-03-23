<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>菜单树</title>
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
		createTree();
		//createDatagrid("1")
    });
    function createDatagrid(parentId){
		$('#dg').datagrid({
			title:'子节点列表',
		    url:'${ctx }/function/'+parentId+'/children',
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
		        {field:'name',title:'菜单名',width:100,align:'left',sortable:true},
		        {field:'url',title:'URL',width:230,align:'left',sortable:true},
			    {field:'is_navigation',title:'导航节点',width:80,align:'center',sortable:true,
			        formatter: function(value,row,index){
							if (row.is_navigation=="1"){
		  	  	  	       		 return "是";
							} 
							return "否";
					 }},
				{field:'type',title:'菜单类型',width:100,align:'center',sortable:true,
				        formatter: function(value,row,index){
								if (row.type=="1"){
			  	  	  	       		 return "功能菜单";
								}else if (row.type=="2"){
			  	  	  	       		 return "按钮事件";
								} 
								return "资源数据";
					}},
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
		    rownumbers:true,
		    singleSelect:true,
		    pagination:true,
		    pageSize:15,
		    pageList:[15,30,50,100]
		});
	}
    function createTree() {
		$('#menuTree').tree({
			url : '${ctx }/function/getFunctionTree',
			method : 'get',
			animate : true,
			onLoadSuccess : function(node, data) {
				 /* $("#menuTree li:eq(6)").find("div").addClass("tree-node-selected");   //设置第一个节点高亮   
		           var n = $("#menuTree").tree("getSelected");   
		           if(n!=null){   
		                $("#menuTree").tree("select",n.target);    //相当于默认点击了一下第一个节点，执行onSelect方法   
		           }   */ 
				if (data.length > 0) {
					//找到第一个元素
					var n = $('#menuTree').tree('find', data[0].id);
					//调用选中事件
					$('#menuTree').tree('select', n.target);
				}
			},
			onSelect : function(node) {
				createDatagrid(node.id);
			}
		});
	}
    function f_add(){
    	createDialog("新建子节点","add","");
    }
    function f_edit(id){
    	var dg = $('#dg').datagrid("getSelected");
    	if(dg){
    		createDialog("修改子节点","edit",dg.id);
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
                	$.post("${ctx}/function/delete",{id:id},function(data){
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
    	var url ='${ctx}/function/form?edit_type='+edit_type+'&id='+id+'&f='+new Date().getTime();
    	var content = '<iframe id="dlg_iframe" src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="no"></iframe>'; 
    	$('#edit_dialog').dialog({
    	    title: title,
    	    width: 430,
    	    height: 400,
    	    closed: false,
    	    cache: false,
    	    content:content,
    	    modal: true,
    	    buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					/* if(edit_type=="add"){
						var node = $('#menuTree').tree("getSelected");
						$("#dlg_iframe")[0].contentWindow.$("#parent_id").val(node.id);
					} */
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
        <div data-options="region:'center',split:true" style="width:70%;">
            <table id="dg" ></table>
        </div>
        <div data-options="region:'west',split:true,collapsible:false" style="width:23%;">
            <ul id="menuTree"></ul>
        </div>
    </div>
	<!--Dialog Div  -->
	<div id="edit_dialog"></div>
</body>
</html>
