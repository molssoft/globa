<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->
<!-- #include file = "piet_inc.asp" -->

<%
dim conn
openconn

docstart "Èarteru atskaite","y1.jpg"
%>
<center><font color="GREEN" size="5"><b>Èarteru atskaite</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

grupa = getparameter("charter")
carter_firma = request.form("carter_firma")
%>

<form name="forma" action="atsk_char.asp" method="POST">
<table>
<tr>
	<td align="right" bgcolor="#ffc1cc">Datums <b>no: </td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" maxlength="10" name="sak_dat1" value="<%=request.form("sak_dat1")%>"> <b>lîdz:</b> 
		<input type="text" size="8" maxlength="10" name="beigu_dat1" value="<%=request.form("beigu_dat1")%>"> 
	</td>
</tr>
<tr>
	<td align="right" bgcolor="#ffc1cc">Datums(2) <b>no: </td>
	<td bgcolor="#fff1cc">
		<input type="text" size="8" maxlength="10" name="sak_dat2" value="<%=request.form("sak_dat2")%>"> <b>lîdz:</b> 
		<input type="text" size="8" maxlength="10" name="beigu_dat2" value="<%=request.form("beigu_dat2")%>"> 
	</td>
</tr>


<tr><td align="right" bgcolor="#ffc1cc">Pakalpojums:</td>
<td>
<%
vid = getpakalpojums(1)
i = 1
if vid = "" then vid = 0
if request.form("Poga") = "Tîra forma" then vid = 0
output = VietuVeidiCombo(grupa,vid,i,virsn,lim)
if vid <> 0 then
	output = output + VietuVeidiSubCombo(vid,i,lim)
	lim = lim + 2
else
	lim = lim + 1
