<!-- #include file = "dbprocs.inc" -->

<%
dim conn
OpenConn
conn.execute "UPDATE piet_saite set did = "+Request.QueryString("uz")+" where did = "+Request.QueryString("no")+" and pid = "+Request.QueryString("pid")
Response.Redirect "pieteikums.asp?pid="+Request.QueryString("pid")
%>
