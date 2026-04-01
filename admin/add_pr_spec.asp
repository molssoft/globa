<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

marsruts_id = request.form("marsruts_id")

teksts = request.form("add_teksts")
skaidrojums = request.form("add_skaidrojums")
cena = request.form("add_cena")

conn.execute("insert into pr_spec_pied (marshruts_id,teksts,skaidrojums,cena) values ("+cstr(marsruts_id)+",'"+teksts+"','"+skaidrojums+"','"+cena+"')" )
response.redirect "pr_details.asp?id="+cstr(marsruts_id)
%>