end if
while lim<5
	output = output + "<span id = ""vieta" + cstr(i) + "_" + cstr(lim) + """></span>"
	lim = lim + 1
wend
while virsn<>0
	vid = virsn
	output = VietuVeidiCombo(grupa,vid,i,virsn,lim) + output
wend
response.write output
GenerateComplexLevels grupa,i
%>
</td>
<tr> 
 <td align="right" bgcolor="#ffc1cc">Èartera firma:</td>
 <td bgcolor="#fff1cc"><%DbComboPlus "Carter_firmas","nosaukums","id","carter_firma",carter_firma%></td>
</tr>
<tr><td align="right" bgcolor="#ffc1cc">Periods</td><td bgcolor="#fff1cc">
	<select name="periods">
		<option <%if request.form("periods") = "day" then response.write " selected "%> value="day">Diena</option>
		<option <%if request.form("periods") = "month" then response.write " selected "%> value="month">Mçnesis</option>
		<option <%if request.form("periods") = "year" then response.write " selected "%> value="year">Gads</option>
	</select></td></tr>
</table>
<input type="image" src="impro/bildes/skatit.jpg" name="skatit" WIDTH="116" HEIGHT="25">
<p>

<table>
	<tr>
		<td valign=top>
			<%PrintTable("1")%>
		</td>
		<%if Request.Form("sak_dat2")<>"" then%>
			<td width=20>
			</td>
			<td valign=top>
				<%PrintTable("2")%>
			</td>
		<% end if %>
	</tr>
</table>


</form>
</body>
</html>

<%
Function GetPakalpojums(rinda_p)
for i_l = 4 to 1 step -1
	if request.form("viet_veid"+cstr(rinda_p)+"_"+cstr(i_l)) <> "" and request.form("viet_veid"+cstr(rinda_p)+"_"+cstr(i_l)) <> 0 then
		GetPakalpojums = request.form("viet_veid"+cstr(rinda_p)+"_"+cstr(i_l))
		exit function
	end if
next
GetPakalpojums = GetNum(request.form("viet_veid"+cstr(rinda_p)+"_1"))
End Function

Function CurrPrint(x)
 CurrPrint = cstr(getnum(x))
 if instr(currprint,".")=0 then currprint = currprint + ".00"
 if instr(currprint,".")=len(currprint)-1 then currprint = currprint + "0"
End Function

Sub PrintTable (num)
vid = getpakalpojums(1)
if request.form("skatit.x") <> "" then
	periods = Request.Form("periods")
	if request.form("periods") = "day" then qb = "SELECT str(DatePart(yyyy,datums)) + '/' + str(DatePart(mm,datums))+'/'+str(DatePart(dd,datums)) as dat,count(distinct pid) as sk, Sum(piet_saite.cenaLVL) as smLVL, Sum(piet_saite.cenaUSD) as smUSD "
	if request.form("periods") = "month" then qb = "SELECT str(DatePart(yyyy,datums))+'/'+str(DatePart(mm,datums)) as dat,count(distinct pid) as sk, Sum(piet_saite.cenaLVL) as smLVL, Sum(piet_saite.cenaUSD) as smUSD "
	if request.form("periods") = "year" then qb = "SELECT str(DatePart(yyyy,datums)) as dat,count(distinct pid) as sk, Sum(piet_saite.cenaLVL) as smLVL, Sum(piet_saite.cenaUSD) as smUSD "
	qb = qb + " FROM piet_saite inner join pieteikums on piet_saite.pid = pieteikums.id where piet_saite.deleted = 0 and pieteikums.deleted = 0 and pieteikums.gid = "+cstr(grupa)
	if request.form("sak_dat"+num) <> "" then
		qb = qb + " AND datums >= '"+SQLDate(request.form("sak_dat"+num)) + "' "
	end if
	if request.form("beigu_dat"+num) <> "" then
		qb = qb + " AND datums < '"+SQLDate(formateddate(request.form("beigu_dat"+num),"dmy")+1) + "' "
	end if
	if vid <> "0" then
		qb = qb + " AND vietas_veids IN (" + GetPakalpojumsSet(cstr(vid)) + ")"
		'qb = qb + " AND vietas_veids IN (" + cstr(vid) + ")"
	end if
	if request.form("carter_firma") <> "0" then
		qb = qb + " AND carter_firma = "+request.form("carter_firma") + " "
	end if
	if request.form("periods") = "day" then qb = qb + " GROUP BY str(DatePart(yyyy,datums)) + '/' + str(DatePart(mm,datums))+'/'+str(DatePart(dd,datums)) order by str(DatePart(yyyy,datums)) + '/' + str(DatePart(mm,datums))+'/'+str(DatePart(dd,datums)) "
	if request.form("periods") = "month" then qb = qb + " GROUP BY str(DatePart(yyyy,datums))+'/'+str(DatePart(mm,datums)) order by str(DatePart(yyyy,datums))+'/'+str(DatePart(mm,datums)) "
	if request.form("periods") = "year" then qb = qb + " GROUP BY str(DatePart(yyyy,datums)) order by str(DatePart(yyyy,datums)) "

	set rec = server.createobject("ADODB.Recordset")
	rec.open qb,conn,3,3
	'Response.Write qb
	'rec.open "select * from piet_saite where id = 0",conn,3,3
	if rec.recordcount <> 0 then %>
		<center>
		<table >
		<tr bgcolor="#ffc1cc">
		<th>Datums</th>
		<th>Skaits</th>
		<th>Summa LVL</th>
		<th>Summa USD</th>
		</tr>
		<% 
		kop_sk = 0
		kop_smLVL = 0
		kop_smUSD = 0
		if periods = "day" then

			'Nosaka sakuma un beigu datumu
			if Request.Form("sak_dat"+num) = "" then
			 sak_dat = formateddate(rec("dat"),"ymd")
			else
			 sak_dat = formateddate(Request.Form("sak_dat"+num),"dmy")
			end if
			if Request.Form("beigu_dat"+num) = "" then
			 rec.MoveLast
			 beigu_dat = formateddate(rec("dat"),"ymd")
			 rec.MoveFirst
			else
			 beigu_dat = formateddate(Request.Form("beigu_dat"+num),"dmy")
			end if
			tek_dat = sak_dat

			while not rec.eof 
			if formateddate(rec("dat"),"ymd")=tek_dat then
				'rinda ar datiem
				%>
				<tr bgcolor="#fff1cc">
					<td align="right"><%=dateprint(tek_dat)%></td>
					<td align="right"><b><%=cstr(rec("sk"))%></b></td>
					<td align="right"><b><%=currprint(rec("smLVL"))%></b></td>
					<td align="right"><b><%=currprint(rec("smUSD"))%></b></td>
				</td></tr>
				<% 
				kop_sk = kop_sk + getnum(rec("sk"))
				kop_smLVL = kop_smLVL + getnum(rec("smLVL"))
				kop_smUSD = kop_smUSD + getnum(rec("smUSD"))
				rec.movenext
			else
				'tukða rinda
				%>
				<tr bgcolor="#fff1cc">
					<td align="right"><%=dateprint(tek_dat)%></td>
					<td align="right"><b>0</b></td>
					<td align="right"><b>0.00</b></td>
					<td align="right"><b>0.00</b></td>
				</td></tr>
				<%
			end if
			tek_dat = tek_dat+1
			wend 
			
			'Pçdçjâs tukðâs rindas (ja ir)
			for tek_dat = tek_dat to beigu_dat
				%>
				<tr bgcolor="#fff1cc">
					<td align="right"><%=dateprint(tek_dat)%></td>
					<td align="right"><b>0</b></td>
					<td align="right"><b>0.00</b></td>
					<td align="right"><b>0.00</b></td>
				</td></tr>
				<%
			next
		end if

		if periods = "month" then

			'Nosaka sakuma un beigu datumu
			if Request.Form("sak_dat"+num) = "" then
			 sak_dat = formateddate(rec("dat")+" 1","ymd")
			else
			 sak_dat = formateddate(Request.Form("sak_dat"+num)+" 1","dmyd")
			end if
			if Request.Form("beigu_dat"+num) = "" then
			 rec.MoveLast
			 beigu_dat = formateddate(rec("dat")+" 1","ymd")
			 rec.MoveFirst
			else
			 beigu_dat = formateddate(Request.Form("beigu_dat"+num)+" 1","dmyd")
			end if
			tek_dat = sak_dat

			while not rec.eof 
			if formateddate(rec("dat")+" 1","ymd")=tek_dat then
				'rinda ar datiem
				%>
				<tr bgcolor="#fff1cc">
					<td align="right"><%=cstr(month(tek_dat))+"/"+cstr(year(tek_dat))%></td>
					<td align="right"><b><%=cstr(rec("sk"))%></b></td>
					<td align="right"><b><%=currprint(rec("smLVL"))%></b></td>
					<td align="right"><b><%=currprint(rec("smUSD"))%></b></td>
				</td></tr>
				<% 
				kop_sk = kop_sk + getnum(rec("sk"))
				kop_smLVL = kop_smLVL + getnum(rec("smLVL"))
				kop_smUSD = kop_smUSD + getnum(rec("smUSD"))
				rec.movenext
			else
				'tukða rinda
				%>
				<tr bgcolor="#fff1cc">
					<td align="right"><%=cstr(month(tek_dat))+"/"+cstr(year(tek_dat))%></td>
					<td align="right"><b>0</b></td>
					<td align="right"><b>0.00</b></td>
					<td align="right"><b>0.00</b></td>
				</td></tr>
				<%
			end if
			tek_dat = dateserial(year(tek_dat),month(tek_dat)+1,day(tek_dat))
			wend 
			
			'Pçdçjâs tukðâs rindas (ja ir)
			while tek_dat < beigu_dat
				%>
				<tr bgcolor="#fff1cc">
					<td align="right"><%=cstr(month(tek_dat))+"/"+cstr(year(tek_dat))%></td>
					<td align="right"><b>0</b></td>
					<td align="right"><b>0.00</b></td>
					<td align="right"><b>0.00</b></td>
				</td></tr>
				<%
				tek_dat = dateserial(year(tek_dat),month(tek_dat)+1,day(tek_dat))
			wend
		end if

		if periods = "year" then

			'Nosaka sakuma un beigu datumu
			if Request.Form("sak_dat"+num) = "" then
			 sak_dat = formateddate(rec("dat")+" 1 1","ymd")
			else
			 sak_dat = formateddate(Request.Form("sak_dat"+num)+" 1 1","dmymd")
			end if
			if Request.Form("beigu_dat"+num) = "" then
			 rec.MoveLast
			 beigu_dat = formateddate(rec("dat")+" 1 1","ymd")
			 rec.MoveFirst
			else
			 beigu_dat = formateddate(Request.Form("beigu_dat"+num)+" 1 1","dmymd")
			end if
			tek_dat = sak_dat

			while not rec.eof 
			if formateddate(rec("dat")+" 1 1","ymd")=tek_dat then
				'rinda ar datiem
				%>
				<tr bgcolor="#fff1cc">
					<td align="right"><%=cstr(year(tek_dat))%></td>
					<td align="right"><b><%=cstr(rec("sk"))%></b></td>
					<td align="right"><b><%=currprint(rec("smLVL"))%></b></td>
					<td align="right"><b><%=currprint(rec("smUSD"))%></b></td>
				</td></tr>
				<% 
				kop_sk = kop_sk + getnum(rec("sk"))
				kop_smLVL = kop_smLVL + getnum(rec("smLVL"))
				kop_smUSD = kop_smUSD + getnum(rec("smUSD"))
				rec.movenext
			else
				'tukða rinda
				%>
				<tr bgcolor="#fff1cc">
					<td align="right"><%=cstr(year(tek_dat))%></td>
					<td align="right"><b>0</b></td>
					<td align="right"><b>0.00</b></td>
					<td align="right"><b>0.00</b></td>
				</td></tr>
				<%
			end if
			tek_dat = dateserial(year(tek_dat)+1,month(tek_dat),day(tek_dat))
			wend 
			
			'Pçdçjâs tukðâs rindas (ja ir)
			while tek_dat < beigu_dat
				%>
				<tr bgcolor="#fff1cc">
					<td align="right"><%=cstr(year(tek_dat))%></td>
					<td align="right"><b>0</b></td>
					<td align="right"><b>0.00</b></td>
					<td align="right"><b>0.00</b></td>
				</td></tr>
				<%
				tek_dat = dateserial(year(tek_dat)+1,month(tek_dat),day(tek_dat))
			wend
		end if
		%>
		
		<tr bgcolor="#bbbbbb">
			<td align="right"><b>Kopâ:</td>
			<td align="right"><b><%=kop_sk%></b></td>
			<td align="right"><b><%=currprint(kop_smLVL)%></b></td>
			<td align="right"><b><%=currprint(kop_smUSD)%></b></td>
		</td></tr>
	
		</table>
		
	<% else %>
		Nav informâcijas par doto laika intervâlu.
	<% end if
end if 


End Sub
%>