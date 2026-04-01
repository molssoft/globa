<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "allproc.asp" -->

<%


dim conn
openconn


if Request.QueryString("pid")<>"" Then
 pid = Request.QueryString("pid")
 Set rpiet = conn.execute("select * from pieteikums where id = "+CStr(pid))
 gid = rpiet("gid")

 set rx = conn.execute("select * from pieteikums where bilanceLVL <> 0 and id = "+pid)
 if not rx.eof Then
	If rx("bilanceLVL") > 0 then
		pamatojums = "Valutas konvertacija, pareja uz EIRO"
		summaLVL = rx("bilanceLVL")
		summaEUR = Round100(rx("bilanceLVL")/EUR_RATE)
	   InsertOpConv rx("id"),rx("id"),CDate("1/1/2014"),"KONVERTACIJA",pamatojums,"","","",summaLVL,"LVL",summaLVL,0,0,summaEUR,0
	Else
		pamatojums = "Valutas konvertacija, pareja uz EIRO"
		summaLVL = -rx("bilanceLVL")
		summaEUR = -Round100(rx("bilanceLVL")/EUR_RATE)
	   InsertOpConv rx("id"),rx("id"),CDate("1/1/2014"),"KONVERTACIJA",pamatojums,"","","",summaEUR,"EUR",0,summaEUR,summaLVL,0,0
	End if

  pieteikums_recalculate rx("id")
  %><HTML><HEAD><META HTTP-EQUIV="REFRESH" CONTENT="1; URL=pieteikums.asp?pid=<%=pid%>"></HEAD><BODY><br><% 
  %>EUR Konvertacija<%
%></BODY></HTML><%
 End if
end if

if Request.QueryString("gid")<>"" then
 gid = Request.QueryString("gid")
 set rx = conn.execute("select * from pieteikums where gid = "+gid+" and deleted = 0 and bilanceLVL <> 0 and id > 100000")
 set rxc = conn.execute("select count(*) as c from pieteikums where gid = "+gid+" and deleted = 0 and bilanceLVL <> 0 and id > 100000")
 if not rx.eof Then
	If rx("bilanceLVL") > 0 then
		pamatojums = "Valutas konvertacija, pareja uz EIRO"
		summaLVL = rx("bilanceLVL")
		summaEUR = Round100(rx("bilanceLVL")/EUR_RATE)
	   InsertOpConv rx("id"),rx("id"),CDate("1/1/2014"),"KONVERTACIJA",pamatojums,"","","",summaLVL,"LVL",summaLVL,0,0,summaEUR,0
	Else
		pamatojums = "Valutas konvertacija, pareja uz EIRO"
		summaLVL = -rx("bilanceLVL")
		summaEUR = -Round100(rx("bilanceLVL")/EUR_RATE)
	   InsertOpConv rx("id"),rx("id"),CDate("1/1/2014"),"KONVERTACIJA",pamatojums,"","","",summaEUR,"EUR",0,summaEUR,summaLVL,0,0
	End if

  pieteikums_recalculate rx("id")
  %><HTML><HEAD><META HTTP-EQUIV="REFRESH" CONTENT="1; URL=recalculate.asp?gid=<%=gid%>"></HEAD><BODY><br><% 
  %>This was <%=rx("id")%><BR><%=rxc("c")%> to go<BR><%
%></BODY></HTML><%
 End if
end if
 
if Request.QueryString("next_pid")<>"" then
  next_pid = Request.QueryString("next_pid")
  set r = conn.execute("select max(id) from pieteikums where exists(select * from piet_saite where pid = pieteikums.id) and deleted = 0 and (atlaidesUSD<>0 or sadardzinUSD<>0 ) and id < "+cstr(next_pid))
  id = r(0)
  pieteikums_recalculate(id)
  %><HTML><HEAD><META HTTP-EQUIV="REFRESH" CONTENT="1; URL=recalculate.asp?next_pid=<%=id%>"></HEAD><BODY><br><% 
  %>This was <%=id%><BR><%
%></BODY></HTML><%
end If

if Request.QueryString("students")<>"" Then
  Set rid = conn.execute("select min(id) from pieteikums where students = 1")
  id = rid(0)
  pieteikums_recalculate(id)
  conn.execute("update pieteikums set students = 0 where id = "+CStr(id))
  %><HTML><HEAD><META HTTP-EQUIV="REFRESH" CONTENT="1; URL=recalculate.asp?students=1"></HEAD><BODY><br><% 
  %>This was <%=id%><BR><%
%></BODY></HTML><%
end If


%>

OK
