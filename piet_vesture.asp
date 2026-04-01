<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
openconn
pid = request.querystring("pid")
set rec = server.createobject("ADODB.Recordset") 
rec.open "select * from pieteikums where id = " + cstr(pid),conn,3,3

if pid = 0 or pid = "" then 
	session("message") = "Nav norâdîts pieteikuma nummurs"
end if
	
docstart "Pieteikuma vçsture","y1.jpg"
%>
<div id="augsa"></div>
<center><font color="GREEN" size="5"><b>Pieteikuma vçsture</b></font><hr>
<%
headlinks
if session("message") <> "" then
	response.write  "<br><center><font color='GREEN' size='3'><b>"+session("message")+"</b></font>"
	session("message") = ""
end if

if pid <> 0 and pid <> "" then %>
<p>
<center><font color="GREEN" size="3"><b>Pieteikums nr. <%=cstr(pid)%></b></font>
<script>
$(document).ready(function(){
  $("html, body").animate({ scrollTop: $(document).height() }, 1000);
});
</script><center>

<form name="forma" action="piet_datums.asp?pid=<%=pid%>" method="POST">
	<center>
		<table border="1">
	<%
	
	set r = conn.Execute("Select vesture FROM pieteikums WHERE id = " + cstr(pid))
	formattedVesture = "<tr bgcolor='#ffc1cc'><td>"+Replace(r("vesture"),"<br>","</td></tr><tr bgcolor='#ffc1cc'><td>")+"</td></tr>"
	formattedVesture = Replace(formattedVesture,"||","</td><td colspan='2' bgcolor=''>")
	formattedVesture = Replace(formattedVesture," :: ","</td><td bgcolor='#FEFFD5'>")
	formattedVesture = Replace(formattedVesture,"=>","</td><td bgcolor='#FEFFD5'>")
	'rw formattedVesture
	formattedVesture = Replace(formattedVesture,"*","<div style='text-align:right;font-style:italic;background-color:''>")
	
		formattedVesture = Replace(formattedVesture,"<tr bgcolor='#ffc1cc'><td></td></tr>","")
	%>
	<%=formattedVesture%>
	
	</table>
</form> 
<% end if %>
<br><br>
<a href="#augsa">Uz augðu</a>

