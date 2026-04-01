<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn

conn.execute("insert into geo_marsruti (geo,marsruts) values ('"+Request.QueryString("g")+"',"+Request.QueryString("m")+")")
Response.Redirect "marsruts.asp?id="+Request.QueryString("m")
%>