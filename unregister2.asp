<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

email = Request.Form("email")
password = request("password")

set r=conn.execute ("select * from email_list where email='"+email+"' and parole = '"+password+"'")
if r.eof then
%>
	<center>
	Parole vai emails nav pareizs. Nospiediet BACK un mçìiniet vçlreiz.
<% else 
conn.execute "update email_list set status = 'N', datums_status = '"+sqldate(now)+"' where email='"+email+"' and parole = '"+password+"'" 
%>
	<center>
	Jûs esat atslçgts no IMPRO ziòu saòemðanas.
<% end if %>
