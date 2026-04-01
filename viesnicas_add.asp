<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
viesnicas_veids = getnum(request.form("viesnicas_veids"))
'ja izvēlēts SINGLE, pārbauda vai grupai ir pakalpojums 'piemaksa par single'
skaits = getnum(request.form("skaits"))
'---- nosaka vietu skaitu
set r = conn.execute("SELECT * FROM viesnicas_veidi where id = " + cstr(viesnicas_veids))
if r("nosaukums") = "SINGLE" then
	nav_piemaksas = 0
	set r_piemaksa = conn.execute("SELECT * FROM vietu_veidi WHERE gid=" + cstr(r("gid")) + " AND tips='V1'")
	if r_piemaksa.eof then
		'--- pārbauda, vai grupa nav čarteris. Čarteriem ļauj pievienot singlus bez piemaksas - 28.08.2018
		set rGr = conn.execute("SELECT carter FROM grupa WHERE id="+ cstr(r("gid")))
		if getnum(rGr("carter")) = 0 then
			nav_piemaksas = 1
		end if
	end if
	
	if (nav_piemaksas = 1) then
		'--- pārbaudam, vai ir singla veidi bez cenām
		set rVV = conn.execute("SELECT * FROM viesnicas_veidi WHERE " + _
			" nosaukums = 'SINGLE' " + _
			" and vietu_veidi_id is null and gid =" + cstr(r("gid")) )
		if rVV.eof then
			nav_piemaksas = 0
		end if
	end if
	
end if

if nav_piemaksas = 1 then
	SESSION("MESSAGE") = "Grupai nav pievienota piemaksa vai nor�d�ta b�zes cena par SINGLE numuriem! Numurs nav pievienots."
	response.redirect "viesnicas.asp?gid="+cstr(r("gid"))
end if


for viesn_counter = 1 to skaits
	conn.execute "INSERT INTO viesnicas (gid,vietas,veids) VALUES (" + cstr(r("gid")) + "," + cstr(r("vietas"))+"," + cstr(viesnicas_Veids) + ")"
	'17.04.2019 RT  - logojam vesturi detalizetaku
	set rID = conn.execute("select max(id) from viesnicas where gid = " + cstr(r("gid")))
	LogInsertAction "viesnicas",rID(0)
next
response.redirect "viesnicas.asp?gid="+cstr(r("gid"))
%>


