<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
docstart "Paziòojums","y1.jpg"
dim conn
openconn


if Request.Form("subm") = 1 then

 id = Request.form("oid")
 datums = formateddate(Request.Form("datums"),"dmy") 
 konts = Request.Form("konts")
 
 set r = conn.execute("select * from orderis where id = "+id)

 'zilo krasu un kontu uzliek tikai izmaksam un iemaksam
 if getnum(r("pid"))=0 or getnum(r("nopid"))=0 then
 
	'''un tikai bankai
	if r("maks_veids")="banka" then
 
		zils = Request.form("zils")
		rekina_nr = Request.form("rekina_nr")
	
		if zils = "on" then
			whereC = ", zils=1"
		end if
	
		if rekina_nr<>"" then
			if getnum(r("pid"))=0 and getnum(r("nopid"))<>0 then 'izmaksa
				'--- IZMAINITS	izmaksaam debets 2.3.4.X (5.juul 2012 Jânis B., Saiva) Nils 
				whereC = whereC + ", debets='2.3.4.X',kredits='"+konts+"', rekins=" & rekina_nr
			else 'iemaksa (bez izmainjam)
				whereC = whereC + ", kredits='2.3.4.X',debets='"+konts+"', rekins=" & rekina_nr
			end if
		end if
	
	end if
  
  else 'parskaitijums 
  
  '--- Pielikts else zars, kurð nomaina pârskaitîjuma kredîtkontu. 11.07.2007 Nils 
  
	if r("maks_veids")="banka" then
		pieteikuma_rekviziti r("nopid"),nokonts,noresurss
		whereC = whereC + ", debets='" + nokonts + "'" 
	end if
  
  end if
  
  rw "-> "+noresurss
 
 'rw "update orderis set parbaude = 0, need_check=1, datums = '"+sqldate(datums)+"'"+whereC+" where id = "+id
 'Response.End
 
 conn.execute "update orderis set parbaude = 0, need_check=1, datums = '"+sqldate(datums)+"'"+whereC+" where id = "+id
 LogAction "orderis",id,"Apstiprinâja"
 

 if getnum(r("pid")) <> 0 and getnum(r("nopid")) = 0 then
  Response.Redirect "drukord.asp?oid="+id+"&drukat=1"
 elseif getnum(r("pid")) = 0 and getnum(r("nopid")) <> 0 then
  Response.Redirect "drukord_izm.asp?oid="+id+"&drukat=1"
 else
  Response.Redirect "ordedit.asp?oid="+id
 end if

else

 id = Request.QueryString("oid")
 set r = conn.execute("select * from orderis where id = "+id)

end if

%>

<center>
<font face="Tahoma" size=4>
  <form name=forma action=agenti_nauda_apst.asp method=POST>
   <table>
    <tr>
     <td align=right>Reìistrçts</td>
     <td><%=DatePrint(r("datums"))%></td>
    </tr>
    <tr>
     <td align=right>Apstiprinâts</td>
     <td><input type = text name=datums value=<%=dateprint(now)%> size=9></td>
    </tr>
    <tr>
     <td align=right>Maksâtâjs</td>
     <td><%=r("kas")%></td>
    </tr>
    <tr>
     <td align=right>Pamatojums</td>
     <td><%=r("pamatojums")%></td>
    </tr>
    
    <% if r("maks_veids")="banka" then%>
    <tr>
     <td align=right>Rçíina Nr.</td>
     <td><input type="text" name="rekina_nr" size="9"></input></td>
    </tr>
    <tr>
     <td align=right>Konts</td>
     <td>
		<select name=konts>
			<option value="2.6.2.4.5">26245 Swedbanka</option>
			<option value="2.6.2.2.1">26212 Citadele</option>
			<option value="2.6.2.2.1">26221 DNB</option>
			<option value="2.6.2.3.1">26231 Nordea</option>
			<option value="2.6.2.6.1">26261 SEB</option>
		</select>
		</input></td>
    </tr>
    <tr>
     <td align=right>Zils</td>
     <td><input type="checkbox" name="zils"></input></td>
    </tr>    
    <% end if%>
   
   </table>
   <input type=hidden name=oid value=<%=id%>>
   <input type=hidden name=subm value="1">
   <input type=submit value=Apstiprinât name=poga>
  </form>
</font>
</body>
</html>
