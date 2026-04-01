<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "allproc.asp" -->

<%
dim conn
OpenConn

pid = Request.QueryString("pid")
tips = Request.QueryString("tips") 'atteicies vai atcelts
rOld = conn.execute("select * from pieteikums where id = "+cstr(pid))
rGrupa = conn.execute("select * from grupa where id = "+cstr(rOld("gid")))

'info par pieteikumu
set rSummas = conn.execute("select iemaksasUSD,izmaksasUSD,iemaksasLVL,izmaksasLVL,iemaksasEUR,izmaksasEUR,gid from pieteikums where id = "+pid)
docstart "Orderis","y1.jpg"
%>  <font face=Tahoma><center><font color="GREEN" size="5">Atteikðanâs no pieteikuma</b></font><hr><%
headlinks

pIemaksas = piet_iemaksas2(pid,0,0) '--- iegust apstiprinaato iemaksu summu latos
pIzmaksas = piet_izmaksas(pid)


if Request.Form("subm")<>"1" then
 %>
  <form name=forma action="att_veids1.asp?pid=<%=pid%>&tips=<%=tips%>" method=POST>
  <br>
  <center>
  
  <table>
    <% if tips <> "atcelts" then 
    
    max_lvl = getnum(rSummas("iemaksasLVL")) - getnum(rSummas("izmaksasLVL"))
    max_eur = getnum(rSummas("iemaksasEUR")) - getnum(rSummas("izmaksasEUR"))
    
	zaud_nauda = get_zaud_nauda(rSummas("gid"))
	zaud_nauda_eur = 0
	zaud_nauda_lvl = 0
	If (rGrupa("valuta")="EUR") then
		'euro grupa
		zaud_nauda_eur = zaud_nauda
		if zaud_nauda=-1 or zaud_nauda > max_eur then 
			zaud_nauda_eur=max_eur 
		end if
	Else
		'pienemam ka ir lati pec noklusejuma
		zaud_nauda_lvl = zaud_nauda
		if zaud_nauda=-1 or zaud_nauda > max_lvl then 
			zaud_nauda_lvl=max_lvl 
		end if
	End If
	
  %>
   <tr>
	<td colspan="3" style="color:red;font-weight:bold;">Zaudçjuma summa jçievada atbilstoði norâdçm ceïojuma aprakstâ<br><br></td>
   </tr>
   <tr>
    <td>Cik EUR klients zaudç</td>
    <td><input size=10 type=text name=summaEUR value="<%=zaud_nauda_eur%>">EUR</td>
    <td>
		(Max:<%=CurrPrint(max_eur)%> EUR)
	</td>
   </tr>
   <tr>
    <td>Cik LVL klients zaudç</td>
    <td><input size=10 type=text name=summaLVL value="<%=zaud_nauda_lvl%>">LVL</td>
    <td>
		(Max:<%=CurrPrint(max_lvl)%> LVL)
	</td>
   </tr>

   <%else %>
   <tr>
    <td align=center colspan=3>Atcelta grupa. <b>Klients naudu nezaudç.</b><br></td>
   </tr>
   <%end if %>
   <tr>
    <td align=center colspan=3>Atlikusî summa jâreìistrç kâ izmaksa klientam.<br><br><font color=red>Spiediet pogu tikai vienu reizi.</font></td>
   </tr>
   <tr>
    <td align=center colspan=3><input type=submit value="Reìistrçt atteikumu"></td>
   </tr>
  </table>
  <input type=hidden name=subm value=1>
  <input type=hidden name=max_lvl value="<%=max_lvl%>">
  <input type=hidden name=max_eur value="<%=max_eur%>">
  
  </form>
 <%
else
 %><BR><font face=Tahoma><%

 summaLVL = Request.Form("summaLVL")
 summaEUR = Request.Form("summaEUR")
 
 max_lvl = Request.Form("max_lvl")
 max_eur = Request.Form("max_eur")

 set rPiet = conn.execute("select * from pieteikums where id = " & cstr(pid))
 if not rPiet.eof then
  rPiet.movefirst
  if rPiet("old_gid")<>"" then
   
   message = "Atteikums jau ir reìistrçts!"
   
   Response.Write message
   Response.End
   
  end if
 end if
 
 'pieteikuma dalibnieks
  rDid = conn.execute("select did from piet_saite where pid = "+pid+" and deleted = 0")

