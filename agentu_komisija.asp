<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

pid = Request.QueryString("pid")

act = Request.Form("act")
id = Request.Form("id")

if act = "insert" then
 datums = Request.Form("datums")
 starpnieciba = Request.Form("starpnieciba")
 summaLVL = Request.Form("summaLVL")
 if summaLVL = "" then summaLVL = "0"
 summaUSD = Request.Form("summaUSD")
 if summaUSD = "" then summaUSD = "0"
 summaEUR = Request.Form("summaEUR")
 if summaEUR = "" then summaEUR = "0"
 debets = Request.Form("debets")
 kredits = Request.Form("kredits")
 resurss = Request.Form("resurss")
 conn.execute ("insert into piet_starpnieciba (datums,pid,starpnieciba,summaLVL,summausd,summaeur,lietotajs,debets,kredits,resurss,need_check) values ('"+sqldate(datums)+"',"+pid+","+starpnieciba+","+summaLVL+","+summaUSD+","+summaEUR+",'"+get_user+"','"+debets+"','"+kredits+"','"+resurss+"',1)")
end if

if act = "delete" then
 conn.execute ("delete from piet_starpnieciba where id = "+id)
end if

docstart "Aìentu komisija","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Aìentu komisija</b></font><hr>
<%
headlinks 

if session("message") <> "" then 
	%>
	<br><font size="4" color="red"><%=session("message")%></font><br>
	<%
	session("message") = ""
end if

DefJavaSubmit
JSPoints

set rP = conn.execute("select * from pieteikums where id = "+cstr(pid))
set rG = conn.execute("select * from grupa where id = "+cstr(rP("gid")))
%>
<br><br>
<% 
'pieteikumi, kuri izveidoti pirms 1. aprîïa un tie kuri izveidoti ar online iet pa normâlo komisiju
if rP("agents_izv")=true or rP("datums")<dateserial(2007,4,1) then 
	%><font color=green>Normâlâ komisija</font><%
	komisijas_izmaina = 0
else
	%><font color=red>Samazinâtâ komisija</font><%
	komisijas_izmaina = -1 '-1%
end if

'gïuks, atveram vçlreiz
set rP = conn.execute("select * from pieteikums where id = "+cstr(pid))

%>

<table>
 <tr bgcolor="#ffc1cc">
  <th>Summa</td>
  <th>Atlaides</td>
  <th>Piemaksas</td>
  <th>Kopâ</td>
 </tr>
 <tr bgcolor="#fff1cc">
  <td><%=Curr3Print(rP("summaLVL"),rP("summaUSD"),rP("summaEUR"))%></td>
  <td><%=Curr3Print(rP("atlaidesLVL"),rP("atlaidesUSD"),rP("atlaidesEUR"))%></td>
  <td><%=Curr3Print(rP("sadardzinLVL"),rP("sadardzinUSD"),rP("sadardzinEUR"))%></td>
  <td><b><%=Curr3Print(rP("summaLVL")-rP("atlaidesLVL")+rP("sadardzinLVL"),rP("summaUSD")-rP("atlaidesUSD")+rP("sadardzinUSD"),rP("summaEUR")-rP("atlaidesEUR")+rP("sadardzinEUR"))%></td>
 </tr>
</table>

<form name="forma" method="POST" action=agentu_komisija.asp?pid=<%=pid%>>
<table border=0>
	<tr bgcolor="#ffc1cc">
  <th>Datums</td>
  <th>Noteikums</td>
  <th>LVL</td>
  <th>USD</td>
  <th>EUR</td>
  <th>Debets</td>
  <th>Kredits</td>
  <th>Resurss</td>
  <th>Reìistrçjis</td>
  <th></td>
  <th></td>
 </tr>
<%
set r = conn.execute ("select id,datums,pid,starpnieciba,summaLVL,summaUSD,summaEUR,debets,kredits,resurss,lietotajs from piet_starpnieciba where pid = "+pid+" order by datums ")
summaLVL = 0
summaUSD = 0
summaEUR = 0
while not r.EOF
 %><tr bgcolor="#fff1cc">
    <td>
     <%=r("datums")%>
    </td>
    <td>
     <%
      set rtest = conn.execute("select * from starpnieciba where id = " + cstr(r("starpnieciba")))
      if not rtest.eof then Response.Write decode(cstr(rtest("nosaukums")))
     %>
    </td>
    <td>
     <%=currprint(r("summaLVL"))%>
     <% summaLVL = summaLVL + getnum(r("summaLVL"))%>
    </td>
    <td>
     <%=currprint(r("summaUSD"))%>
     <% summaUSD = summaUSD + getnum(r("summaUSD"))%>
    </td>
    <td>
     <%=currprint(r("summaEUR"))%>
     <% summaEUR = summaEUR + getnum(r("summaEUR"))%>
    </td>
    <td>
     <%=r("debets")%>
    </td>
    <td>
     <%=r("kredits")%>
    </td>
    <td>
     <%=r("resurss")%>
    </td>
    <td>
     <%=r("lietotajs")%>
    </td>
 		 <td>
 		  <input type="image" src="impro/bildes/dzest.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='delete';return confirm('Vai dzçst ierakstu?');" alt="Dzçst ierakstu." id=image1 name=image1>
 		 </td>
		  <td>
		   <input type="image" src="impro/bildes/diskete.jpg" onclick="forma.id.value=<%=cstr(r("id"))%>;forma.act.value='update'" alt="Saglabât ierakstu." id=image2 name=image2>
		  </td>
   </tr>
 <%
 r.MoveNext
