<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
DocStart "Atsauksmes","y1.jpg"
dim conn
OpenConn
headlinks
start = Request.QueryString("start")
dat_no = Formateddate(Request.QueryString("dat_no"),"dmy")
dat_lidz = Formateddate(Request.QueryString("dat_lidz"),"dmy")
if Request.QueryString("dat_no") = "" then dat_no = "01/01/1970"
if Request.QueryString("dat_lidz") = "" then dat_lidz = now
if start = "" then start = 1
%>

<center><b><font face=tahoma>
<br>Atsauksmes<br><br></b>

<%
'set r = conn.execute("select * from anketas where gid = "+gid+" order by vards")
 %>
 <form name=forma method=GET action="atsauksmes.asp">
 <table border=0 cellpadding=3>
 <tr bgcolor=lightgreen>
  <th>Periods</th>
  <th><input type=text size=10 name=dat_no value=<%=DatePrint(dat_no)%>> - <input type=text size=10 name=dat_lidz value=<%=DatePrint(dat_lidz)%>></th>
 </tr>
 </table>
 <input type=submit name=poga value="Râdît atsauksmes">
 <input type=hidden name=start value=1></input>
 
  <%
    query = "SELECT * from portal.dbo.atsauksmes where datums<'"+SQLDate(dat_lidz+1)+"' and datums>='"+SQLDate(dat_no)+"'  AND atsauksme not like '%http://%' AND atsauksme not like '%https://%' order by datums desc"
	'rw query
    set rCount = conn.execute ("SELECT count(*) as cnt from portal.dbo.atsauksmes where datums<'"+SQLDate(dat_lidz+1)+"' and datums>='"+SQLDate(dat_no)+"' AND atsauksme not like '%http://%' AND atsauksme not like '%https://%'")
    set rAtsauksmes = server.createobject("ADODB.Recordset")
	rAtsauksmes.PageSize = 10
	rAtsauksmes.open query,conn,3,3
    cnt = rCount("cnt")
    Response.Write "<br>" & cnt
    If cnt mod 10 = 1 and (cnt/10 mod 10) <> 1 then
      Response.Write " atsauksme"
    else
      Response.Write " atsauksmes"
    end if
    if not rAtsauksmes.EOF then
      rAtsauksmes.AbsolutePosition = start
    end if
    %>
     </form>
     <table width=100%>
     <tr>
       <th>Laiks</th>
       <th>Vârds</th>
       <th>Kontaktinfo</th>
       <th>Teksts</th>
     </tr>
	<%
    For i = 1 to 20
      if not rAtsauksmes.EOF then
        vards = rAtsauksmes("vards")
        epasts = rAtsauksmes("epasts")
        atsauksme = rAtsauksmes("atsauksme")
			Response.Write "<tr>"
			Response.Write "<td valign=top>" & DatePrint(rAtsauksmes("datums")) & "</td>"
			Response.Write "<td valign=top>" & vards & "</td>"
			Response.Write "<td valign=top><a href=mailto:" & epasts & ">" & epasts & "</a></td>"
			'primitiva spam aizsardziiba
			if instr(atsauksme, "http://")>0 then
				Response.Write "<td valign=top>Iespejams SPAM - zinjojums ar linkiem!</td>"
			else
				Response.Write "<td valign=top>" & atsauksme & "</td>"
			end if
			Response.Write "</tr>"
        rAtsauksmes.movenext
      end if
    next
    %>
 </table>
    <%
    For i = 1 to ((cnt+9) / 10)
      Response.Write "<a href='atsauksmes.asp?start="+cstr((i-1)*10+1)+"&dat_no="+DatePrint(dat_no)+"&dat_lidz="+DatePrint(dat_lidz)+"'>["+cstr(i)+"] </a>"
    next
  %>