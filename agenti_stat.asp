<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<!--Princips: pirmoreiz pievienojas db un dabû aìentu sarakstu, lai bûtu, no kâ izvçlçties;
tâlak: ja forma ir izsaukusi pati sevi, tad notiek otrs konnekts pie bâzes un tiek atgriezti
ieraksti, kas raksturo konkrçto aìentu.
-->

<% docstart "Aìenti","y1.jpg" %>
<meta name="expires" value="0">
<center><font color="GREEN" size="5"><b>Aìentu statistika</b></font><hr>
<%
dim conn
OpenConn
headlinks

Server.ScriptTimeout = 900

zilie = Request.Form("zilie")
orderfield = "isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))"
'orderfield=request.form("sortby")
'if orderfield="" then orderfield = "agents"

Response.Write "<p>"

if session("message") <> "" then 
	%>
	<br><font size = 4 color = red><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

%>
<table cols="2" rows="5">
<form name="forma" method="POST" action="agenti_stat.asp" border="1">
	<input type="hidden" name="submit" value="1">
<tr>
<td align="right" bgcolor="#ffc1cc">Aìents: </td>
<td align="left" bgcolor="#fff1cc" colspan="2">	<!-------Sâkas pirmâs rindas labâ ğûna-----> 
<%
'------------- Selektç aìentus --------------

set r = server.createobject("ADODB.Recordset")
r.open "Select * from agenti where aktivs = 1 ORDER BY pilseta,vards",conn,3,3
r.movefirst
if r.recordcount <> 0 then


	%>
	<select name="agents" >
		<option value = "0" <%if Request.Form("agents") = "0" then Response.Write " selected "%>>Tie kam nav aìenta</option>
		<option value = "" <%if Request.Form("agents") = "" then Response.Write " selected " %>>Visi</option>
	<% while not r.eof %> 
		<option value = "<%=r("id")%>" 
		<% if Request.Form("agents")=cstr(r("id")) then Response.Write "selected" %>
		><%=decode(r("pilseta")) + " " + decode(r("vards"))%></option>
	<%  r.movenext
	wend%>
	</select>
	</td></tr><!---------Beidzas pirmâ rinda un labâ ğûna---------->
	<!-----------------Sâkas otrâ rinda un pirmâ ğûna------------>
	<tr>
		<td align="right" halign="center" bgcolor="#ffc1cc">Ceïojums sâkas no: </td>
		<td align="left" bgcolor="#fff1cc"><input type="textbox" name="grupa_no" size="10" value="<%=Request.Form("grupa_no")%>"> lîdz <input type="textbox" name="grupa_lidz" value="<%=Request.Form("grupa_lidz")%>" size="10"></td>
	</tr>
	<!--
	<tr>
		<td align="right" halign="center" bgcolor="#ffc1cc">Pieteikuma datums no: </td>
		<td align="left" bgcolor="#fff1cc"><input type="textbox" name="no" size="10" value="<%=Request.Form("no")%>"> lîdz <input type="textbox" name="lidz" value="<%=Request.Form("lidz")%>" size="10"></td>
	</tr>
	-->
	<tr>
	 <td align="right" halign="center" bgcolor="#ffc1cc">Zilie:</td>
	 <td align="left" bgcolor="#fff1cc">
	  <select name=zilie>
	   <option value="visi" <% if zilie="visi" then Response.Write " selected "%>>Visi</option>
	   <option value="zilie" <% if zilie="zilie" then Response.Write " selected "%>>Zilie</option>
	   <option value="nezilie" <% if zilie="nezilie" then Response.Write " selected "%>>Nezilie</option>
	  </select>
	 </td>
	</tr>

	<!------piektâ rinda--------->
	<tr><td colspan="2" align="center" valign="bottom" bgcolor="#fff1cc">
	&nbsp;<br><input type="submit" value="Izpildît!" name="poga">
	</td></tr>
	</form>
	</table>
	<!---------------------------------Formas un tabulas beigas------------------>
	
<%else '' ja aìentu bâzç nav%>
	Aìentu saraksts ir tukğs, tâpçc statistika nav pieejama!
	</body></html>
<%end if%>

<!----Otrâ daïa: aìenta statistika-->
<% if request.form("submit")=1 then%>
	
	<%set d = server.createobject("ADODB.Recordset")

	datanolidz=""
	grupa_datanolidz=""

	''lauks, pçc kura jâkârto
	'orderfield=request.form("sortby")
	if orderfield<>"" then
		orderfield=" ORDER BY " +orderfield
	end if

	'uztaisa laika intervâlu atkarîbâ no formas datiem
	if Request.Form("lidz")<>"" then
		'datanolidz=datanolidz+" and isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))<='"+sqldate(Request.Form("lidz"))+ "' "
		datanolidz=datanolidz+" and pieteikums.datums<='"+sqldate(Request.Form("lidz"))+ "' "
	end if
	if Request.Form("no")<>"" then
		'datanolidz=datanolidz+" and isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))>='"+sqldate(Request.Form("no"))+"' "
		datanolidz=datanolidz+" and pieteikums.datums>='"+sqldate(Request.Form("no"))+ "' "
	end if
	
	'ceïojuma sâkuma datuma filtrs
	if Request.Form("grupa_lidz")<>"" then
		grupa_datanolidz=grupa_datanolidz+" and isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))<='"+sqldate(Request.Form("grupa_lidz"))+ "' "
	end if
	if Request.Form("grupa_no")<>"" then
		grupa_datanolidz=grupa_datanolidz+" and isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))>='"+sqldate(Request.Form("grupa_no"))+"' "
	end if

	'aìents, par kuru ir ğî statistika
	agents=request.form("agents")
	if agents<>"" and agents<>"0" then
		agents=" and agenti.id="+ agents+" "
	elseif agents = "0" then
		agents=" and isnull(agents,0)=0 "
	else
	 agents = " and isnull(agents, 0)<>0 "
	end if

	if zilie = "zilie" then
	 zilie = " and pieteikums.id in (select pid from orderis where zils = '1' and deleted<>'1')"
	elseif zilie = "nezilie" then
	 zilie = " and pieteikums.id not in (select pid from orderis where zils = '1' and deleted<>'1')"
	else
	 zilie = ""
	end if
	
	'izveido pieprasîjuma sql komandu
	qstr="Select sakuma_dat, pieteikums.agents, pieteikums.datums as piet_datums, agenti.vards, pieteikums.id, pieteikums.info, summaLVL, summaUSD, summaEUR, iemaksasLVL, iemaksasUSD, iemaksasEUR, izmaksasLVL, izmaksasUSD, izmaksasEUR, krasa,isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums)) as datums " + _
			"from (pieteikums LEFT JOIN grupa ON pieteikums.gid = grupa.id) LEFT JOIN agenti ON pieteikums.agents = agenti.id  "+ _
			"where pieteikums.deleted <> 1 and gid <> 0 " + _
			agents+datanolidz+grupa_datanolidz+zilie+orderfield
			
			 'rw qstr
			'response.end

