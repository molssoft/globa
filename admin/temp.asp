<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
    <%
dim conn
openconn
conn.DefaultDatabase = "portal2"

Set r = conn.Execute("select apraksts from marsruti where nosaukums like 'DAUDZKR%'")
Response.Write r(0)
    %>
