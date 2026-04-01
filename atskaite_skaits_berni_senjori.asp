<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
'atver datu baazi
dim conn
openconn
'standarts visaam lapaam
docstart "atskaite","y1.jpg"

	ssql = "select distinct p.id as pid, d.id, cast(right(d.pk1, 2) as int) as gads " +_
			"from pieteikums p " +_
			"inner join piet_saite ps on ps.pid = p.id " +_
			"inner join grupa g on g.id = p.gid " +_
			"inner join dalibn d on d.id = ps.did " +_
			"where p.deleted = 0 and ps.deleted = 0 and g.kods like '%10.V%' and atcelta = 0 " +_
			"and len(d.pk1)=6"


	set r = conn.execute(ssql)
	
	dim berni
	dim senjori, citi, kopa
	
	while not r.EOF
	
		if(110-r("gads")<=16 or r("gads")<=10 ) then
			berni = berni +1
		elseif(110-r("gads")>=60) then
			senjori = senjori + 1
		else
			citi = citi + 1
		end if
	
		kopa = kopa + 1
	
		r.moveNext
	wend 


%>

<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Askaite 2010 vâktâs grupas</b></font><hr>

<p>Bçrni = <%=berni%><br/>Senjori = <%=senjori%><br/>Citi = <%=citi%><br/><br/>Kopâ: <%=kopa%></p>


</body>
</html>
