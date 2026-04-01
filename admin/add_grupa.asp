<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
marsruts_id = request.form("marsruts_id")

sakuma_diena = request.form("add_sakuma_diena")
sakuma_menesis = request.form("add_sakuma_menesis")
sakuma_gads = request.form("add_sakuma_gads")
if len(sakuma_gads) = 1 then
 sakuma_gads = mid(cstr(year(now)),1,3)+sakuma_gads
end if
no = "'"+sqldate(GetDate(sakuma_diena,sakuma_menesis,sakuma_gads))+"'"

beigu_diena = request.form("add_beigu_diena")
beigu_menesis = request.form("add_beigu_menesis")
beigu_gads = request.form("add_beigu_gads")
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
gr_kods = request.form("gr_kods")

set r = conn.execute("insert into grupas (cena,marsruts,[no],lidz,pm_cena,gr_kods) values ("+cstr(id)+","+cstr(marsruts_id)+","+no+","+lidz+","+pm_cena+",'"+gr_kods+"')" )

s =  "grupas.asp?cena_id="+id+"&#LAST"
response.redirect s
%>
