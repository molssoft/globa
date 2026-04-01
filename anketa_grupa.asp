<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
DocStart "Anketu ievade","y1.jpg"
dim conn
OpenConn
if not isaccess(T_ANKETAS) then 
 Response.Redirect("default.asp")
end if

%>
<font face=Tahoma>
<Center><font size=4>Anketas</font>

<br><br>
<form name=fdatums method=post action=c_anketas.php>
<table>
<tr>
	<td bgcolor = #ffc1cc align="right"><strong>Grupas kods:</strong></td>
	<td bgcolor = #fff1cc colspan="3"><input type=text name=kods value="<%=request.Form("kods")%>" ID="Text1"></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc align="right"><strong>Grupas kurators:</strong></td>
	<td bgcolor = #fff1cc colspan="3"> <select name=kurators>
	<option value="0">-</option>
	<% set rKurators = conn.execute("select vards as v,* from lietotaji where exists (select * from tiesibusaites where lietotajsid = lietotaji.id and tiesibasid=12)  order by dbo.fn_str_to_num(ltrim(uzvards))")
	while not rKurators.eof
	 response.write "<option value="+cstr(rKurators("id"))+" "
	 if cstr(rKurators("id")) = kurators then response.write " selected "
	 response.write ">"+rKurators("uzvards")+" "+rKurators("v")
	 response.write "</Option>"
	 rKurators.movenext
	wend
	%></select></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc align="right"><strong>Izbraukðanas datums no:</strong></td>
	<td bgcolor = #fff1cc><input type=text name=datums_no value="<%=request.Form("datums_no")%>" ID="Text1"></td>
	<td bgcolor = #ffc1cc ><strong>lîdz:</strong></td><td bgcolor = #fff1cc><input type=text name=datums_lidz value="<%=request.Form("datums_lidz")%>" ID="Text1"></td>
</tr>

<tr>
	<td bgcolor = #ffc1cc align="right"><strong>Valsts:</strong></td>
	<td bgcolor = #fff1cc colspan="3"><%Dim valstis: Set valstis = conn.execute("select id, title from valstis where globa = 1 order by dbo.fn_str_to_num(ltrim(title)) asc")
%>
<select name=valsts size=1>
<option value="0">---Visas</option>
<%

valID = "---Visas"
while not valstis.eof
 Response.Write "<option "
 if request.form("valsts") = cstr(valstis("id")) then response.write "selected"
 response.write " value='" & cstr(valstis("id")) & "'>" & valstis("title") & "</option>"
 valstis.MoveNext
wend

 %></select></td>
</tr>

</table>
	
	<input type=submit value="Meklçt" ID="Submit2" NAME="meklet"><br><br>
</form>
<%
'grupas kas jau bijuðas bet nav vecâkas par gadu
q = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
"FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
"WHERE (kods like '__.V%' or kods like '__.P%' or kods like '__.S%') and beigu_dat<'"+sqldate(now)+"' and beigu_dat>'"+sqldate(now-700)+"' and not grupa.id in (select gid from anketas) " + _
"ORDER BY grupa.sakuma_dat desc;"

set rGrupas = conn.execute(q)
%>

<!--form name=forma action=anketas.asp>
<select name=gid>
 <option selected value=0>Grupas bez anketâm</option>
 <% while not rGrupas.eof
  %><option value=<%=rGrupas("id")%>><%=DatePrint(rGrupas("sak"))+" "+rgrupas("kods")+" "+rgrupas("v")%></option><%
  rGrupas.movenext
 wend %>
</select><br><br>
<input type=submit value="Apskatît"><br><br>
</form-->

<%
'grupas ar anketâm
q = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
"FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
"WHERE (kods like '__.V%' or kods like '__.P%' or kods like '__.S%') and beigu_dat<'"+sqldate(now)+"' and beigu_dat>'"+sqldate(now-1000)+"' and grupa.id in (select gid from anketas) " + _
"ORDER BY grupa.sakuma_dat desc;"

set rGrupas = conn.execute(q)
%>

<form name=forma2 action=c_anketas.php>
<select name=gid>
 <option selected value=0>Grupas ar anketâm</option>
 <% while not rGrupas.eof
  %><option value=<%=rGrupas("id")%>><%=DatePrint(rGrupas("sak"))+" "+rgrupas("kods")+" "+rgrupas("v")%></option><%
  rGrupas.movenext
 wend %>
</select><br><br>
<input type=submit value="Apskatît" id=submit1 name=submit1><br><br>
</form>

<a href=default.asp>Uz mâjâm</a>