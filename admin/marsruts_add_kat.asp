<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn

conn.execute("insert into kat_marsruti (kategorija,marsruts) values ('"+Request.QueryString("t")+"',"+Request.QueryString("m")+")")
Response.Redirect "marsruts.asp?id="+Request.QueryString("m")
%>