<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
grupa_id = request.form("grupa_id")

sakuma_diena = request.form("sakuma_diena"+cstr(grupa_id))
sakuma_menesis = request.form("sakuma_menesis"+cstr(grupa_id))
sakuma_gads = request.form("sakuma_gads"+cstr(grupa_id))
if len(sakuma_gads) = 1 then
 sakuma_gads = mid(cstr(year(now)),1,3)+sakuma_gads
end if

no = "'"+sqldate(GetDate(sakuma_diena,sakuma_menesis,sakuma_gads))+"'"
gr_kods = request.form("gr_kods"+cstr(grupa_id))

beigu_diena = request.form("beigu_diena"+cstr(grupa_id))
beigu_menesis = request.form("beigu_menesis"+cstr(grupa_id))
beigu_gads = request.form("beigu_gads"+cstr(grupa_id))
if len(beigu_gads) = 1 then
 beigu_gads = mid(cstr(year(now)),1,3)+beigu_gads
end if

if beigu_diena <> "" then
 lidz = "'"+sqldate(GetDate(beigu_diena,beigu_menesis,beigu_gads))+"'"
else
 lidz = "NULL"
end if
pm_cena = request.form("pm_cena"+cstr(grupa_id))
if pm_cena = "" then pm_cena = "null"
' if gr_kods = "" then gr_kods = " "
'response.write (id&"<br> grupa_id "&grupa_id&"<br> gr_kods "&gr_kods&"<br> pm_cena "&pm_cena)
set rCena = conn.execute("select marsruts from cenas where id = "+cstr(id))
set r = conn.execute("update grupas set [no] = "+no+", lidz = "+lidz+", pm_cena = "+pm_cena+", gr_kods='"+gr_kods+"', marsruts = "+cstr(rCena("marsruts"))+" where id = "+cstr(grupa_id))

response.redirect "grupas.asp?cena_id="+id+"&#"+grupa_id
%>
