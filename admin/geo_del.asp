<!-- #include file = "../conn.asp" -->
<!-- #include file = "../procs.asp" -->

<%
dim conn
openconn

id = Request.querystring("id")
set rp = conn.execute("select isnull(parent_id,'') as p from geo where id = '"+id+"'")
parent = trim(rp("p"))

set r = conn.execute("select isnull(parent_id,'') from geo where id = '"+id+"'")
conn.execute "delete from geo where id = '"+id+"'"
Response.Redirect "geo.asp?parent="+parent
%>
