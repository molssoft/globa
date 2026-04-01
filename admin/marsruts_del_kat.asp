<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn

conn.execute("delete from kat_marsruti where kategorija = '"+Request.QueryString("t")+"' and marsruts = "+Request.QueryString("m"))
Response.Redirect "marsruts.asp?id="+Request.QueryString("m")
%>