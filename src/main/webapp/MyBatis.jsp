<%@ page language="java" import="java.util.*,java.io.*,java.sql.*"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
	<form action="">
		<table>
			<tr>
				<td>src路径：<input name="p" type="text" value="E:/workspace/src/" size="60"><input
					type="submit"></td>
				<td rowspan="2" valign="top"><div
						style="width: 100%; height: 100%" id="tip"></div></td>
			</tr>
			<tr>
				<td valign="top">表名：
					<div style="width: 100%; height: 100%" id="tableName">
						<input name="t" type="text">
					</div>
				</td>
			</tr>
		</table>
	</form>
	<%
		/**********************************************************/ 
	 //自定义说明:如果想自己修改，可以调用的信息，注意作用范围,确保包正确，必须先准生成包,使用前设定好src路径，数据库驱动，数据库配置，参数，模板 
	 //String[][] ts     [][0]类型，1字段，2大写开头字段 
	 //String bt         表名，大写开头 
	 //String t          表名，小写开头 
	 //String pt         表名中下划线后面的部分,用于做变量名 
	 //String p          项目src路径 
	 //String gz         参数段，多用于构造                       例如      String a,String b,int c... 
	 //String gzq        字段，多用于mapper                    例如      [id],[name],[code]... 
	 //String gzi        字段参数，多用于mapper,             例如      #{id},#{name},#{code}... 
	 //String gzu        字段参数，多用于mapper,             例如      [id]=#{id},[name]=#{name},[code]=#{code}... 
	 //*****段落，作为diy帮助 
	 //初始化1 
	 //读取数据库1 
	 //判断 
	 //初始化2 
	 //读取数据库2        别忘记了驱动，那玩意我才不去集成 
	 //实体类           建议不要用原型int，double这样的类，因为他们无法赋值null，虽然封装类java.lang.*,例如Integer,Double这样的会慢点，但是可以满足SQL的null 
	 //mapper        这里写sql模板 
	 //impl          这里写impl模板 
	 //dao           这里写dao模板 
	 //spring        注入spring模板 
	 //mybatis       注入mybatis模板 
	 //说明 
	 /**********************************************************/ 
	 //初始化 
	 //String dbDriver="com.microsoft.sqlserver.jdbc.SQLServerDriver";//数据库驱动 
	 //String dbUrl="jdbc:sqlserver://127.0.0.1:1433;databaseName=DB";//数据库URL 
	 //oracle
	 /* String dbDriver="oracle.jdbc.driver.OracleDriver";//数据库驱动 
	 String dbUrl="jdbc:oracle:thin:@192.168.0.51:1521/orcl";//数据库URL 
	 //String dbUrl="jdbc:oracle:thin:@192.10.33.13:1521/orcl";//数据库URL 
	 String dbUser="GYL_DEP";//数据库帐号 
	 String dbPassword="GYL_DEP";//数据库密码  */
	 //mysql
	 String dbDriver="com.mysql.jdbc.Driver";//数据库驱动 
	 String dbUrl="jdbc:mysql://localhost:3306/dream_pool?characterEncoding=utf-8";//数据库URL 
	 //String dbUrl="jdbc:oracle:thin:@192.10.33.13:1521/orcl";//数据库URL 
	 String dbUser="dreamer";//数据库帐号 
	 String dbPassword="dreamer";//数据库密码 
	 String schema="dream_pool";//数据库对象名（mysql） 
	 //读取数据1 
	 Class.forName(dbDriver).newInstance(); 
	 Connection conn = DriverManager.getConnection(dbUrl, dbUser,dbPassword); 
	 Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); 
	 //SELECT name FROM sysobjects WHERE xtype = 'U' AND status >= 0
	 //ResultSet rs = stmt.executeQuery("select TABLE_NAME AS NAME from tabs order by table_name asc"); //oracle
	 ResultSet rs = stmt.executeQuery("select table_name as name from information_schema.tables where table_schema='"+schema+"' and table_type='base table' order by create_time desc,table_name asc"); 
	 String str=""; 
	 while(rs.next()){ 
	     String name=rs.getString("name"); 
	     str+="<input type=\"checkbox\" value=\""+name+"\" name=\"ts\">"+name+"<br/>"; 
	 }
	%>
	<script type="text/javascript"> 
     document.getElementById("tableName").innerHTML='<%=str%>'; 
 </script>
	<%
		//判断 
	 String p=request.getParameter("p"); 
	 String[] tss=request.getParameterValues("ts"); 
	 if(tss==null||p==null||p=="") 
	     return; 
	 //初始化2 
	 List<String> pa=new ArrayList<String>(); 
	 pa.add("com.dream.model");//实体类包 
	 pa.add("com.dream.mapper");//mapper包 
	 pa.add("com.dream.service");//service包 
	 pa.add("com.dream.controller");//controller包 

	 List<String[]> db2java=new ArrayList<String[]>();//数据库转实体类的类型设定     [0]为SQL类型,[1]为java类型    不满足条件为Object 
	 db2java.add(new String[]{"VARCHAR2","String","VARCHAR"});
	 db2java.add(new String[]{"VARCHAR","String","VARCHAR"});
	 db2java.add(new String[]{"INT","String","VARCHAR"});
	 db2java.add(new String[]{"LONGTEXT","String","VARCHAR"});
	 db2java.add(new String[]{"TEXT","String","VARCHAR"}); 
	 db2java.add(new String[]{"DATE","String","VARCHAR"});
	 db2java.add(new String[]{"DATETIME","String","VARCHAR"});
	 db2java.add(new String[]{"NUMBER","Long","DECIMAL"}); 
	 db2java.add(new String[]{"FLOAT","Float","DECIMAL"}); 
	 db2java.add(new String[]{"DOUBLE","Double","DECIMAL"}); 
	 String tipStr=""; 
	 for(int ti=0;ti<tss.length;ti++){ 
	     String t=tss[ti]; 
	     HashMap[] r = (HashMap[]) null; 
	     //读取数据2 
	     int iRowNum; 
	     r = (HashMap[])null; 
	     iRowNum = 0; 
	     int iColCnt = 0; 
	     //select a.name as [column],b.name as type from syscolumns a,systypes b where a.id=object_id('"+ t+ "') and a.xtype=b.xtype and b.name!='sysname' order by a.id,a.colorder
	     //oracle
	     //rs = stmt.executeQuery("select a.COLUMN_NAME,a.DATA_TYPE,a.DATA_LENGTH,a.DATA_PRECISION,a.DATA_SCALE,case when b.column_name is null then 0 else  1 end as pk from user_tab_columns a left join ( select col.column_name  from user_constraints con, user_cons_columns col  where con.constraint_name = col.constraint_name and con.constraint_type='P' and col.table_name = '"+t+"') b on a.column_name=b.column_name WHERE a.TABLE_NAME='"+t+"' order by a.column_id");
	     //mysql character_maximum_length
	     rs = stmt.executeQuery("select COLUMN_NAME, DATA_TYPE,CHARACTER_MAXIMUM_LENGTH,COLUMN_COMMENT ,case when column_key = 'PRI' then 1 else  0 end as PK  from information_schema.columns where table_schema='"+schema+"' and table_name='"+t+"'");

	     ResultSetMetaData MetaData = rs.getMetaData(); 
	     iColCnt = MetaData.getColumnCount(); 
	     if (rs.next()){ 
	         rs.last(); 
	         r = new HashMap[rs.getRow()]; 
	         rs.beforeFirst(); 
	     } 
	     while (rs.next()){ 
	         r[iRowNum] = new HashMap<String,String>(); 
	         for (int j = 0; j < iColCnt; j++){ 
	             String szColName = MetaData.getColumnName(j + 1); 
	             String szColValue = rs.getString(szColName); 
	             if (szColValue == null) 
	                 szColValue = ""; 
	             r[iRowNum].put(szColName, szColValue); 
	         } 
	         iRowNum++; 
	     } 
	     String bt=t.substring(0,1).toUpperCase()+t.substring(1).toLowerCase();
	     
	     String pt = t.toLowerCase();
	     String pName = "";//类所在的包名
	     /* if(t.contains("_")){
	    	 pt = t.substring(t.indexOf("_")+1).toLowerCase();
		     pName = t.substring(0, t.indexOf("_")).toLowerCase();//类所在的包名
	     }
	     pName=""; */
	     Create(p+pa.get(1).replace(".", "/")+"/"+pName);
		 Create(p+pa.get(0).replace(".", "/")+"/"+pName);
		 Create(p+pa.get(2).replace(".", "/")+"/"+pName);
		 Create(p+pa.get(3).replace(".", "/")+"/"+pName);
	     
	     //实体类文件 
	     File file = new File(p+pa.get(0).replace(".", "/")+"/"+bt+".java"); 
	     if(file.exists()) 
	         file.delete(); 
	     FileWriter fw=new FileWriter(file); 
	     BufferedWriter bw=new BufferedWriter(fw); 
	     bw.write("package "+pa.get(0)+";\r\n"); 
	     bw.write("\r\n");
	     bw.write("import com.dream.pub.MyModel;\r\n");
	     bw.write("\r\n");
	     bw.write("public class "+bt+" implements java.io.Serializable,MyModel{\r\n"); 
	     bw.write("  private static final long serialVersionUID=1L;\r\n"); 
	     String[][] ts=new String[r.length][5]; 
	     for(int i=0;i<r.length;i++){ 
	    	 ts[i][0]="String"; 
	         ts[i][3]="VARCHAR";
	         for(String[] temp :db2java) 
	         {
	             if(r[i].get("DATA_TYPE").toString().toUpperCase().equals(temp[0])) 
	             {
	                 ts[i][0]=temp[1];
	                 ts[i][3]=temp[2];
	             }
	         }
	         ts[i][1]=r[i].get("COLUMN_NAME").toString().toLowerCase();
	         ts[i][2]=ts[i][1].substring(0,1).toUpperCase()+ts[i][1].substring(1).toLowerCase(); 
	         ts[i][4]=r[i].get("PK").toString(); 
	         bw.write("  private "+ts[i][0]+" "+ts[i][1]+";\r\n");
	     }
	     bw.write("  private String edit_type;\r\n");
	     for(int i=0;i<r.length;i++){ 
	         bw.write("\r\n"); 
	         bw.write("  public "+ts[i][0]+" get"+ts[i][2]+"(){\r\n"); 
	         bw.write("      return "+ts[i][1]+";\r\n"); 
	         bw.write("  }\r\n"); 
	         bw.write("\r\n"); 
	         bw.write("  public void set"+ts[i][2]+"("+ts[i][0]+" "+ts[i][1]+") {\r\n"); 
	         bw.write("      this."+ts[i][1]+" ="+ts[i][1]+";\r\n"); 
	         bw.write("  }\r\n"); 
	     }
	     bw.write("\r\n"); 
         bw.write("  public String getEdit_type() {\r\n"); 
         bw.write("      return edit_type;\r\n"); 
         bw.write("  }\r\n"); 
         bw.write("\r\n"); 
         bw.write("  public void setEdit_type(String edit_type) {\r\n"); 
         bw.write("      this.edit_type = edit_type;\r\n"); 
         bw.write("  }\r\n"); 
	     bw.write("  public "+bt+"(){\r\n"); 
	     bw.write("  }\r\n"); 
	     
         bw.write("  public String getMapperSpace(){\r\n"); 
         bw.write("      return \""+pa.get(1)+"."+bt+"Mapper\";\r\n"); 
         bw.write("  }\r\n"); 
         
	     
	     String gz=""; 
	     for(int i=0;i<r.length;i++) 
	         gz+=","+ts[i][0]+" "+ts[i][1]; 
	     bw.write("  public "+bt+"("+gz.substring(1)+"){\r\n"); 
	     for(int i=0;i<r.length;i++) 
	         bw.write("      this."+ts[i][1]+"="+ts[i][1]+";\r\n"); 
	     bw.write("  }\r\n");
	     
	     
	     bw.write("}"); 
	     bw.flush(); 
	     fw.close();
	     
	     //mapper文件 
	     String gzq="",gzi="",gzib="",upgzi="",gzu=""; 
	     String zjz="";
	     String where="";
	     String sqlsel="";
	     String pkStr = "";
	     String zjzd ="";
	     String cs = "";
	     String upperSel = "";
	     StringBuffer resultMap = new StringBuffer("<resultMap type=\"hashmap\" id=\"resultMap\">\r\n");
	     for(int i=0;i<r.length;i++){
	    	 
	         gzq+=""+ts[i][1]+","; 
	         gzi+="#{"+ts[i][1]+",jdbcType="+ts[i][3]+"},"; 
	         if(i>0){
	        	 upgzi+=ts[i][1]+"=values("+ts[i][1]+"),"; 
	        	 gzib+="#{"+t+"."+ts[i][1]+"},"; 
	         }
	         gzu+=ts[i][1]+""+"=#{"+ts[i][1]+",jdbcType="+ts[i][3]+"},";
	         sqlsel+=""+ts[i][1]+" as \""+ts[i][1]+"\" ,";
	         upperSel+=ts[i][1].toUpperCase()+",";
	         if (ts[i][4].equals("1"))
	         {
	        	 zjz+= ""+ts[i][1]+""+"=#{"+ts[i][1]+",jdbcType="+ts[i][3]+"} and ";
	        	 resultMap.append("<id 	property=\""+ts[i][1]+"\" column=\""+ts[i][1]+"\" javaType=\""+ts[i][0]+"\" jdbcType=\""+ts[i][3]+"\"/>\r\n");
	        	 pkStr += "@Param(value=\""+ts[i][1]+"\") "+ts[i][0]+" "+ts[i][1] +",";
	        	 zjzd += ts[i][0]+" "+ts[i][1] +",";
	        	 cs += ts[i][1] +",";
	         }else{
	        	 resultMap.append("<result 	property=\""+ts[i][1]+"\" column=\""+ts[i][1]+"\" javaType=\""+ts[i][0]+"\" jdbcType=\""+ts[i][3]+"\"/>\r\n");
	         }
	         
	         
	         if (ts[i][3]=="DATE")
	         {
	        	 where += "<if test=\""+ts[i][1]+"_start != null \"> ";	 
	        	 where += "AND "+ts[i][1]+" >=${ibatis_key_todate}#{"+ts[i][1]+"_start}${ibatis_key_plus}' 00:00:00'${ibatis_key_todate_end} ";
		         where += "</if> \r\n";
		         where += "<if test=\""+ts[i][1]+"_end != null \"> ";	 
		         where += "AND "+ts[i][1]+" &lt;=${ibatis_key_todate}#{"+ts[i][1]+"_end}${ibatis_key_plus}' 23:59:59'${ibatis_key_todate_end} ";
		         where += "</if> \r\n";
	         }
	         else
	         {
	        	 where += "<if test=\""+ts[i][1]+" != null \"> ";	 
	        	 where += "AND "+ts[i][1]+" = #{"+ts[i][1]+", jdbcType="+ts[i][3]+"} ";
		         where += "</if> \r\n";
	         }
	         
	     } 
	     gzq=(gzq+",").replace(",,", ""); 
	     gzi=(gzi+",").replace(",,", ""); 
	     upgzi=(upgzi+",").replace(",,", ""); 
	     gzib=(gzib+",").replace(",,", ""); 
	     gzu=(gzu+",").replace(",,", "");
	     pkStr = (pkStr+",").replace(",,", "");
	     zjzd = (zjzd+",").replace(",,", "");
	     cs = (cs+",").replace(",,", "");
	     zjz=zjz.substring(0, zjz.length()-4); 
	     resultMap.append("</resultMap>\r\n");
	     sqlsel=(sqlsel+",").replace(",,", "");
	     upperSel=(upperSel+",").replace(",,", "");
	     where += "        <if test=\"otherwhere != null \"> ";
         where += "AND   ${otherwhere} ";
         where += "</if> ";

	     where="<where>\r\n"+where+"\r\n        </where>\r\n";
	     
	     file = new File(p+pa.get(1).replace(".", "/")+"/"+bt+"Mapper.xml"); 
	     if(file.exists()) file.delete(); 
	     
	     fw=new FileWriter(file); 
	     bw=new BufferedWriter(fw); 
	     bw.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n"); 
	     bw.write("<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\">\r\n"); 
	     bw.write("<mapper namespace=\""+pa.get(1)+"."+bt+"Mapper\">\r\n");
	     //bw.write(resultMap.toString()+"\r\n");
	     bw.write("<sql id=\"sqlsel\">");
	     bw.write(sqlsel);	     
	     bw.write("</sql>\r\n");
	     bw.write("<sql id=\"upperSel\">");
	     bw.write(upperSel);	     
	     bw.write("</sql>\r\n");
	     bw.write("  <select id=\"select\" resultType=\""+bt+"\" >\r\n"); 
	     bw.write("      SELECT <include refid=\"upperSel\"/> FROM "+t+" \r\n ");
	     bw.write("      WHERE "+zjz+ " \r\n"); 
	     bw.write("  </select>\r\n"); 
	     bw.write("  <select id=\"select_class\" parameterType=\"Map\" resultType=\""+bt+"\">\r\n"); 
	     bw.write("      SELECT <include refid=\"upperSel\"/> FROM "+t+" \r\n"); 
	     bw.write("      "+where+"\r\n");
	     bw.write("   <if test=\"orderby != null\">\r\n");
	     bw.write("    order by ${orderby}\r\n");
	     bw.write(" </if>\r\n");
	     bw.write("   <if test=\"limit != null\">\r\n");
	     bw.write("    limit ${limit}\r\n");
	     bw.write(" </if>\r\n");
	     bw.write("  </select>\r\n"); 
	     bw.write("  <select id=\"select_map\" resultType=\"hashmap\" parameterType=\"Map\" >\r\n"); 
	     bw.write("      SELECT <include refid=\"sqlsel\"/> FROM "+t+"\r\n");
	     bw.write("      "+where+"\r\n");
	     bw.write("   <if test=\"orderby != null\">\r\n");
	     bw.write("    order by ${orderby}\r\n");
	     bw.write(" </if>\r\n");
	     bw.write("   <if test=\"limit != null\">\r\n");
	     bw.write("    limit ${limit}\r\n");
	     bw.write(" </if>\r\n");
	     bw.write("  </select>\r\n"); 
	     bw.write("  <select id=\"select_count\" resultType=\"String\" parameterType=\"Map\" >\r\n"); 
	     bw.write("      SELECT count(*) FROM "+t+"\r\n");
	     bw.write("      "+where+"\r\n");
	     bw.write("  </select>\r\n"); 
	     bw.write("  <insert id=\"insert\" useGeneratedKeys=\"true\" keyProperty=\"id\" parameterType=\""+bt+"\">\r\n"); 
	     bw.write("      INSERT INTO "+t+" ("+gzq+")VALUES("+gzi+")\r\n"); 
	     bw.write("  </insert>\r\n"); 
	     bw.write("  <insert id=\"insertBatch\" useGeneratedKeys=\"true\" keyProperty=\"id\" parameterType=\"java.util.List\">\r\n"); 
	     /* bw.write("    <selectKey resultType =\"java.lang.Integer\" keyProperty= \"id\" order= \"AFTER\">\r\n"); 
	     bw.write("         SELECT LAST_INSERT_ID()\r\n"); 
	     bw.write("    </selectKey >\r\n"); */ 
	     bw.write("    INSERT IGNORE INTO "+t+" ("+("id_"+gzq).replace("id_id,", "")+")VALUES\r\n"); 
	     bw.write("    <foreach collection=\"list\" item=\""+t+"\" index=\"index\" separator=\",\">\r\n"); 
	     bw.write("  	("+gzib+")\r\n"); 
	     bw.write("    </foreach>\r\n"); 
	     bw.write("  </insert>\r\n"); 
	     bw.write("  <insert id=\"insertBatchUpdate\" parameterType=\"java.util.List\">\r\n"); 
	     bw.write("    INSERT INTO "+t+" ("+gzq+")VALUES\r\n"); 
	     bw.write("    <foreach collection=\"list\" item=\""+t+"\" index=\"index\" separator=\",\">\r\n"); 
	     bw.write("  	(#{"+t+".id},"+gzib+")\r\n"); 
	     bw.write("    </foreach>\r\n"); 
	     bw.write("  	on duplicate key update "+upgzi+"\r\n"); 
	     bw.write("  </insert>\r\n"); 
	     bw.write("  <update id=\"update\" parameterType=\""+bt+"\">\r\n"); 
	     bw.write("      UPDATE "+t+" SET\r\n"+gzu+" \r\n");
	     bw.write("      WHERE "+zjz+ " \r\n");
	     bw.write("  </update>\r\n"); 
	     bw.write("  <delete id=\"delete\" >\r\n"); //pa.get(0)+"."
	     bw.write("      DELETE FROM "+t+" \r\n");
	     bw.write("      WHERE "+zjz+ " \r\n");	     
	     bw.write("  </delete>\r\n"); 
	     bw.write("</mapper>"); 
	     bw.flush(); 
	     fw.close();
	     //Mapper文件 
	     file = new File(p+pa.get(1).replace(".", "/")+"/"+bt+"Mapper.java"); 
	     if(file.exists()) 
	         file.delete(); 
	     fw=new FileWriter(file); 
	     bw=new BufferedWriter(fw); 
	     bw.write("package "+pa.get(1)+";\r\n"); 
	     bw.write("\r\n"); 
	     bw.write("import java.util.ArrayList;\r\n");
	     bw.write("import java.util.HashMap;\r\n");
	     bw.write("import java.util.Map;\r\n"); 
	     bw.write("import org.apache.ibatis.annotations.Param;\r\n"); 
	     bw.write("import org.springframework.stereotype.Repository;\r\n"); 
    	 bw.write("import "+pa.get(0)+"."+bt+";\r\n");
	     bw.write("\r\n"); 
	     bw.write("@Repository\r\n");
	     bw.write("public interface "+bt+"Mapper {\r\n"); 
	     bw.write("  "+bt+" select("+pkStr+");\r\n"); 
	     bw.write("  \r\n"); 
	     bw.write("  ArrayList<"+bt+"> select_class(Map<String, Object> "+pt+");\r\n"); 
	     bw.write("  \r\n"); 
	     bw.write("  ArrayList<HashMap<String, Object>> select_map(Map<String, Object> "+pt+");\r\n"); 
	     bw.write("  \r\n"); 
	     bw.write("  String select_count(Map<String, Object> "+pt+");\r\n"); 
	     bw.write("  \r\n"); 
	     bw.write("  int insert("+bt+" "+pt+");\r\n"); 
	     bw.write("  \r\n"); 
	     bw.write("  int insertBatch(ArrayList<"+bt+"> "+pt+");\r\n"); 
	     bw.write("  \r\n");
	     bw.write("  int insertBatchUpdate(ArrayList<"+bt+"> list);\r\n"); 
	     bw.write("  \r\n");
	     bw.write("  int update("+bt+" "+pt+");\r\n"); 
	     bw.write("  \r\n"); 
	     bw.write("  int delete("+pkStr+");\r\n"); 
	     bw.write("}"); 
	     bw.flush(); 
	     fw.close(); 
	     
	     //生成Service文件
	     file = new File(p+pa.get(2).replace(".", "/")+"/"+bt+"Service.java"); 
	     if(file.exists()) 
	         file.delete(); 
	     FileOutputStream fos = new FileOutputStream(p+pa.get(2).replace(".", "/")+"/"+bt+"Service.java");    
	     bw = new java.io.BufferedWriter(new OutputStreamWriter(fos, "UTF-8"));  
	     bw.write("package "+pa.get(2)+";\r\n");
	     bw.write("\r\n");
	     bw.write("import java.util.ArrayList;\r\n");
	     bw.write("import java.util.HashMap;\r\n");
	     bw.write("\r\n");
	     bw.write("import javax.servlet.http.HttpSession;\r\n");
	     bw.write("\r\n");
	     bw.write("import org.springframework.beans.factory.annotation.Autowired;\r\n");
	     bw.write("import org.springframework.stereotype.Service;\r\n");
	     bw.write("\r\n");
	     bw.write("import "+pa.get(1)+"."+bt+"Mapper;\r\n");
	     bw.write("import "+pa.get(0)+"."+bt+";\r\n");
	     bw.write("import com.utils.StrUtils;\r\n");
	     bw.write("\r\n");
	     bw.write("@Service\r\n");
	     bw.write("public class "+bt+"Service {\r\n");
	     bw.write("	@Autowired\r\n");
	     bw.write("	private "+bt+"Mapper "+pt+"Mapper;\r\n");
	     bw.write("\r\n");
	     bw.write("	public ArrayList<HashMap<String, Object>> qry(HttpSession session,HashMap<String, Object> map) {\r\n");
   		 bw.write("		return "+pt+"Mapper.select_map(map);\r\n");
   		 bw.write("	}\r\n");
   		 bw.write("\r\n");
   		 bw.write("	public HashMap<String, Object> select_list(HttpSession session,HashMap<String, Object> map) {\r\n");
   		 bw.write("		HashMap<String, Object> maps = new HashMap<String, Object>();\r\n");
   		 bw.write("		maps.put(\"rows\","+pt+"Mapper.select_map(map));\r\n");
   		 bw.write("		maps.put(\"total\","+pt+"Mapper.select_count(map));\r\n");
   		 bw.write("		return maps;\r\n");
   		 bw.write("	}\r\n");
   		 bw.write("\r\n");
   		 bw.write("	public ArrayList<"+bt+"> select_class(HttpSession session,HashMap<String, Object> map) {\r\n");
  		 bw.write("		return "+pt+"Mapper.select_class(map);\r\n");
  		 bw.write("	}\r\n");
  		 bw.write("\r\n");
   		 bw.write("	public "+bt+" select("+zjzd+"){\r\n");
   		 bw.write("		return "+pt+"Mapper.select("+cs+");\r\n");
   		 bw.write("	}\r\n");
   		 bw.write("	\r\n");
   		 bw.write("	public String select_count(HttpSession session,HashMap<String, Object> map) {\r\n");
  		 bw.write("		return "+pt+"Mapper.select_count(map);\r\n");
  		 bw.write("	}\r\n");
  		 bw.write("\r\n");
   		 bw.write("	public int save("+bt+" "+pt+", HttpSession session){\r\n");
   		 bw.write("		String edit_type = "+pt+".getEdit_type();\r\n");
   		 bw.write("		int result = 0;\r\n");
   		 bw.write("		if (StrUtils.isEmpty(edit_type)){\r\n");
   		 bw.write("			return result;\r\n");
   		 bw.write("		}\r\n");
   		 bw.write("		if (\"insert\".equalsIgnoreCase(edit_type)){\r\n");
   		 bw.write("			result = "+pt+"Mapper.insert("+pt+");\r\n");
   		 bw.write("		}else if (\"update\".equalsIgnoreCase(edit_type)){\r\n");
   		 bw.write("			result = "+pt+"Mapper.update("+pt+");\r\n");
   		 bw.write("		}\r\n");
   		 bw.write("		return result;\r\n");
	     bw.write("	}\r\n");
	     bw.write("}\r\n");
	     bw.flush(); 
	     fos.close(); 
	     
	     //生成Controller文件
	     file = new File(p+pa.get(3).replace(".", "/")+"/"+bt+"Controller.java"); 
	     if(file.exists()) 
	         file.delete(); 
	     fos = new FileOutputStream(p+pa.get(3).replace(".", "/")+"/"+pt.substring(0,1).toUpperCase()+pt.substring(1).toLowerCase()+"Controller.java");    
	     bw = new java.io.BufferedWriter(new OutputStreamWriter(fos, "UTF-8"));
	     bw.write("package "+pa.get(3)+";\r\n");
	     bw.write("\r\n");
	     bw.write("import java.util.HashMap;\r\n");
	     bw.write("\r\n");
	     bw.write("import javax.annotation.Resource;\r\n");
	     bw.write("import javax.servlet.http.HttpServletRequest;\r\n");
	     bw.write("import javax.servlet.http.HttpSession;\r\n");
	     bw.write("\r\n");
	     bw.write("import org.springframework.stereotype.Controller;\r\n");
	     bw.write("import org.springframework.ui.Model;\r\n");
	     bw.write("import org.springframework.web.bind.annotation.RequestMapping;\r\n");
	     bw.write("import org.springframework.web.bind.annotation.RequestMethod;\r\n");
	     bw.write("import org.springframework.web.bind.annotation.ResponseBody;\r\n");
	     bw.write("\r\n");
	     bw.write("import "+pa.get(0)+"."+bt+";\r\n");
	     bw.write("import "+pa.get(2)+"."+bt+"Service;\r\n");
	     bw.write("import com.utils.StrUtils;\r\n");
	     bw.write("import com.utils.common.Json;\r\n");
	     bw.write("\r\n");
	     bw.write("@Controller\r\n");
	     bw.write("@RequestMapping(\"/"+pt+"\")\r\n");
	     bw.write("public class "+pt.substring(0,1).toUpperCase()+pt.substring(1).toLowerCase()+"Controller {\r\n");
	     bw.write("	@Resource\r\n");
	     bw.write("	private "+bt+"Service "+pt+"Service;\r\n");
	     bw.write("	\r\n");
	     bw.write("	@RequestMapping(value = \"/index\",method = RequestMethod.GET)	\r\n");
	     bw.write("	public String index(Model model,HttpSession session, HttpServletRequest request) {\r\n");
	     bw.write("		return \""+pt+"/index_"+pt+"\";\r\n");
	     bw.write("	}\r\n");
	     bw.write("	\r\n");
	     bw.write("	@RequestMapping(value = \"/list\",method = RequestMethod.GET)	\r\n");
	     bw.write("	@ResponseBody\r\n");
	     bw.write("	public HashMap<String, Object> list(HttpSession session, HttpServletRequest request) {\r\n");
	     bw.write("		String page = StrUtils.GetString(request.getParameter(\"page\"));\r\n");
	     bw.write("		String pagesize = StrUtils.GetString(request.getParameter(\"rows\"));\r\n");
	     bw.write("		String sortname = StrUtils.GetString(request.getParameter(\"sort\"));\r\n");
	     bw.write("		String sortorder = StrUtils.GetString(request.getParameter(\"order\"));\r\n");
	     bw.write("		if (\"\".equals(page)) {\r\n");
	     bw.write("			page = \"1\";\r\n");
	     bw.write("		}\r\n");
	     bw.write("		if (\"\".equals(pagesize)) {\r\n");
	     bw.write("			pagesize = \"15\";\r\n");
	     bw.write("		}\r\n");
	     bw.write("		if (\"\".equals(sortname)) {\r\n");
	     bw.write("			sortname=\"id\";\r\n");
	     bw.write("		}\r\n");
	     bw.write("		if (\"\".equals(sortorder)) {\r\n");
	     bw.write("			sortorder =\"desc\";\r\n");
	     bw.write("		}\r\n");
	     bw.write("		HashMap<String, Object> map = new HashMap<String, Object>();\r\n");
	     bw.write("		int p = (Integer.valueOf(page)-1)*Integer.valueOf(pagesize);\r\n");
	     bw.write("		map.put(\"limit\", p+\",\"+pagesize);\r\n");
	     bw.write("		map.put(\"orderby\", sortname + \" \" + sortorder);\r\n");
	     bw.write("		return "+pt+"Service.select_list(session, map);\r\n");
	     bw.write("	}\r\n");
	     bw.write("	\r\n");
	     bw.write("	@RequestMapping(value = \"/form\",method = RequestMethod.GET)	\r\n");
	     bw.write("  public String form(Model model,HttpSession session, HttpServletRequest request) {\r\n");
	     bw.write("		String edit_type = request.getParameter(\"edit_type\");\r\n");
	     bw.write("		String url = null;\r\n");
	     bw.write("	if (\"add\".equalsIgnoreCase(edit_type)) {\r\n");
	     bw.write("		url = \""+pt+"/form_"+pt+"\";\r\n");
	     bw.write("	} else if (\"edit\".equalsIgnoreCase(edit_type))  {\r\n");
	     bw.write("		url = \""+pt+"/form_"+pt+"\";\r\n");
	     bw.write("	}\r\n");
	     bw.write("		return url;\r\n");
	     bw.write(" }\r\n");
	     bw.write("	\r\n");
	     bw.write("	@RequestMapping(value = \"/save\",method = RequestMethod.POST)	\r\n");
	     bw.write("	@ResponseBody\r\n");
	     bw.write(" public Json save("+bt+" "+pt+",HttpSession session, HttpServletRequest request) {\r\n");
	     bw.write("		Json j = new Json();\r\n");
	     bw.write("		"+pt+"Service.save("+pt+", session);\r\n");
	     bw.write("		j.setSuccess(true);\r\n");
	     bw.write("		j.setMsg(\"操作成功！\");\r\n");
	     bw.write("		return j;\r\n");
	     bw.write("	 }\r\n");
	     bw.write(" }\r\n");
	     
	     bw.close(); 
	     fos.close(); 
	     tipStr+="<br/>"; 
	     tipStr+="已经生成:<br/>"; 
	     tipStr+="<br/>"; 
	     tipStr+="    实体类:<br/>"; 
	     tipStr+="    "+pa.get(0)+"."+bt+".java{<br/>"; 
	     tipStr+="    字段...<br/>"; 
	     tipStr+="    "+bt+"(){}<br/>"; 
	     tipStr+="    "+bt+"(所有字段)<br/>"; 
	     tipStr+="    }<br/>"; 
	     tipStr+="<br/>"; 
	     tipStr+="    mapper,dao:<br/>"; 
	     tipStr+="    select"+bt+"ByRid(String 表id)<br/>"; 
	     tipStr+="    select"+bt+"<br/>"; 
	     tipStr+="    select"+bt+"Query(String 条件)<br/>"; 
	     tipStr+="    insert"+bt+"(实体)<br/>"; 
	     tipStr+="    delete"+bt+"<br/>"; 
	     tipStr+="    update"+bt+"(实体)<br/>"; 
	     }
	 
	 
	%>
	<%!
	public static Boolean Create(String path) {

		StringTokenizer st = new StringTokenizer(path, "/");
		String path1 = st.nextToken() + "/";
		String path2 = path1;
		while (st.hasMoreTokens()) {
			path1 = st.nextToken() + "/";
			path2 += path1;
			File inbox = new File(path2);
			if (!inbox.exists())
				inbox.mkdir();
		}
		return true;

	}
	%>
	<script type="text/javascript"> 
     document.getElementById("tip").innerHTML='<%=tipStr%>';
	</script>
</body>
</html>
