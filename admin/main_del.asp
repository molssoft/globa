<!-- #include file = "../conn.asp" -->
<!-- #include file = "../procs.asp" -->

<%
dim conn
openconn

id = Request.querystring("id")
set rp = conn.execute("select isnull(parent_id,'') as p,order_num from theMain where id = '"+id+"'")
parent = trim(rp("p"))
o = rp("order_num")

Response.Write "select isnull(parent_id,'') from theMain where trim(id) = '"+id+"'"
set r = conn.execute("select isnull(parent_id,'') from theMain where id = '"+id+"'")

conn.execute "delete from main_marsruti where main = '"+id+"'"
conn.execute "delete from theMain where id = '"+id+"'"
if parent = "" then
 conn.execute("update theMain set order_num = order_num -1 where order_num>"+cstr(o)+" and parent_id is null")
else
 conn.execute("update theMain set order_num = order_num -1 where order_num>"+cstr(o)+" and parent_id = '"+parent+"'")
end if
Response.Redirect "main.asp?parent="+parent
%>
