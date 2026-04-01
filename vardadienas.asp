<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
'Response.CodePage = 1252
'Response.CharSet = "windows-1257" 

docstart "Vârdadienu pievienoðana","y1.jpg" 
dim conn
OpenConn

if request.form("vards") <>  "" then
	v = request.form("vards")
	out = ","
	last_char = ","
	for i = 1 to len(v)
		
		ch = mid(v,i,1)
		if ch=" " or ch = "," or ch = chr(13) or ch = chr(10) then
			if last_char<> "," then
				out = out + ","
				last_char = ","
			end if
		else
			out = out + ch
			last_char = ch
		end if
	next

	if last_char <> "," then
		out = out + ","
	end if

	response.write out

	conn.execute("delete from vardadienas where datums = "+request.form("diena")+" and menesis = "+request.form("menesis")+"")
	conn.execute("insert into vardadienas (datums,menesis,vards) values ("+request.form("diena")+","+request.form("menesis")+",'"+out+"')")

end if

%>

<form method=POST>
Mçnesis: <input type=text name=menesis value="<%=request.form("menesis")%>"><BR>
Diena: <input type=text name=diena value="<%=cint(request.form("diena"))+1%>"><BR>
Vârdi: <textarea name=vards></textarea><BR>
<input type=submit>
</form>