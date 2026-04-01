<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")
pdf = sqltext(request.form("pdf"))
pdf_desc = sqltext(request.form("pdf_desc"))
nosaukums = sqltext(request.form("nosaukums"))
dienas = request.form("dienas")
izbrauc = request.form("izbrauc")
apraksts = sqltext(request.form("apraksts"))
key = request.form("key")
chartergroup = request.form("chartergroup")
skatit = sqltext(request.form("skatit"))
spec = sqltext(request.form("spec"))
galva = sqltext(request.form("galva"))

conn.execute("update marsruti set nosaukums = '"+nosaukums+"', pdf = '"+pdf+"', pdf_desc='"+pdf_desc+"', [key] = '"+key+"', apraksts = '"+apraksts+"', " + _
  " dienas = '"+dienas+"', " + _
  " izbrauc = '"+izbrauc+"', " + _
  " chartergroup = '"+chartergroup+"', " + _
  " spec = '"+spec+"', " + _
  " galva = '"+galva+"', " + _
  " skatit = '' " + _
  " where id = "+cstr(id))

'specpiedâvâjumu saglabâjam
conn.execute("delete from main_marsruti where marsruts = "+cstr(id))
if skatit<>"" then
 m = split(skatit,"|")
 for i = lbound(m) to ubound(m)
  conn.execute "insert into main_marsruti (main,marsruts) values ('"+m(i)+"',"+cstr(id)+")"
 next
end if
  
response.redirect "marsruts.asp?id="+id
%>
