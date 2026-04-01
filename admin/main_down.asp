<!-- #include file = "../conn.asp" -->

<%
dim conn
openconn

id = Request.QueryString("id")

set r = conn.execute("select isnull(parent_id,'') as p,order_num from theMain where id = '"+id+"'")
parent = trim(r("p"))

if parent <> "" then
 conn.execute("update theMain set order_num = order_num - 1 WHERE order_num = "+cstr(r("order_num")+1)+" and parent_id = '"+parent+"'")
else
 conn.execute("update theMain set order_num = order_num - 1 WHERE order_num = "+cstr(r("order_num")+1)+" and parent_id is null ")
end if

conn.execute("update theMain set order_num = order_num+1 WHERE id = '"+trim(id)+"'")

Response.Redirect "main.asp?parent="+parent
%>