if tips <> "atcelts" then

 '--- parbaude vai pareizi ievadiitas summas un vai var tik daudz izmaksaat. 
 '--- izmaksaat var tikai apstiprinaato maksaajumu summu.

 if not isValidCurr(summaLVL) then
  message = "LVL summa ir kïûdaini ievadîta."
 elseif CCur(summaLVL)>CCur(max_lvl) and summaLVL <> 0 then
  message = "LVL summa ir parâk liela."
  'viss ok
 end if
 
 if not isValidCurr(summaEUR) then
  message = "EUR summa ir kïûdaini ievadîta."
 elseif CCur(summaEUR)>CCur(max_eur) and summaEUR <> 0 then
  message = "EUR summa ir parâk liela."
  'viss ok
 end if


 if message<>"" then 
  Response.Write message
  Response.Write "<br><a href='javascript:history.go(-1)'>Atgriezties</a>"  
  Response.End
 else
  
  'vai eksistee tekoshaa gada zaudçtâs naudas grupa.
  'saakot ar 2009. gadu zaudçtâ nauda tiek daliita pa gadiem. 19/01/2009 Nils
  ssql = "select id from grupa where mid in (select id from marsruts where v like N'!Zaud_t_ nauda '+cast(year(getdate())as nvarchar) )"
  set zn_grupa = conn.execute(ssql)
  if zn_grupa.eof then
	Response.Write("Nav izveidota zaudçtâs naudas grupa "+cstr(year(Date()))+"!")
	Response.end
  else	
	zn_grupa_id = zn_grupa("id")
  end if
  
  'pieteikuma dalibnieks
  rDal = conn.execute("select * from dalibn where id = "+cstr(rDid("did")))
  dal_nos = NullPrint(rDal("vards"))+" "+NullPrint(rDal("uzvards"))+" "+NullPrint(rDal("nosaukums"))
  
  'vai eksistç pieteikums ar zaudçto naudu?
  set rz = conn.execute("select id from pieteikums where gid = "+cstr(zn_grupa_id)+" and deleted = 0 and id in (select pid from piet_saite where deleted = 0 and did = "+cstr(rDid("did"))+")")
  new_pid = 0
  if not rz.eof then
    new_pid = rz("id")
  end if
  
  'parskaita noradito summu uz zaudeto naudu
  
  'LVL
  if ccur(summaLVL)>0 then
   if new_pid = 0 then
    new_pid = InsertPiet(zn_grupa_id,rDid("did"))
   end if
   pamatojums = "Pârskaitîjums no " + PietNosaukums(pid)+" uz "+PietNosaukums(new_pid)
   InsertOp new_pid,pid,date,"Pârskaitîjums",pamatojums,"","","",summaLVL,"LVL",summaLVL,0,0
  end if
  
  'EUR
  if ccur(summaEUR)>0 then
   if new_pid = 0 then
    new_pid = InsertPiet(zn_grupa_id,rDid("did"))
   end if
   pamatojums = "Pârskaitîjums no " + PietNosaukums(pid)+" uz "+PietNosaukums(new_pid)
   InsertOp new_pid,pid,date,"Pârskaitîjums",pamatojums,"","","",summaEUR,"EUR",0,summaEUR,0
  end if


  pieteikums_recalculate pid
  pieteikums_recalculate new_pid
  conn.execute "update pieteikums set agents = "+cstr(getnum(rOld("agents")))+" where id = " + cstr(new_pid)
  
  end if '--- ja nav error message
end if '--- ja nav atcelta grupa
 

'---uzstada, ka pieteikums ir atteikts
  	Dim old_vals
	set old_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 

  'dabon globalos parametrus
  rParam = conn.execute("select * from Parametri")

  if tips = "atcelts" then
   conn.execute("update pieteikums SET old_gid = gid, gid = "+cstr(rParam("atcelts"))+", dat_atcelts = getdate() where id = "+pid)
  else
   conn.execute("update pieteikums SET old_gid = gid, gid = "+cstr(rParam("atteikusies"))+", dat_atcelts = getdate() where id = "+pid)
  end if
  conn.execute "update piet_saite SET vid = NULL, kid = NULL, vietas_veids = NULL where pid = "+cstr(pid)
  conn.execute "delete from piet_atlaides where pid = "+cstr(pid)
  pieteikums_recalculate(pid)
  'LogEditAction "pieteikums",pid
  Dim new_vals
	set new_vals = CreateDict("SELECT * FROM pieteikums WHERE id="+ cstr(pid)) 
  UpdateActionDetails old_vals,new_vals,"pieteikums",pid,""
  
  %>Atteikums ir reìistrçts.<br><br><a href="dalibn.asp?i=<%=rDid("did")%>">Uz klienta logu</a><%

 
end if
%>

