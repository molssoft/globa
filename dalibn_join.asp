<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn



'----- Izpilda apvienoðanu
if request.form("visi_dal") <> "" then

 'rw "update piet_saite set did = " + request.form("select_dal") + " where did in " + request.form("visi_dal")
 'Response.End
 
 
 conn.execute "update piet_saite set did = " + request.form("select_dal") + " where did in " + request.form("visi_dal")
 '--- pieteikuma did update pievienots 19.feb 2014. lai nepazustu saite online sistçmâ.
 conn.execute "update pieteikums set did = " + request.form("select_dal") + " where isnull(did,0)<>0 and did in " + request.form("visi_dal")
 
 conn.execute "update grupu_vaditaji set did = " + request.form("select_dal") + " where isnull(did,0)<>0 and did in " + request.form("visi_dal")
 
 conn.execute "update dalibn set deleted = 1, visas = isnull(visas,'') + ' [join]' where  id in " + request.form("visi_dal") + " and id <> " + request.form("select_dal")
 

 session("dmessage") = "Dalîbnieki ir apvienoti."
 response.redirect "dalibn.asp?i=" + request.form("select_dal")
end if

'-------- Savâc visus submitçtos dalîbniekus

id_str = ""

visi_dal = "("

for i = 1 to request.form.count
 val = request.form(i)
 if len(val)>3 then
  if mid(val,1,3) = "did" then
   if request.form("ch"+mid(val,4,len(val)-3)) = "on" then
    id_str = id_str + mid(val,4,len(val)-3) + ","
   end if
  end if
 end if
next 

if id_str <> "" then 

	id_str = Left(id_str,len(id_str)-1) 'nodzesh pedejo komatu
	
	visi_dal = visi_dal + id_str

	if request.form("jointo")<>"" and request.form("jointo")<>0 then visi_dal = visi_dal + "," + request.form("jointo")

	visi_dal = visi_dal + ")"
	
else
	Response.Write "Kïûda. Nav atzîmçts neviens dalîbnieks."
	Response.end
end if


'Response.Write("select * from dalibn where id in " + visi_dal)

'--------- selektee visus ðos dalibniekus
set r = server.createobject("adodb.recordset")
r.open "select * from dalibn where id in " + visi_dal,conn,3,3


%>


<% 
'HTML Start --------------------------
docstart "Dalîbnieku apvienoðana","y1.jpg" %>
<center><font color="GREEN" size="5"><b>Dalîbnieku apvienoðana</b></font>
<hr>
<% headlinks %>

<% if r.recordcount < 2 then %>
 <br>
 <font color=red size = 5>Apvienoðanai vajadzîgi vismaz 2 dalîbnieki</font>
<% else %>
 <form name=forma method=post action=dalibn_join.asp>
  <input type=hidden name=visi_dal value='<%=visi_dal%>'>
  Izvçlieties, kuru dalîbnieku saglabât. <br>Pârçjo dalîbnieku pieteikumi un iemaksas tiks pievienotas izvçlçtajam. <br>Paði dalîbnieki tiks <b>dzçsti!</b>.
  <table border=1>
  <% i = 1
  while not r.eof %>
  <tr>
   <td><input type=radio name="select_dal" value="<%=r("id")%>" <% if i=1 then response.write "checked" %>></td>
   <% i = i + 1 %>
   <td>
    <% if nullprint(r("id"))<>"" then %>
     <b>Nr.</b><%=r("id")%>;
    <% end if %>
    <% if nullprint(r("vards"))<>"" then %>
     <b>Vârds:</b><%=r("vards")%>;
    <% end if %>
    <% if nullprint(r("uzvards"))<>"" then %>
     <b>Uzvârds:</b><%=r("uzvards")%>;
    <% end if %>
    <% if nullprint(r("nosaukums"))<>"" then %>
     <b>Nosaukums:</b><%=r("nosaukums")%>;
    <% end if %>
    <% if nullprint(r("pk1"))+nullprint(r("pk2"))<>"" then %>
     <b>Personas kods:</b><%=nullprint(r("pk1"))+nullprint(r("pk2"))%>;
    <% end if %>
    <% if nullprint(r("pases"))+nullprint(r("pasenr"))<>"" then %>
     <b>Pase:</b><%=nullprint(r("pases"))+nullprint(r("pasenr"))%>;
    <% end if %>
    <% if nullprint(r("reg"))<>"" then %>
     <b>Reg.nr.:</b><%=r("reg")%>;
    <% end if %>
    <% if nullprint(r("nmkods"))<>"" then %>
     <b>Nod.maks.kods:</b><%=r("nmkods")%>;
    <% end if %>
    <% if nullprint(r("vaditajs"))<>"" then %>
     <b>Vadîtâjs:</b><%=r("vaditajs")%>;
    <% end if %>
    <% if nullprint(r("kontaktieris"))<>"" then %>
     <b>Kontaktpersona:</b><%=r("kontaktieris")%>;
    <% end if %>
    <% if nullprint(r("adrese"))<>"" then %>
     <b>Adrese:</b><%=r("adrese")%>;
    <% end if %>
    <% if nullprint(r("pilseta"))<>"" then %>
     <b>Pilsçta:</b><%=r("pilseta")%>;
    <% end if %>
    <% if nullprint(r("indekss"))<>"" then %>
     <b>Indekss:</b><%=r("indekss")%>;
    <% end if %>
    <% if nullprint(r("talrunisM"))<>"" then %>
     <b>Tâlrunis mâjâs:</b><%=r("talrunisM")%>;
    <% end if %>
    <% if nullprint(r("nosaukums"))<>"" then %>
     <b>Nosaukums:</b><%=r("nosaukums")%>;
    <% end if %>
    <% if nullprint(r("fax"))<>"" then %>
     <b>Fakss:</b><%=r("fax")%>;
    <% end if %>
    <% if nullprint(r("talrunisd"))<>"" then %>
     <b>Tâlrunis darbâ:</b><%=r("talrunisd")%>;
    <% end if %>
    <% if nullprint(r("talrunismob"))<>"" then %>
     <b>Mobîlais tâlrunis:</b><%=r("talrunismob")%>;
    <% end if %>
    <% if nullprint(r("nosaukums"))<>"" then %>
     <b>Nosaukums:</b><%=r("nosaukums")%>;
    <% end if %>
    <% if nullprint(r("eadr"))<>"" then %>
     <b>E-pasts:</b><%=r("eadr")%>;
    <% end if %>
    <% if nullprint(r("nosaukums"))<>"" then %>
     <b>Nosaukums:</b><%=r("nosaukums")%>;
    <% end if %>
    <% if nullprint(r("piezimes"))<>"" then %>
     <b>Piezîmes:</b><%=r("piezimes")%>;
    <% end if %>
   </td>
  </tr>
  <% r.movenext
  wend %>
  </table>
  <input type=submit value="Apvienot" onclick="return confirm('Pârçjie dalîbnieki tiks dzçsti');">
 </form>
<% end if '--- recordcount<2%>

</body>
</html>


