
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<table>
<form action="jur_grupas_save.asp" method="POST">
<%
dim conn
OpenConn
If request.querystring("i") = "" Then id = -1 Else id = request.querystring("i")

sSelect_jur_grupas_id="select JUR_GRUPAS_ID from dalibn_jur_grupas where dalibn_id="&id

Set e_jur_grupas = conn.execute(sSelect_jur_grupas_id)
k=0
	do while not e_jur_grupas.eof
		grupas_id_value=e_jur_grupas("jur_grupas_id")
%><br>
<a href="jur_grupas_delete.asp?i=<%=id%>&jur_grupas_id=<%=grupas_id_value%>">delete</a>
<%
		k=k+1
		dbcomboplus "dalibn_jur_klas","grupa","id","jur_grupas_id"&k,grupas_id_value
	e_jur_grupas.MoveNext
	loop
%>
<br>
	<input type="hidden" name="id" value="<%=id%>">

<input type="submit">
</form>
<br>
<form action="jur_grupas_add.asp" method="POST">

	<%dbcomboplus "dalibn_jur_klas","grupa","id","jur_grupas_id",1%>
	<input type="hidden" name="id" value="<%=id%>">
<br>
<input type="submit">
<br>
<a href="dalibn_jur.asp?i=<%=id%>">Back</a>