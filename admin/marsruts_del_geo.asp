<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn

conn.execute("delete from geo_marsruti where geo = '"+Request.QueryString("g")+"' and marsruts = "+Request.QueryString("m"))
Response.Redirect "marsruts.asp?id="+Request.QueryString("m")
%>