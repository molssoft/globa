<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn

conn.execute("delete from temas_marsruti where tema = '"+Request.QueryString("t")+"' and marsruts = "+Request.QueryString("m"))
Response.Redirect "marsruts.asp?id="+Request.QueryString("m")
%>