%><hr width="100%"><%
	
	'response.write(qstr)
	'response.end
	
	d.open qstr,conn,3,3
		if d.recordcount=0 then
		response.write "Par doto aìentu nav datu"
		else
			d.movefirst %>
			<H3>Atskaite par <%
			if request.form("agents") = "" then
				response.write " visiem aìentiem"
			else
				response.write decode(d("vards"))
			end if
			%>
			</H3><P>
			<center>
			<div>
			<%
			qc=d.recordcount
			response.write Galotne(qc,"Atrasta","Atrastas")+ " "+cstr(qc)+ " "+Galotne(qc,"operâcija","operâcijas")
			%>
			</div>
			<table border=0 cols="4">
			<tr bgcolor="#ffc1cc">
				<th>Nr</th>
				<th>Aìents</th>
				<!--th>Datums</th-->
				<th>Rez. nr.</th>
				<th>Pieteikuma datums</th>
				<th>Ceïojuma sâkums</th>
				
				<th>Pieteikums</th>
				<th>Jâmaksâ</th>
				<th>Iemaksâts</th>
				<th>Aprçíinâts</th>
			</tr>
			<%
			BilanceKopa = 0
			SummaKopa = 0
			s = 0
			while not d.eof
				' Increment
				s = s + 1
				set rIemaks = conn.execute("select max(CAST(zils AS INT)) as zils from orderis where deleted = 0 and pid = " & d("id"))
				if (isaccess(T_GRAMATVEDIS) or isaccess(T_LIETOT_ADMIN)) and not rIemaks.eof and rIemaks("zils") = 1 then
				 %><tr bgcolor = lightblue><%
				else
				 %><tr bgcolor = "#fff1cc"><%
				end if %>
				<td><%=cstr(s)%></td>
				<td><%= decode(d("vards"))%></td>
				<!--td><%=DatePrint(d("datums"))%></td-->
				<td><%=d("id")%></td>
				<td><%=DatePrint(d("piet_datums"))%></td>
				<td><%=DatePrint(d("sakuma_dat"))%></td>
				<td><a href="pieteikums.asp?pid=<%=d("id")%>" target="none"><%=nullprint(d("info"))%>.</a></td>
				<td align = right><%=Curr3Print(d("summaLVL"),d("summaUSD"),d("summaEUR"))%></td>
				<td align = right><%=Curr3Print(d("iemaksasLVL")-d("izmaksasLVL"),d("iemaksasUSD")-d("izmaksasUSD"),d("iemaksasEUR")-d("izmaksasEUR"))%></td>
				<%
				set rStarp = conn.execute("select sum(summaLVL) as lvl, sum(summaUSD) as usd, sum(summaEUR) as eur from piet_starpnieciba where pid = "+cstr(d("id")))
				%><td align = right><%=Curr3Print(rStarp("lvl"),rStarp("usd"),rStarp("eur"))%></td><%
				IemaksatsLVL = IemaksatsLVL + getnum(d("iemaksasLVL"))-getnum(d("izmaksasLVL"))
				IemaksatsUSD = IemaksatsUSD + getnum(d("iemaksasUSD"))-getnum(d("izmaksasUSD"))
				IemaksatsEUR = IemaksatsEUR + getnum(d("iemaksasEUR"))-getnum(d("izmaksasEUR"))
				SummaLVL = SummaLVL + getnum(d("summaLVL"))
				SummaUSD = SummaUSD + getnum(d("summaUSD"))
				SummaEUR = SummaEUR + getnum(d("summaEUR"))
				AprekinatsLVL = AprekinatsLVL + getnum(rStarp("LVL"))
				AprekinatsUSD = AprekinatsUSD + getnum(rStarp("USD"))
				AprekinatsEUR = AprekinatsEUR + getnum(rStarp("EUR"))
				%>
				</tr>
			<%d.MoveNext
			wend
		end if
end if
	%>
<tr bgcolor = "#ffc1Ac">
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td align = right><%=Curr3Print(SummaLVL,SummaUSD,summaEUR)%></td>
	<td align = right><%=Curr3Print(IemaksatsLVL,IemaksatsUSD,IemaksatsEUR)%></td>
	<td align = right><%=Curr3Print(AprekinatsLVL,AprekinatsUSD,AprekinatsEUR)%></td>
</tr>
</table>

</body>
</html>