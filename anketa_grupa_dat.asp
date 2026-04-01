<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
DocStart "Anketu ievade","y1.jpg"
dim conn
OpenConn
if not isaccess(T_ANKETAS) then 
 Response.Redirect("default.asp")
end if
%>
<font face=Tahoma>
<Center><font size=4>Anketas</font><br><br>

<%
d = FormatedDate(request.Form("sakuma_datums"),"dmy")+1
if isvaliddate(request.Form("sakuma_datums"),"dmy") then
	q = "SELECT grupa.kods, grupa.sakuma_dat as sak, marsruts.v, grupa.id "+_
	"FROM marsruts INNER JOIN grupa ON marsruts.ID = grupa.mID " + _
	"WHERE sakuma_dat >= '"+sqldate(request.Form("sakuma_datums"))+"' and sakuma_dat < '"+sqldate(d)+"' " + _
	"ORDER BY v;"
	set r = conn.execute(q)
	'response.Write q
	while not r.eof
		'response.Write r("grupa.kods") + " " + dateprint(r("grupa.sakuma_dat")) + " : " + r("marsruts.v") + "<BR>"
		%><a href=c_anketas.php?gid=<%=r("id")%>><%
		response.Write nullprint(r("kods")) + " " + nullprint(dateprint(r("sak"))) + " : " + nullprint(r("v")) + "<BR>"
		%></a><%
		r.movenext
	wend
else
	%>Datums nav pareizs<%
end if
%><br><br>

<a href=anketa_grupa.asp>Uz anketçjamo grupu meklçğanu</a><br>
<a href=default.asp>Uz mâjâm</a>