wend
%>
 <tr bgcolor="#fff1cc"> 
  <td></td>
  <td></td>
  <td><b><%=CurrPrint(summaLVL)%></td>
  <td><b><%=CurrPrint(summaUSD)%></td>
  <td><b><%=CurrPrint(summaEUR)%></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
  <td></td>
 </tr>
 <tr bgcolor="#fff1cc">
  <td>
   <%
    'nosakam datumu
    d = now
    if not isnull(rG("sakuma_dat")) then d = rG("sakuma_dat")
    set rP = conn.execute("select * from pieteikums where id = "+cstr(pid))
    if not isnull(rP("sakuma_datums")) then d = rP("sakuma_datums")
   %>
   <input type=text size=8 name=datums value=<%=dateprint(d)%> >
  </td>
  <td>
   <% set rs = conn.execute("select * from starpnieciba order by nosaukums ") %>
   <select name=starpnieciba onchange="<%CalculateEvent (komisijas_izmaina)%>">
    <option value=0>Izvçlieties no saraksta</option>
    <% while not rs.eof %> 
     <option value=<%=rs("id")%>>
      <%=decode(rs("nosaukums")) %>
      <% if komisijas_izmaina<>0 and rs("online") then Response.Write cstr(komisijas_izmaina)+"%" %>
     </option>
    <% rs.movenext %>
    <% wend %>
   </select>
  </td>
  <td>
   <input type=text size=8 name=summaLVL >
  </td>
  <td>
   <input type=text size=8 name=summaUSD >
  </td>
  <td>
   <input type=text size=8 name=summaEUR >
  </td>
  <td>
   <% set rA = conn.execute("select * from agenti where id in (select agents from pieteikums where id = "+pid+")")%>
   <input type=text size=8 name=debets value="<%=rA("dkonts")%>" onblur='JSPoints (document.forma.debets)'>
  </td>
  <td>
   <input type=text size=8 name=kredits value="<%=rA("ckonts")%>" onblur='JSPoints (document.forma.kredits)'>
  </td>
  <td>
   <input type=text size=12 name=resurss value="<%=conn.execute("select kods from grupa where id in (select gid from pieteikums where id = "+cstr(pid)+")")(0)%>">
  </td>
  <td>
  </td>
  <td>
   <input type="image" src="impro/bildes/pievienot.jpg" onclick="forma.act.value='insert'" alt="Pievienot ierakstu."  id=image3 name=image3>
  </td>
 </tr>
</table>
<input type=hidden name=id>
<input type=hidden name=act>
</form>
</body>
</html>

<%
Function CalculateEvent(kom_izmaina)

 Dim rP, summaLVL, summaUSD, summaEUR

 set rP = conn.execute("select * from pieteikums where id = "+cstr(pid))

 summaEUR = getnum(rP("summaEUR")) + getnum(rP("sadardzinEUR")) + getnum(rP("atlaidesEUR"))
 summaLVL = rP("summaLVL") + rP("sadardzinLVL") + rP("atlaidesLVL")
 summaUSD = rP("summaUSD") + rP("sadardzinUSD") + rP("atlaidesUSD")

 set rS_l = conn.execute("select * from starpnieciba")
 while not rs_l.eof
  %>
   if (forma.starpnieciba.value==<%=rS_l("id")%>)
   {
    <% if getnum(rs_l("procents")) <> 0 and rs_l("online") then %>
     forma.summaLVL.value = '<%=currprint(myround((rS_l("procents")+kom_izmaina)*summaLVL/100,2))%>';
     forma.summaUSD.value = '<%=currprint(myround((rS_l("procents")+kom_izmaina)*summaUSD/100,2))%>';
     forma.summaEUR.value = '<%=currprint(myround((rS_l("procents")+kom_izmaina)*summaEUR/100,2))%>';
    <% end if %>
    <% if getnum(rs_l("procents")) <> 0 and not rs_l("online") then %>
     forma.summaLVL.value = '<%=currprint(myround((rS_l("procents"))*summaLVL/100,2))%>';
     forma.summaUSD.value = '<%=currprint(myround((rS_l("procents"))*summaUSD/100,2))%>';
     forma.summaEUR.value = '<%=currprint(myround((rS_l("procents"))*summaEUR/100,2))%>';
	 
    <% end if %>
    <% if getnum(rs_l("summa")) <> 0 then %>
     forma.summaLVL.value = '0.00';
     forma.summaUSD.value = '0.00';
     forma.summaEUR.value = '<%=currprint(rS_l("summa"))%>';
    <% end if %>
   }
  <%
  rs_l.movenext
 wend
End function

Function PieteikumsResurss(pid_p)
 rSett = conn.execute("select * from parametri")
 rP = conn.execute("select * from pieteikums where id = " + cstr(pid))
 rG = conn.execute("select * from grupa where id = " + cstr(rp("gid")))
 if nullprint(rG("kods"))<>"" then
  ch = mid(rG("kods"),1,1)
  if ch = "V" or ch = "P" or ch = "S" or ch = "T" then
   PieteikumsResurss = ch
   for i = 2 to len(rG("kods"))
    PieteikumsResurss = PieteikumsResurss + "." +mid(rG("kods"),i,1)
   next
  end if
  if ch = "K" or ch = "C" then
   PieteikumsResurss = ch+"."+cstr(pid_p)
  end if
 end if
End Function

Function MyRound(x ,  Factor ) 
  if isnull(x) then x = 0
  f = 1
  For i = 1 To Factor
   f = f * 10
  Next
  MyRound = Fix(x * f + 0.5 * Sgn(x)) / f
End Function


%>

