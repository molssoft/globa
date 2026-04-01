<!-- #include file = "procs.inc" -->
<%docstart "Grupas","ice1.jpg" %>
<center><font color="#FF0000" size="5"><b><i>Jaunas grupas reìistrçðana</i></b></font><hr>
<%headlinks%>

<%
if request.querystring("i")="" then grupa = -1 else grupa = request.querystring("i")
Set lists = Server.CreateObject("ADODB.Connection")
lists.Open "DSN=ai"
subm=Request.Form("subm")
if subm = 1 then
	sakuma_dat=Request.Form("sakuma_dat")
	beigu_dat=Request.Form("beigu_dat")
	sapulces_dat=Request.Form("sapulces_dat")
	vaditajs=Request.Form("vaditajs")
	marsr = Request.Form("gid")

	grupa = request.form("grupa")
	Set rs = Server.CreateObject("ADODB.Recordset")
	if grupa = -1 then'insertç jaunu grupu
		rs.Open "select * from grupa",lists,3,3
		rs.AddNew
	else  'labo grupu ar numuru 'grupa'
		rs.Open "select * from grupa where id = "+ grupa,lists,3,3
		rs.movefirst
	end if
	rs("mID") = marsr
	if sakuma_dat <> "" then rs("sakuma_dat")=sakuma_dat
	if beigu_dat <> "" then rs("beigu_dat")=beigu_dat
	if sapulces_dat <> "" then rs("sapulces_dat")=sapulces_dat
	if vaditajs <> "" then rs("vad")=vaditajs
	rs("mid")=marsr
	rs.Update
	grupa = -1
end if
%>

<table border=0>
<form action="IN_grupa.asp" method="POST">

<tr><td align="right">Marðruts: </td><td>

<%
Set grupas = lists.execute("select m.ID,m.v from marsruts m")
Response.Write "<select name=" & "gID" & " size=" & "1" & ">"
'------- Loop through the RECORDS
do while not grupas.eof

Response.Write "<option value='" & grupas("ID") & "'>" &  grupas("v") & "</option>"
grupas.MoveNext
loop
Response.write " </select>" & Chr(10)
%>

<%
if grupa <> "-1" then
	Set rs = lists.execute("SELECT grupa.*, grupa.ID FROM grupa WHERE grupa.ID=" + grupa)
	if rs.recordcount<>0 then
		vaditajs = rs("vad")
		sakuma_dat = rs("sakuma_dat")
		beigu_dat = rs("beigu_dat")
		sapulces_dat = rs("sapulces_dat")
	end if
else
	vaditajs = ""
	sakuma_dat = ""
	beigu_dat = ""
	sapulces_dat = ""
end if
%>

<tr><td align="right">Vadîtâjs: </td><td><input type="text" size="20" maxlength="20" name="vaditajs" value="<%=vaditajs%>"> </tr>
<tr><td align="right">Sâkuma datums: </td><td><input type="text" size="15" maxlength="255" name="sakuma_dat" value="<%=sakuma_dat%>"> </tr>
<tr><td align="right">Beigu datums: </td><td><input type="text" size="15" maxlength="10" name="beigu_dat" value="<%=beigu_dat%>"> </tr>
<tr><td align="right">Grupas sapulces datums: </td><td><input type="text" size="15" maxlength="10" name="sapulces_dat" value="<%=sapulces_dat%>"> </tr>


</table>
<input type="hidden" name="subm" value="1"> 
<input type="hidden" name="grupa" value="<%=grupa%>"> 
<input type="submit" name="poga" value="Reìistret"> 
</form>


</body>
</html>
