<%
function IrBrivasVietas(kods,beigu_datums)
set gconn = server.createobject("ADODB.Connection")
gconn.open "DSN=glo"

'Nosaka grupas id
set f = gconn.execute("select id,vietsk,vietsk_nakts from grupa where kods = '"+kods+"' and beigu_dat>='1/1/"+cstr(year(beigu_datums))+"' and beigu_dat<'1/1/"+cstr(year(beigu_datums)+1)+"'")
if f.eof then
 IrBrivasVietas = -1
 exit function
end if

query = "select sum(vietsk) as aizn from piet_saite,pieteikums where piet_saite.pid = pieteikums.id " + _
" and gid = "+cstr(f("id"))+" and pieteikums.deleted = 0 and piet_saite.deleted = 0 " + _
" and (kvietas_veids in (1,2,4,5) or persona = 1) and (not isnull(kvietas_veids,0) = 3)"
set personas = gconn.execute(query)
query = "SELECT sum(piet_saite.vietsk) as sk " +_
	"FROM grupa,pieteikums,piet_saite " +_
	"WHERE grupa.id = "+cstr(f("id"))+ "AND grupa.id = pieteikums.gid AND piet_saite.pid = pieteikums.id AND piet_saite.papildv = 1 AND (piet_saite.deleted = 0 and pieteikums.deleted = 0);"
set pap = gconn.execute(query)

if BrivasVietas(getnum(f("vietsk")),getnum(f("vietsk_nakts")),getnum(personas("aizn")),getnum(pap("sk"))) > 0 then
 IrBrivasVietas = 1
else
 IrBrivasVietas = 0
end if

end function

Function BrivasVietas(vietsk,vietsk_nakts,persona,papild)
 BrivasVietas = vietsk-persona-papild
 if getnum(vietsk_nakts)>0 then
  brivs_nakts = vietsk_nakts - persona
  if brivasvietas>brivs_nakts then BrivasVietas = brivs_nakts
 end if
End function
%>