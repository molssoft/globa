<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
gid = request.querystring("gid")
session("lastgid") = gid
if gid = "" then 
	gid = -1
	message = "Nav norâdîta grupa!" 
else
	message = grupas_nosaukums(gid,NULL)
	Session("LastGid") = gid
end if

set rGrupa = conn.execute ("select * from grupa where id = "+gid)
set rMarsruts = conn.execute ("select * from marsruts where id = "+cstr(rGrupa("mid")))
%>

<%docstart "Grupas Info","y1.jpg"%>
<center><font color="GREEN" size="5"><b><%=Message%></b></font>
<%headlinks%>
<hr>
<a href = 'grupa_param.asp<%=qstring()%>'><center><font color="GREEN" size="4"><b>Grupas saraksts</b></font></a>
<a href = 'kajite.asp?gid=<%=gid%>'><center><font color="GREEN" size="4"><b>Kajîtes</b></a>, 
<a href = 'kajites_veidi.asp?gid=<%=gid%>'><b><font color = "GREEN">Kajîðu veidi</b></font></a>
<a href = 'vietu_veidi.asp?gid=<%=gid%>'><center><font color="GREEN" size="4"><b>Pakalpojumi</b></font></a>
<a href = 'pieteikumi_grupaa.asp?gid=<%=gid%>'><center><font color="GREEN" size="4"><b>Pieteikumi grupâ</b></font></a>
<a href = 'piet_summas.asp?gid=<%=gid%>'><center><font color="GREEN" size="4"><b>Pârrçíinât summas</b></font></a>
<table>
<tr>
	<td bgcolor = #ffc1cc><strong>Kods</strong></td>
	<td bgcolor = #fff1cc><%=rGrupa("kods")%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Marðruts</strong></td>
	<td bgcolor = #fff1cc><%=rMarsruts("v")%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Sâkuma datums</strong></td>
	<td bgcolor = #fff1cc><%=dateprint(rgrupa("sakuma_dat"))%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Beigu datums</strong></td>
	<td bgcolor = #fff1cc><%=dateprint(rgrupa("beigu_dat"))%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Sapulces datums</strong></td>
	<td bgcolor = #fff1cc><%=dateprint(rgrupa("sapulces_dat"))%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Vietas autobusâ</strong></td>
	<td bgcolor = #fff1cc><%=GetNum(rgrupa("vietsk"))%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Vietas naktsmîtnçs</strong></td>
	<td bgcolor = #fff1cc><%=GetNum(rgrupa("vietsk_nakts"))%></td>
</tr>
<%
query = "select sum(vietsk) as aizn from piet_saite,pieteikums where piet_saite.pid = pieteikums.id " + _
" and gid = "+cstr(gid)+" and pieteikums.deleted = 0 and piet_saite.deleted = 0 " + _
" and ((kvietas_veids in (1,2,4,5) and isnull(kid,0)<>0) or persona = 1) and (not isnull(kvietas_veids,0)=3)"
set personas = conn.execute(query)
query = "SELECT sum(piet_saite.vietsk) as sk " +_
	"FROM grupa,pieteikums,piet_saite " +_
	"WHERE grupa.id = "+cstr(gid)+ "AND grupa.id = pieteikums.gid AND piet_saite.pid = pieteikums.id AND piet_saite.papildv = 1 AND (piet_saite.deleted = 0 and pieteikums.deleted = 0);"
set pap = conn.execute(query)

set rnauda=conn.execute("select sum(summa) as ssumma,sum(iemaksas) as siemaksas,sum(izmaksas) as sizmaksas,sum(atlaides) as satlaides,sum(bilance) as sbilance from pieteikums where gid="+cstr(gid)+" and (deleted = 0)")

set ratlaides=conn.execute("select sum(atlaide) as x from piet_atlaides where uzcenojums = 0 and pid in (select id from pieteikums where gid="+cstr(gid)+" and (deleted = 0))")
set rpiemaksas=conn.execute("select sum(atlaide) as x from piet_atlaides where uzcenojums = 1 and pid in (select id from pieteikums where gid="+cstr(gid)+" and (deleted = 0))")

%>
<tr>
	<td bgcolor = #ffc1cc><strong>Personas</strong></td>
	<td bgcolor = #fff1cc><%=getnum(personas("aizn"))%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Papildvietas</strong></td>
	<td bgcolor = #fff1cc><%=getnum(pap("sk"))%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Brîvas vietas</strong></td>
	<td bgcolor = #fff1cc><%=BrivasVietasGrupa(rgrupa("id"))%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Kopçjâ summa</strong></td>
	<td bgcolor = #fff1cc><%=getnum(rnauda("ssumma"))%> LVL</td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Atlaiþu summa</strong></td>
	 <td bgcolor = #fff1cc><%=getnum(rnauda("satlaides"))+getnum(ratlaides("x"))%> LVL</td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Piemaksu summa</strong></td>
	 <td bgcolor = #fff1cc><%=getnum(rpiemaksas("x"))%> LVL</td>
</tr>

<tr>
	<td bgcolor = #ffc1cc><strong>Iemaksâtâ summa</strong></td>
	<td bgcolor = #fff1cc><%=getnum(rnauda("siemaksas"))%> LVL</td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Izmaksâtâ summa</strong></td>
	<td bgcolor = #fff1cc><%=getnum(rnauda("sizmaksas"))%> LVL</td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Kopçjâ Bilance</strong></td>
	<td bgcolor = #fff1cc><%=getnum(rnauda("sbilance"))%> LVL</td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Autobuss</strong></td>
	<td bgcolor = #fff1cc><%=rgrupa("autobuss")%></td>
</tr>
<tr>
	<td bgcolor = #ffc1cc><strong>Autobusa cena</strong></td>
	<td bgcolor = #fff1cc><%=getnum(rgrupa("autobusa_cena"))%> LVL</td>
</tr>
</table>

<hr>

</body>
</html>
