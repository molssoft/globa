<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn
docstart "Pieteikuma grupas maiòa","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Pieteikuma grupas maiòa</b></font><hr>
<%
headlinks 
%>
<br><br>
<font size=4>
<b>Lai nomainîtu pieteikuma grupu tiks izveidots jauns pieteikums<br>
un tiks veikts naudas pârskaitîjums no vecâ pieteikuma uz jauno.<br>
Izvçlieties jaunâ pieteikuma grupu.<br><br>
<form name=forma action = 'grupas_maina2.asp' method = POST>
<% 
pid = Request.QueryString("pid")
set pieteikums_l = conn.execute ("select * from pieteikums where id = " +cstr(pid))
set piet_saite_l = conn.execute ("select * from piet_saite where pid = " +cstr(pid))
set dalibn_l = conn.execute ("select * from dalibn where id = " + cstr(piet_saite_l("did")))
'-------- Izdrukâ grupu sarakstu ---------------
gid = getnum(pieteikums_l("gid"))
dim grupas_l
dim q_l
if viss = 1 then
    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID WHERE not marsruts.v like '!Att%' ORDER BY marsruts.v, grupa.sakuma_dat;"
else
    q_l = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
    "FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
    "WHERE sakuma_dat >= '" + SQLDate(now-5) + "' OR (marsruts.v like '!%' and not marsruts.v like '!Att%') OR marsruts.v like 'Kompleksie%' " + _
    " ORDER BY marsruts.v, grupa.sakuma_dat;"
end if
Set grupas_l = conn.execute(q_l)
if iemsk > 0 then
	Response.Write "<select name='gID' disabled size='1' value='6'>"
else
	Response.Write "<select name='gID' size='1' value='6'>"
end if
do while not grupas_l.eof
Response.Write "<option "
if gid<>0 and trim(gid)=trim(getnum(grupas_l("ID"))) then response.write "selected "
response.write "value='" & grupas_l("ID") & "'>" 
response.write nullprint(grupas_l("v"))+ " "+dateprint(grupas_l("sak"))+" "+nullprint(grupas_l("kods"))+"</option>"
grupas_l.MoveNext
loop
Response.write " </select>" & Chr(10)
%>
<br><br>
Pieteikums tiks izveidots dalîbniekam: 
<%=dalibn_l("vards")%><%=" "%>  
<%=dalibn_l("uzvards")%> <%=" "%>  
<%=dalibn_l("nosaukums")%><br><br>
<input type = submit value = "Izveidot jaunu pieteikumu" name="poga">
<input type = hidden name="pid" value=<%=pid%>>
<input type = hidden name="did" value=<%=dalibn_l("id")%>>
</form>