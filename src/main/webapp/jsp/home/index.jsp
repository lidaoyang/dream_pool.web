<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>DREAM</title>
	<link href="${ctx}/images/dream_logo.ico" rel="shortcut icon" />
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/metro-blue/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/icon.css">
	<script type="text/javascript" src="${ctx }/js/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx }/js/easyui/jquery.easyui.min.js"></script>
	
	<style type="text/css">
	.logo{height: 50px; 
	width: 151px;
	float: left;
	margin:30px 0 0 30px; 
	background:url('${ctx }/images/logo.png') no-repeat center center;
	background-size: 100% 100%;
	}
	#top{
	height:100px;
	background:url('${ctx }/images/bg.jpg') no-repeat center center;
	background-size: 100% 100%;
	}
	#navigation ul {
		border-width:0px;
		margin:0px;
		padding:0px;
		text-indent:0px;
	}
	#navigation li {
		list-style:none; display:inline;
	}
	#navigation li a {
		display:block;
		font-size:13px;
		text-decoration: none;
		padding:3px 3px 3px 10px;
		margin-bottom: 4px;
	}
	#navigation li a:hover {
			border:solid 1px #adb9c2;
	}
	.active{
			border:solid 1px #adb9c2;
	}
	</style>
	<script type="text/javascript">
	$(function(){
		 $("#frameId").attr("src","${ctx }/jsp/home/welcome.jsp");
		 $.extend($.fn.validatebox.defaults.rules, {
	         confirmPass: {
	             validator: function(value, param){
	                 var pass = $(param[0]).passwordbox('getValue');
	                 return value == pass;
	             },
	             message: 'Password does not match confirmation.'
	         }
	     });
	})
	function changeMain(obj, title) {
		$("#navigation li a").removeClass("active");
		$(obj).addClass("active");
		$('#e_layout').layout('panel', 'center').panel({title : title });
	}
	function f_save(){
		submitForm();
	}
	function submitForm(){
        $('#ff').form('submit',{
        	url:"${ctx}/user/modifyPwd",
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
	<div id="e_layout" class="easyui-layout" data-options="fit:true">
		<div id="top" data-options="region:'north'">
			<div id="title" >
				<div id="logo" class="logo"></div>
				<div style="text-align: right; padding: 60px 50px 0 0;">
					<a href="javascript:void(0);" style="font-size: 13px; text-decoration:none;color:#01058A;" onclick="$('#edit_dialog').dialog('open');">
					<img alt="logout" src="${ctx }/images/keyt.png" width="10px" height="16px" align="top" /> 修改密码
					</a>&nbsp;
					<a href="${ctx }/user/logout" style="font-size: 13px;color:#01058A;text-decoration:none;">
					<img alt="logout" src="${ctx }/images/logout.png" width="20px" align="top" /> 退出
					</a>
				</div>
			</div>
		</div>
		<div id="navigation" data-options="region:'west',split:true" title="导航" style="width:180px;">
			<div class="easyui-accordion" data-options="border:false">
				<c:if test="${fn:length(functions[0].children)==0 }">
					<div title="没有菜单权限" data-options="selected:true" style="padding:10px;">如果需要，请联系管理员</div>
				</c:if>
				<c:forEach var="f_parent" items="${functions[0].children }" varStatus="statu">
					<div title="${f_parent.text }" <c:if test="${statu.index=='0' }">data-options="selected:true"</c:if> style="padding:10px;">
						<ul>
						<c:forEach var="f_child" items="${f_parent.children }">
							<li><a href="${ctx }${f_child.attributes.url}" onclick="changeMain(this,'${f_child.text}');" target="frameId">${f_child.text}</a></li>
						</c:forEach>
					    </ul>
					</div>
				</c:forEach>
			</div>
		</div>
		<div id="main_body" data-options="region:'center',title:'用户管理'" >
			<iframe id="frameId" name="frameId" src="" scrolling="no" frameborder="0" style="width:100%; height: 500px;" ></iframe>
		</div>
	</div>
	<!--Dialog Div  -->
	<div id="edit_dialog" class="easyui-dialog" style="width:450px;height:305px"
		data-options="title:'修改密码',modal:true,closed:true,
			buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){f_save();}
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function(){$('#edit_dialog').dialog('close');$('#dg').datagrid('reload');}
			}]">
		<div style="width:400px; margin: 20px auto;">
			<form id="ff" class="easyui-form" method="post"  data-options="novalidate:true">
			<div class="easyui-panel" style="padding: 20px;">
				<div style="margin-bottom: 10px">
					<input id="oldpwd" name="oldpwd" class="easyui-textbox" prompt="OldPassword" iconWidth="28" style="width: 100%; height: 34px; padding: 10px;"  data-options="required:true,validType:'length[2,10]'">
				</div>
				<div style="margin-bottom: 10px">
					<input id="pass" name="newpwd" class="easyui-passwordbox" prompt="NewPassword" iconWidth="28" style="width: 100%; height: 34px; padding: 10px"  data-options="required:true,validType:'length[2,10]'">
				</div>
				<div style="margin-bottom: 5px">
					<input class="easyui-passwordbox" prompt="Confirm your password" iconWidth="28" validType="confirmPass['#pass']" style="width: 100%; height: 34px; padding: 10px"  data-options="required:true">
				</div>
			</div>
		</form>
		</div>
	</div>
</body>
</html>
