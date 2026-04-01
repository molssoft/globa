<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn

conn.execute("insert into temas_marsruti (tema,marsruts) values ('"+Request.QueryString("t")+"',"+Request.QueryString("m")+")")
Response.Redirect "marsruts.asp?id="+Request.QueryString("m")
%>