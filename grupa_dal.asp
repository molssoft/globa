<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
server.ScriptTimeout = 64000
mazie = Request.Form("mazie")
x = 1
if Request.Form("saites") = "yes" then
	ieklaut_saites = true
else
	ieklaut_saites = false
end if
gid=Request.QueryString("gid")+""
if gid="" then
	message = "Nav norâdîta grupa!"
else
   if (ieklaut_saites) then
		message = "<a href = 'grupa_edit.asp"+qstring()+"'> Grupas saraksts </a><br>" + grupas_nosaukums(gid,NULL)
	
	else
		message = "Grupas saraksts<br>" + grupas_nosaukums(gid,NULL)	
	end if
	set rGrupa = conn.execute("select * from grupa where id = "+gid)
end if

valuta_nos = grupa_nval(gid)
poga_var = request.form("poga")
distinct_pid = ""
join_orderis = ""	

if Request.Form("anglu") = "yes" then
 query = " SELECT "+distinct_pid+" dalibn.ID AS did, REPLACE(dalibn.vards2,'#','') AS vards, REPLACE(dalibn.nosaukums2,'#','') AS nosaukums, REPLACE(dalibn.uzvards2,'#','') AS uzvards, "
else
 query = " SELECT "+distinct_pid+" dalibn.ID AS did, dalibn.vards, dalibn.nosaukums, dalibn.uzvards, "
end if

vaditajs_where = " and isnull(vietu_veidi.tips,'') <> 'G' and pieteikums.grupas_vad = 0 "
if request.form("vaditajs") = "yes" then 
	vaditajs_where = ""	
end if

'' parbaudam vai grupai ir bazes cena
set rBaze = conn.execute("select * from vietu_veidi where tips = 'C' AND gid = " + cstr(gid))


query = query + "dalibn.dzimsanas_datums " + _ 
	", dalibn.talrunisMvalsts " + _ 
	", dalibn.talrunism " + _ 
	", dalibn.talrunisdvalsts " + _ 
	", dalibn.talrunisd " + _ 
	", dalibn.talrunisMobvalsts " + _ 
	", dalibn.talrunisMob " + _ 
	", dalibn.eadr " + _ 
	", dalibn.pk1 " + _ 
	", dalibn.pk2 " + _ 
	", dalibn.paseS " + _ 
	", dalibn.paseNR " + _ 
	", dalibn.paseDERdat " + _ 
	", dalibn.idS " + _ 
	", dalibn.idNR " + _ 
	", dalibn.idDERdat " + _ 
	", dalibn.piezimes as dalibn_piezimes " + _ 
	", dalibn.visas " + _ 
	", piet_saite.id as psid " + _ 
	", (select isnull(count(*),0) from piet_saite where pid = pieteikums.id and papildv = 1 and piet_saite.deleted = 0) as papildv " + _ 
	", piet_saite.persona " + _ 
	", piet_saite.vietsk " + _ 
	", piet_saite.vietas_veids as vietas_veids " + _ 
	", pieteikums.zid " + _ 
	", Pieteikums.id as pid " + _ 
	", Pieteikums.gid " + _ 
	", Pieteikums.grupas_vad " + _ 
	", Pieteikums.datums " + _ 
	", pieteikums.piezimes as piezimes " + _ 
	", pieteikums.piezimes_visiem as piezimes_visiem " + _ 
	", " + _
	"pieteikums.iemaksas " + _ 
	",pieteikums.izmaksas " + _ 
	",pieteikums.atlaides " + _ 
	",pieteikums.bilance " + _ 
	",pieteikums.summa " + _ 
	",pieteikums.atlaidesLVL " + _ 
	",pieteikums.atlaidesUSD " + _ 
	",pieteikums.atlaidesEUR " + _ 
	",pieteikums.iemaksasLVL " + _ 
	",pieteikums.iemaksasUSD " + _ 
	",pieteikums.iemaksasEUR " + _ 
	",pieteikums.sadardzinLVL " + _ 
	",pieteikums.sadardzinUSD " + _ 
	",pieteikums.sadardzinEUR " + _ 
	",pieteikums.izmaksasLVL " + _ 
	",pieteikums.izmaksasUSD " + _ 
	",pieteikums.izmaksasEUR " + _ 
	",pieteikums.summaLVL " + _ 
	",pieteikums.summaUSD " + _ 
	",pieteikums.summaEUR " + _ 
	",pieteikums.bilanceLVL " + _ 
	",pieteikums.bilanceUSD " + _ 
	",pieteikums.bilanceEUR " + _ 
	",pieteikums.ligums_id " + _ 
	",pieteikums.online_rez " + _
	",isnull(adrese,'') " + _
	" + isnull(', ' + pilseta,'') " + _
	" + ISNULL(', ' + novads.nosaukums + ' novads','') " + _
	" + isnull(', LV-'+indekss,'') as adrese_full" + _
	", (select min(datums) from orderis where pid = pieteikums.id or nopid = pieteikums.id) as min_ord_dat " + _
	", (select max(datums) from orderis where pid = pieteikums.id or nopid = pieteikums.id) as max_ord_dat " + _
	" FROM dalibn  " + _ 
	" LEFT JOIN novads on dalibn.novads = novads.id  " + _ 
	" INNER JOIN ( " + _ 
		"Pieteikums  " + _ 
		"INNER JOIN piet_saite ON Pieteikums.id = piet_saite.pid  " + _ 
		"left join vietu_veidi on piet_saite.vietas_veids = vietu_veidi.id " + _ 
	") ON dalibn.ID = piet_saite.did " + _
	join_orderis + _
	"WHERE isnull(piet_saite.papildv,0) = 0 " + vaditajs_where + " and pieteikums.gid = "+cstr(gid)+ _ 
	" AND (isnull(piet_saite.kvietas_veids,0) <> 6 OR (isnull(piet_saite.kvietas_veids,0) = 6 " + _ 
	" AND piet_saite.papildv=1)) AND (isnull(piet_saite.kvietas_veids,0) <> 3 OR " + _ 
	" (isnull(piet_saite.kvietas_veids,0) = 3 AND piet_saite.papildv=1)) " + _ 
	" AND piet_saite.deleted = 0 and pieteikums.deleted = 0 and (isnull(pieteikums.tmp,0)=0 OR agents_izv=1) "

''ja ir bazes cena tad skaitam personas nevis pieteikumus
	if not rBaze.eof then
	query = query + " AND (Pieteikums.personas > 0 or pieteikums.grupas_vad = 1) "
	end if

''response.write query

if request.form("ar_atlikumu") = "yes" then
	if request.form("datums_lidz") <> "" then
		query = query + " AND ( " + _
			" isnull(pieteikums.bilanceLVL,0)<>0 " + _
			" OR isnull(pieteikums.bilanceUSD,0)<>0 " + _ 
			" OR isnull(pieteikums.bilanceEUR,0)<>0 " + _ 
			" OR (select max(datums) from orderis where pid = pieteikums.id or nopid = pieteikums.id) > '"+sqldate(request.form("datums_lidz"))+"' " + _ 
			" ) "
	else
		query = query + " AND (isnull(pieteikums.bilanceLVL,0)<>0 OR isnull(pieteikums.bilanceUSD,0)<>0 OR isnull(pieteikums.bilanceEUR,0)<>0) "
	end if
end if

if request.form("tikai_kajites")="yes" then
 query = query + " and isnull(piet_saite.kid,0)<>0 "
end if

if request.form ("sort") = "datums" then
	query = query + "ORDER BY pieteikums.datums, pieteikums.id , piet_saite.persona desc; "
end if
if request.form("sort") = "uzvards" then
	query = query + "ORDER BY dalibn.uzvards, pieteikums.datums, pieteikums.id, piet_saite.persona desc; "
end if
if request.form("sort") = "piezimes" then
	query = query + "ORDER BY dalibn.piezimes, piet_saite.persona desc; "
end if


'rw query
'Response.End
	
set rec = server.createobject("ADODB.Recordset")
rec.open query,conn,3,3

'Response.End

%>

<%DefJavaSubmit%>

<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1257">
<META NAME="Generator" CONTENT="Microsoft Word 97">
<META NAME="Template" CONTENT="C:\PROGRAM FILES\MICROSOFT OFFICE\OFFICE\html.dot">
<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
<script>
$(function() {
   /*var header_height = 0;
    $('.rotate-table-grid th span').each(function() {
        if ($(this).outerWidth() > header_height) header_height = $(this).outerWidth();
    });
    $('.rotate-table-grid th').height(header_height);
	alert(header_height);*/

});
</script>

<style>
  .rotated-text {
    display: inline-block;
    overflow: hidden;
    width: 1.5em;

}
.rotated-text__inner {
	text-align:left;
    display: inline-block;
    white-space: nowrap;
    /* this is for shity "non IE" browsers
       that doesn't support writing-mode */
    -webkit-transform: translate(1.1em,0) rotate(90deg);
       -moz-transform: translate(1.1em,0) rotate(90deg);
         -o-transform: translate(1.1em,0) rotate(90deg);
            transform: translate(1.1em,0) rotate(90deg);
    -webkit-transform-origin: 0 0;
       -moz-transform-origin: 0 0;
         -o-transform-origin: 0 0;
            transform-origin: 0 0;
   /* IE9+ */
   -ms-transform: none;
   -ms-transform-origin: none;
   /* IE8+ */
   -ms-writing-mode: tb-rl;
   /* IE7 and below */
   *writing-mode: tb-rl;
}
.rotated-text__inner:before {
    content: "";
    float: left;
    margin-top: 100%;
}

/* mininless css that used just for this demo */
.container {
  float: left;
}

td,th,table {
font-size:11pt;
	border-collapse: collapse;
	padding: 2px;
	<%if Request.Form("borders")="" then%>
	border-width:0.25pt;
	<% end if %>
}

</style>
</HEAD>
<BODY LINK="#0000ff" VLINK="#800080" >
<form name = forma method = POST></form>
  
<center>
<font size="4"><%=message%></font>
<br><br>
<%if Request.Form("datums_no")<>"" then%>
<div align="center">Iemaksu periods no: <%=Request.Form("datums_no")%></div>
<br>
<%end if%>

<%if Request.Form("datums_lidz")<>"" then%>
<div align="center">Iemaksu periods lîdz: <%=Request.Form("datums_lidz")%></div>
<br>
<%end if%>

<% if rec.recordcount > 0 then %>
<table class="rotate-table-grid" border="1"><!--style="font-size:12px"-->
	<th>Nr.</th>
<% if request.form("uzvards") = "yes" then %>
	<th>Uzvârds</th>
<% end if %>
<% if request.form("vards") = "yes" then %>
	<th>Vârds</th>
<% end if %>
<% if request.form("papildvieta") = "yes" then %>
	<th>P</th>
<% end if %>
<% if request.form("pk") = "yes" then %>
	<th colspan="2">Personas kods</th>
<% end if %>
<% if request.form("dzimsanas_datums") = "yes" then %>
	<th>Dz. datums</th>
<% end if %>
<% if request.form("pase") = "yes" then %>
	<th colspan="2">Pase</th>
<% end if %>
<% if request.form("pases_der") = "yes" then %>
	<th>Pase derîga lîdz</th>
<% end if %>

<% if request.form("id_karte") = "yes" then %>
	<th colspan="2">ID karte</th>
<% end if %>

<% if request.form("id_der") = "yes" then %>
	<th colspan="2">ID derîga</th>
<% end if %>

<% if request.form("dokumenti") = "yes" then %>
	<th colspan="2">Dokumenti</th>
<% end if %>

<% if request.form("datums") = "yes" then %>
	<th>Datums</th>
<% end if %>
<% if request.form("talrunism") = "yes" then %>
	<th>Talr. m.</th>
<% end if %>
<% if request.form("talrunisd") = "yes" then %>
	<th>Tâlr. d.</th>
<% end if %>
<% if request.form("talrunisMob") = "yes" then %>
	<th>Tâlr. mob.</th>
<% end if %>
<% if request.form("epasts") = "yes" then %>
	<th>Epasts</th>
<% end if %>
<% if request.form("adrese") = "yes" then %>
	<th>Adrese</th>
<% end if %>
<% if request.form("ligums") = "yes" then %>
	<th>Lîgums</th>
<% end if %>
<% if request.form("cena") = "yes" then %>
	<th>B.cena</th>
<% end if %>
<% if request.form("atlaides") = "yes" then %>
	<th>Atlaides</th>
<% end if %>
<% if request.form("jamaksa") = "yes" then %>
	<th>Jâmaksâ</th>
<% end if %>
<% if request.form("iemaksas") = "yes" then %>
	<th>Iemaksas</th>
<% end if %>
<% if request.form("summa") = "yes" then %>
	<th>Summa</th>
<% end if %>
<% if request.form("bilance") = "yes" then %>
	<th>Bilance</th>
<% end if %>
<% if request.form("neapstiprinatas") = "yes" then %>
	<th>Neapstiprinâtas</th>
<% end if %>
<% if request.form("piezimes") = "yes" then %>
	<th>Piet. piezîmes</th>
<% end if %>
<% if request.form("dalibn_piezimes") = "yes" then %>
	<th>Dalibn. Piezîmes</th>
<% end if %>
<% if request.form("visas") = "yes" then %>
	<th>Vîzas</th>
<% end if %>
<% if request.form("komentars") = "yes" then %>
	<th>Rezervâcijas komentârs</th>
<% end if %>
<% if request.form("pakalpojumi") = "yes" then %>
	<th>Pakalpojumi</th>
<% end if %>
<% if request.form("pakalpojumi_det") = "yes" then 
	set rVV = conn.execute("SELECT * FROM vietu_veidi  where tips NOT IN('P','G') AND gid="+cstr(gid)+" ORDER BY  id ASC")
	if not rVV.eof then
		while not rVV.eof 
			%>
			<th style="vertical-align:bottom"><div class="rotated-text"><span class="rotated-text__inner"><%=rVV("nosaukums")%></span></div></th>
			<%
			rVV.movenext
		wend
	end if%>

<% end if %>
<% if request.form("kajite") = "yes" then %>
	<th>Kajîte</th>
<% end if %>
<% if request.form("gdatumi") = "yes" then %>
	<th>Datums</th>
<% end if %>
<% if request.form("vardadienas") = "yes" then %>
	<th>Vârda diena</th>
<% end if %>
<% if request.form("dzimsanas_diena") = "yes" then %>
	<th>Dzimðanas diena</th>
<% end if %>
<% if request.form("zidainis") = "yes" then %>
	<th>Zidainis</th>
<% end if %>
<%
rec.movefirst
i = 1
page = Request.Form("page")
if page = "" then page = 1

total_jamaksaLVL = 0
total_jamaksaUSD = 0
total_jamaksaEUR = 0

total_iemaksasLVL = 0
total_iemaksasUSD = 0
total_iemaksasEUR = 0

total_summaLVL = 0
total_summaUSD = 0
total_summaEUR = 0

total_bilanceLVL = 0
total_bilanceUSD = 0
total_bilanceEUR = 0

total_neapstLVL = 0
total_neapstUSD = 0
total_neapstEUR = 0

lastpid = 0
lastdid = 0

while not rec.eof

  pid=rec("pid")
  did=rec("did")
  zid=getnum(rec("zid"))

  

  if pid<>lastpid or ((rec("papildv")=-1 or rec("persona")=-1 or rec("grupas_vad") <> 0) and Request.Form("vienureizi")<>"yes") then
	'--- orderu summu parrekins, ja parametros ir noraadiits 'datums liidz'
      
    d_lidz = Request.Form("datums_lidz")
    d_no = Request.Form("datums_no")
    
    set r = server.createobject("ADODB.Recordset")
	'ja visi pieteikuma orderi ir jaunâki par norâdîto datumu, râdîsim pieteikuma bilanci (nekalkulçjam orderu summas)
	summet_orderus = true
	if d_lidz<> "" then
		'rw dateprint(rec("max_ord_dat"))
	'	rw "<br>"
  		'if (rec("max_ord_dat")) <= cdate(d_lidz) then
			'rw "radam piet bilanci<br>"
			
			'- aikomentçjam pagaidâm (06.02.2018)
			'summet_orderus = false
		'end if
	end if

    if (request.form("iemaksas") = "yes" OR d_lidz <> "" OR d_no <> "" OR request.form("ar_atlikumu") = "yes") AND summet_orderus then
		'rw "summçjam orderus<br>"
		
		
    
		if d_lidz = "" then 
			datums_lidz = now
		else 
			datums_lidz = d_lidz
		end if
		
		if d_no<>"" then
			datums_no = "AND datums >= '"+d_no+"'"
		else
			datums_no = ""
		end if
		    
	    ssql = "select pid,nopid,summaLVL,summaEUR,summaUSD,nosummaLVL,nosummaUSD,nosummaEUR,rekins,orderis.datums,summaval,val from orderis LEFT JOIN valuta ON valuta.ID = orderis.valuta where (pid = " + cstr(rec("pid"))+" or nopid = "+ cstr(rec("pid")) +") AND (not deleted = 1) "+datums_no+" AND orderis.datums<='"+sqldate(datums_lidz)+"' order by orderis.id"
    	
		set r = conn.execute(ssql)
		
		ien_summaLVL = 0
		ien_summaUSD = 0
		ien_summaEUR = 0
		ien_summa = 0

		izd_summaLVL = 0
		izd_summaUSD = 0
		izd_summaEUR = 0
		izd_summa = 0						

		s_orderi = ""
		
		if not r.eof then
			j = 1
    		s_orderi = "<td>"
    		while not r.eof
				''shis mainigais neizmantojas, bet ridina nepiecieshama lai noverstu recordseta gluku
				summaLVL = getnum(r("summaLVL"))
				summaEUR = getnum(r("summaEUR"))
				summaUSD = getnum(r("summaUSD"))
				nosummaLVL = getnum(r("nosummaLVL"))
				nosummaEUR = getnum(r("nosummaEUR"))
				nosummaUSD = getnum(r("nosummaUSD"))

    			s_orderi = s_orderi + "<b>" + cstr(j)+". </b>"
				''saskaitam ienâkumus 
    			if r("pid") = rec("pid") Then
    				ien_summaLVL = ien_summaLVL + summaLVL
    				ien_summaUSD = ien_summaUSD + summaUSD
    				ien_summaEUR = ien_summaEUR + summaEUR
				
					
					if summaLVL = 0 and summaEUR = 0 and summaUSD = 0 then
						if r("val")= "LVL" then ien_summaLVL = ien_summaLVL + r("summaval")
						if r("val")= "USD" then ien_summaUSD = ien_summaUSD + r("summaval")
						if r("val")= "EUR" then ien_summaEUR = ien_summaEUR + r("summaval")
						s_orderi = s_orderi + "+" + cstr(r("summaval"))+" "+cstr(r("val"))+ " "
					else
						
						If summaLVL<>0 then
							s_orderi = s_orderi + "+" + cstr(summaLVL)+" LVL "
						End if
						If summaEUR<>0 then
							s_orderi = s_orderi + "+" + cstr(summaEUR)+" EUR "
						End if
						If summaUSD<>0 then
							s_orderi = s_orderi + "+" + cstr(summaUSD)+" USD "
						End if
					end if
				End If
				
				''saskaitam izdevumus
				
    			if r("nopid") = rec("pid") Then
			
    				izd_summaLVL = izd_summaLVL + nosummaLVL
       				izd_summaUSD = izd_summaUSD + nosummaUSD
    				izd_summaEUR = izd_summaEUR + nosummaEUR
					'rw izd_summaEUR
					if nosummaLVL = 0 and nosummaEUR = 0 and nosummaUSD = 0 then
						if r("val")= "LVL" then izd_summaLVL = izd_summaLVL+ r("summaval")
						if r("val")= "USD" then izd_summaUSD = izd_summaUSD + r("summaval")
						if r("val")= "EUR" then izd_summaEUR = izd_summaEUR + r("summaval")
						s_orderi = s_orderi + "-" + cstr(r("summaval"))+" "+cstr(r("val"))+ " "
					else
						If nosummaLVL<>0 then
							s_orderi = s_orderi + "-"+cstr(nosummaLVL)+" LVL "
						End if
						If nosummaEUR<>0 then
							s_orderi = s_orderi + "-"+cstr(nosummaEUR)+" EUR "
						End if
						If nosummaUSD<>0 then
							s_orderi = s_orderi + "-"+cstr(nosummaUSD)+" USD "
						End if
					end if
    			end if
    			s_orderi = s_orderi + cstr(dateprint(r("datums")))
    			if getnum(r("rekins"))<>0 then
    			 s_orderi = s_orderi + " Rçíins:"+cstr(r("rekins"))
    			end if
    			s_orderi = s_orderi + "<br>"
    			
    			j = j + 1
    			r.movenext
    		wend
    		s_orderi = s_orderi + "</td>"
    	else
    		s_orderi = "<td>NAV</td>"
		end if
    
    end if
    
	'-------------------------------------------------
	
	
		

	sumLVL = -(getnum(rec("summaLVL"))+getnum(rec("sadardzinLVL"))-getnum(rec("atlaidesLVL"))-(getnum(ien_summaLVL)-getnum(izd_summaLVL)) )
   sumUSD = -(getnum(rec("summaUSD"))+getnum(rec("sadardzinUSD"))-getnum(rec("atlaidesUSD"))-(getnum(ien_summaUSD)-getnum(izd_summaUSD)) )
   sumEUR = -(getnum(rec("summaEUR"))+getnum(rec("sadardzinEUR"))-getnum(rec("atlaidesEUR"))-(getnum(ien_summaEUR)-getnum(izd_summaEUR)) )
 
	'--------------
	
    'sum = ien_summa - izd_summa
		
	'--- parbauda vai ir atlikums ---------------------	
	'if request.form("ar_atlikumu") = "yes" and getnum(sum) = 0 then
	if request.form("ar_atlikumu") = "yes" and getnum(sumLVL) = 0 and getnum(sumUSD) = 0 and getnum(sumEUR) = 0 then		
		'RW "NERÂDÂM<br>"

		'--- bez atlikuma nedrukâ
	
	else
	
	'--- drukâ ierakstu----------
	if (isnull(rec("vietsk"))) then 
	vietsk = 1
	else vietsk = rec("vietsk")
	end if
	
	if rec("grupas_vad") <> 0 then vietsk = 1
	
   for isk = 1 to vietsk
    response.write "<tr>"
		
		%><td>
		<% if ieklaut_saites then
		%><a target="_blank" href="dalibn.asp?i=<%=cstr(i)%>" style="text-decoration:none;color:black" ><%=cstr(i)%><!--img border="0" src="impro/bildes/k_zals.gif"--></a>
		<% else %>
			<% if rec("grupas_vad") <> 0 then %>
				<font color=blue><%=cstr(i)%></font>
			<% else %>
				<%=cstr(i)%>
			<% end if %>
		<% end if%>
		</td><%
		
    '-----------------------------------------------
    if request.form("uzvards") = "yes" then
    	%><td>
    	<% if Request.Form("blitkas") = "yes" then '--- blitkas %>
    	   <% if mazie = "yes" then 
    	   
    			if nullprint(rec("uzvards")) <> "" then 
    				Response.write maziemburtiem(nullprint(rec("uzvards")))
    			elseif nullprint(rec("nosaukums")) <> "" then
    				Response.write maziemburtiem(nullprint(rec("nosaukums")))
    			else
    				Response.Write "-"
    			end if

    	     else 
    				if nullprint(rec("uzvards")) <> "" then 
    					Response.write ucase(nullprint(rec("uzvards")))
    				elseif nullprint(rec("nosaukums")) <> "" then
    					Response.write ucase(nullprint(rec("nosaukums")))
    				else
    					Response.Write "-"
    				end if
        	 
    	     end if %>

		<% else '--- saraksts %>
    	
    	   <% if mazie = "yes" then 
				if ieklaut_saites then %>
				<a style="text-decoration:none;color:black" target=new<%=rec("pid")%> href="pieteikums.asp?pid=<%=cstr(rec("pid"))%>">
    			<%
				end if
    				if nullprint(rec("uzvards")) <> "" then 
    					Response.write MaziemBurtiem(nullprint(rec("uzvards")))
    				elseif nullprint(rec("nosaukums")) <> "" then
    					Response.write MaziemBurtiem(nullprint(rec("nosaukums")))
    				else
    					Response.Write "-"
    				end if
				if ieklaut_saites then %></a><% end if%>
    	   <% else
				if ieklaut_saites then %>
				<a style="text-decoration:none;color:black" target=new<%=rec("pid")%> href="pieteikums.asp?pid=<%=cstr(rec("pid"))%>">
         		<%
				end if
         		
         			if nullprint(rec("uzvards")) <> "" then 
    					Response.write ucase(nullprint(rec("uzvards")))
    				elseif nullprint(rec("nosaukums")) <> "" then
    					Response.write ucase(nullprint(rec("nosaukums")))
    				else
    					Response.Write "-"
    				end if
         		
         		if ieklaut_saites then %></a><% end if%>
    	   <% end if %>
    	
    	<% end if%>
    	</td><%
    end if
    '----------------------------------------------- 
	
    if request.form("vards") = "yes" then
    	%><td>
    	<% if Request.Form("blitkas") = "yes" then %>
    	    <% 'bïitkâm drukâ bez linkiem %>
    	    <% if mazie = "yes" then %>
    	     <%=maziemburtiem(nullprint(rec("vards")))%>
    	    <% else %>
    	     <%=ucase(nullprint(rec("vards")))%>
    	    <% end if %>
    	<% else %>
    	    <% if mazie = "yes" then
				if ieklaut_saites then%>
					<a style="text-decoration:none;color:black" target=new<%=rec("pid")%> href="pieteikums.asp?pid=<%=cstr(rec("pid"))%>">
				<% end if%>
				<%=MaziemBurtiem(nullprint(rec("vards")))%>
				<%if ieklaut_saites then %></a><% end if%>
    	    <% else
				if ieklaut_saites then %>
					<a style="text-decoration:none;color:black" target=new<%=rec("pid")%> href="pieteikums.asp?pid=<%=cstr(rec("pid"))%>">

				<% end if %>
				<%=ucase(nullprint(rec("vards")))%>
				<%if ieklaut_saites then %></a><% end if%>
    	    <% end if %>
    	<% end if %>
    	</td><%
    end if
    '-----------------------------------------------
	 if request.form("papildvieta") = "yes" then
		if rec("papildv") <> 0 then
			response.write "<td>"+cstr(rec("papildv"))+"</td>"
		else
			response.write "<td></td>"
		end if
	end if
    '-----------------------------------------------
    if request.form("pk") = "yes" then
    response.write "<td>"+ucase(nullprint(rec("pk1")))+"</td>"
    response.write "<td>"+ucase(nullprint(rec("pk2")))+"</td>"
    end if
    '-----------------------------------------------
    if request.form("dzimsanas_datums") = "yes" then
    response.write "<td>"+dateprint(rec("dzimsanas_datums"))+"</td>"
    end if
    '-----------------------------------------------
    if request.form("pase") = "yes" then
		response.write "<td>"+ucase(nullprint(rec("paseS")))+"</td>"
		response.write "<td>"+ucase(nullprint(rec("paseNr")))+"</td>"
    end if

    if request.form("pases_der") = "yes" then
	    if not isnull(rec("paseDERdat")) then
			response.write "<td>"+nullprint(dateprint(rec("paseDERdat")))+"</td>"
	    else
			response.write "<td>&nbsp;</td>"
		end if
    end if
    '-----------------------------------------------
    if request.form("id_karte") = "yes" then
	    response.write "<td>"+ucase(nullprint(rec("idS")))+"</td>"
		response.write "<td>"+ucase(nullprint(rec("idNr")))+"</td>"
    end if
    '-----------------------------------------------
    if request.form("id_der") = "yes" then
	    if not isnull(rec("idDERdat")) then
			response.write "<td>"+nullprint(dateprint(rec("idDERdat")))+"</td>"
	    else
			response.write "<td>&nbsp;</td>"
		end if
    end if
    '-----------------------------------------------
    if request.form("dokumenti") = "yes" then
		response.write "<td>"
		set rdok = conn.execute("select * from dokumenti where did = " + cstr(did) + " or pid = " + cstr(pid))
		dok_num = 1
		while not rdok.eof
			if (dok_num>1) then response.write "<BR>"
			response.write rdok("file_original_name")
			dok_num = dok_num + 1
			rdok.movenext
		wend
		response.write "</td>"
    end if
    '-----------------------------------------------
    if request.form("datums") = "yes" then
    response.write "<td>"+dateprint(rec("datums"))+"</td>"
    end if
    '-----------------------------------------------
    if request.form("talrunism") = "yes" then
    response.write "<td>"+PrintTalr(rec("talrunisMvalsts"),rec("talrunism"))+"</td>"
    end if
    '-----------------------------------------------
    if request.form("talrunisd") = "yes" then
    response.write "<td>"+PrintTalr(rec("talrunisDvalsts"),rec("talrunisd"))+"</td>"
    end if
    '-----------------------------------------------
    if request.form("talrunisMob") = "yes" then
    response.write "<td>"+PrintTalr(rec("talrunisMobvalsts"),rec("talrunisMob"))+"</td>"
    end if
    '-----------------------------------------------
    if request.form("epasts") = "yes" then
    response.write "<td>"+nullprint(rec("eadr"))+"</td>"
    end if
    '-----------------------------------------------
    if request.form("adrese") = "yes" then
    response.write "<td>"+nullprint(rec("adrese_full"))+"</td>"
    end if
	  '-----------------------------------------------
    if request.form("ligums") = "yes" then
	response.write "<td>"
	ligums_id = getnum(rec("ligums_id"))
				accepted = 0
				
				'mçìinam atrast lîgumu kas saglabâts savâdâk. 
				'tâ nevajadzçtu bût, bet daþreiz gadâs
				if ligums_id = 0 and getnum(rec("online_rez"))<>0 then
					set rlig = conn.execute("select id from ligumi where deleted = 0 and rez_id = "+cstr(rec("online_rez"))+" order by id desc" )
					if not rlig.eof then 
						ligums_id = rlig("id")
					end if
				end if
				'rw ligums_id
				
				if ligums_id <> 0 then 
					eksiste_ligumi = 1
					ssql = "select isnull(nosutits,0) as nosutits,isnull(parakstits,0) as parakstits,accepted from ligumi where deleted = 0 and id = "+CStr(ligums_id)
					'rw ssql
					Set ligums = conn.execute("select isnull(nosutits,0) as nosutits,isnull(parakstits,0) as parakstits,accepted from ligumi where deleted = 0 and id = "+CStr(ligums_id))
					accepted = ligums("accepted")
					accepted = 1
					parakstits = ligums("parakstits")
					nosutits = ligums("nosutits")
					
					
					If accepted <> 0 then
						response.write(ligums_id)
					end if
				else
					'--- parbauda vai nav online_rez un taas liigums
					ssql = "select r.ligums_id from pieteikums p inner join online_rez r on r.id = p.online_rez " + _
							"where p.id = "&rec("pid")&" and r.deleted = 0 and p.deleted = 0" 
						'rw ssql	
					set o_rez = conn.execute(ssql)
					if not o_rez.eof Then
						If getnum(o_rez("ligums_id")) <> 0 then
							response.write(getnum(o_rez("ligums_id")))
						end if
						end if
				end if
    response.write "</td>"
    end if
    '-----------------------------------------------    
    if request.form("cena") = "yes" then
    if isk = 1 and (pid<>lastpid or request.form("sort") <> "datums") Then
		''dabonam bazes cenu
		Set bcena = conn.execute("select vietas_cenaEUR from piet_saite where pid = "+CStr(pid)+" and deleted = 0 and vietas_veids in (select id from vietu_veidi where tips = 'C')")
     response.write "<td>"+CurrPrint(getnum(bcena("vietas_cenaEUR")))+"</td>"
    else
     response.write "<td>^</td>"
    end if
    end if
    '-----------------------------------------------
    if request.form("atlaides") = "yes" then
    if isk = 1 and (pid<>lastpid or request.form("sort") <> "datums") then
     set r=conn.execute("select * from piet_atlaides where pid = "+cstr(pid))
     response.write "<td>"
     while not r.eof
      response.write DatePrint(r("datums"))+" "
      if getnum(r("atlaide")) <> 0 then response.write CurrPrint(getnum(r("atlaide")))
      if getnum(r("atlaideLVL")) <> 0 then response.write CurrPrint(getnum(r("atlaideLVL")))+ " LVL"
      if getnum(r("atlaideUSD")) <> 0 then response.write CurrPrint(getnum(r("atlaideUSD")))+ " USD"
      response.write " "
      response.write r("piezimes")
      r.movenext
      if not r.eof then response.write "<br>"
     wend
     response.write "</td>"
    else
     response.write "<td>^</td>"
    end if 
    end if
    '-----------------------------------------------
    if request.form("jamaksa") = "yes" then
    if isk = 1 and (pid<>lastpid or request.form("sort") <> "datums") then
    
     sumLVL = getnum(rec("summaLVL"))+getnum(rec("sadardzinLVL"))-getnum(rec("atlaidesLVL"))
     sumUSD = getnum(rec("summaUSD"))+rec("sadardzinUSD")-getnum(rec("atlaidesUSD"))
     sumEUR = getnum(rec("summaEUR"))+rec("sadardzinEUR")-getnum(rec("atlaidesEUR"))
     
     total_jamaksaLVL = total_jamaksaLVL + sumLVL
     total_jamaksaUSD = total_jamaksaUSD + sumUSD
     total_jamaksaEUR = total_jamaksaEUR + sumEUR
     
     response.write "<td>"+Curr3Print2(sumLVL,sumUSD,sumEUR)+"</td>"

    else
     response.write "<td>^</td>"
    end if
    end if
    '-----------------------------------------------
    
    
    '---!orderu summu aprekins parnests uz cikla sakumu
    '---
    
    
    if request.form("iemaksas") = "yes" then
		if isk = 1 and (pid<>lastpid or request.form("sort") <> "datums") then
			
			Response.Write s_orderi
			
			sumLVL = getnum(ien_summaLVL)-getnum(izd_summaLVL)
			sumUSD = getnum(ien_summaUSD)-getnum(izd_summaUSD)
			sumEUR = getnum(ien_summaEUR)-getnum(izd_summaEUR)
			
			total_iemaksasLVL = total_iemaksasLVL + sumLVL
			total_iemaksasUSD = total_iemaksasUSD + sumUSD
			total_iemaksasEUR = total_iemaksasEUR + sumEUR
			
		else
			response.write "<td>^</td>"
		end if
    end if
    '-----------------------------------------------
    if request.form("summa") = "yes" then
     if isk = 1 and (pid<>lastpid or request.form("sort") <> "datums") then
      if d_lidz <> "" and summet_orderus then 
      '--- parrekinaata summa no orderiem
		
		sumLVL = getnum(ien_summaLVL)-getnum(izd_summaLVL)
		sumUSD = getnum(ien_summaUSD)-getnum(izd_summaUSD)
		sumEUR = getnum(ien_summaEUR)-getnum(izd_summaEUR)
        
      else 
      '--- summa no pieteikuma, ieprieks aprekinaata

		sumLVL = getnum(rec("iemaksasLVL"))-getnum(rec("izmaksasLVL"))
		sumUSD = getnum(rec("iemaksasUSD"))-getnum(rec("izmaksasUSD"))
		sumEUR = getnum(rec("iemaksasEUR"))-getnum(rec("izmaksasEUR"))

	  end if 
	  
	  Response.write "<td>"+Curr3Print2(sumLVL,sumUSD,sumEUR) + "</td>"
	  
	  total_summaLVL = total_summaLVL + sumLVL
	  total_summaUSD = total_summaUSD + sumUSD
	  total_summaEUR = total_summaEUR + sumEUR
	  
     else
      response.write "<td>^</td>"
     end if
    end if
    '-----------------------------------------------
    if request.form("bilance") = "yes" then
     
     if isk = 1 and (pid<>lastpid or request.form("sort") <> "datums") then
		

      if d_lidz <> "" and summet_orderus then 
	  	 'rw nullprint(rec("vards"))
		'rw "- summejam orderus"

	 
      '--- parrekinaata summa no orderiem
	 
		
        sumLVL = -(getnum(rec("summaLVL"))+getnum(rec("sadardzinLVL"))-getnum(rec("atlaidesLVL"))-(getnum(ien_summaLVL)-getnum(izd_summaLVL)) )
        sumUSD = -(getnum(rec("summaUSD"))+getnum(rec("sadardzinUSD"))-getnum(rec("atlaidesUSD"))-(getnum(ien_summaUSD)-getnum(izd_summaUSD)) )
		sumEUR = -(getnum(rec("summaEUR"))+getnum(rec("sadardzinEUR"))-getnum(rec("atlaidesEUR"))-(getnum(ien_summaEUR)-getnum(izd_summaEUR)) )
	  else 
	  '--- summa no pieteikuma, ieprieks aprekinaata
		sumLVL = getnum(rec("bilanceLVL"))
		sumUSD = getnum(rec("bilanceUSD"))
		sumEUR = getnum(rec("bilanceEUR"))
		'rw sumEUR
		'rw  "<br>"
		
	  end if 
	  
	  Response.write "<td>"+Curr3Print2(sumLVL,sumUSD,sumEUR) + "</td>"
	  'Response.write "<td>"+Curr3Print2(izd_summaLVL,izd_summaUSD,izd_summaEUR) + "</td>"
	  
	  total_bilanceLVL = total_bilanceLVL + sumLVL
	  total_bilanceUSD = total_bilanceUSD + sumUSD
	  total_bilanceEUR = total_bilanceEUR + sumEUR	  
	  
     else
      response.write "<td>^</td>"
     end if 
    end if
    '-----------------------------------------------
    
    if request.form("neapstiprinatas") = "yes" then
     if isk = 1 and (pid<>lastpid or request.form("sort") <> "datums") then
      
		if d_lidz <> "" then 
			whereC = "AND datums<='"+sqldate(datums_lidz)+"'"
		else
			whereC = ""
		end if
		
   	    ssql = "select sum(summaLVL) as summaLVL,sum(summaUSD) as summaUSD,sum(summaEUR) as summaEUR from orderis where (pid = " + cstr(rec("pid"))+" or nopid = "+ cstr(rec("pid")) +") AND (not deleted = 1) AND parbaude=1 " + whereC

        set r_neapst = conn.execute(ssql)
        
        if not r_neapst.eof then
        
			summaLVL = getnum(r_neapst("summaLVL"))
			summaUSD = getnum(r_neapst("summaUSD"))
			summaEUR = getnum(r_neapst("summaEUR"))

			total_neapstLVL = total_neapstLVL + summaLVL
			total_neapstUSD = total_neapstUSD + summaUSD
			total_neapstEUR = total_neapstEUR + summaEUR	

    	end if
    	
    	if (Curr3value(summaLVL,summaLVL,summaLVL)>0) then
			font_color = "red"      		
		else
			font_color = "black"  
    	end if
          	
		Response.write "<td><font color='" + font_color + "'>"+Curr3Print3(summaLVL,summaUSD,summaEUR) + "</font></td>"
	  
     else
      response.write "<td>^</td>"
     end if 
     
    end if    
    '-----------------------------------------------
    
    if request.form("piezimes") = "yes" or request.form("atlaides") = "yes" then
     response.write "<td>"
     response.write ucase(nullprint(rec("piezimes")))
	 if nullprint(rec("piezimes"))<> "" and nullprint(rec("piezimes_visiem"))<> "" then response.write "<BR>"
     response.write ucase(nullprint(rec("piezimes_visiem")))
     if nullprint(rec("piezimes"))<>"" then fullrow=true else fullrow=false
     if request.form("atlaides") = "yes" then
      set rAtlPiez = conn.execute ("select * from piet_atlaides where pid = " + cstr(pid))
      while not rAtlPiez.eof  
       '--- Atkar?b? vai tas ir piemaksa vai atlaides
       if fullrow then response.write "<br>"
       response.write curr3print2(getnum(rAtlPiez("atlaideLVL")),getnum(rAtlPiez("atlaideUSD")),getnum(rAtlPiez("atlaideEUR")))+"-"
       if rAtlPiez("uzcenojums") = true then
        response.write "piemaksa,"
       else
        response.write "atlaide,"
       end if
       response.write nullprint(rAtlPiez("piezimes"))
       rAtlPiez.movenext
       fullrow = true
      wend
     end if
     response.write "</td>"
    end if
    '-----------------------------------------------
    if request.form("dalibn_piezimes") = "yes" then
		response.write "<td>"
     if pid<>lastpid or request.form("sort") <> "datums" then
		if (getnum(rec("online_rez"))<>0) then
			if (rec("dalibn_piezimes") <> "") then
				if (ieklaut_saites) then
					rw "<a href='dalibn.asp?i="+cstr(rec("did"))+"' target='_blank'>"
				end if
				
				rw "!!!PROF. PIEZÎME"
				if (ieklaut_saites) then
					rw "</a>"
				end if
				rw "<br>"
			end if
		end if
      response.write ""+nullprint(rec("dalibn_piezimes"))
     else
      response.write "^"
     end if 
	 response.write "</td>"
    end if
    '-----------------------------------------------
    if request.form("visas") = "yes" then
		response.write "<td>"+nullprint(rec("visas"))+"</td>"
    end if
    '-----------------------------------------------
    if request.form("komentars") = "yes" then
		response.write "<td>"
		if getnum(rec("online_rez"))<>0 then
			set o_rez = conn.execute("select komentars from online_rez where id = "+cstr(rec("online_rez"))+" order by id desc")
			if not o_rez.eof then 
				response.write o_rez("komentars")
			end if
		end if
		response.write "</td>"
    end if
    '-----------------------------------------------
    if request.form("pakalpojumi") = "yes" then
    	if rec("persona") = true then
    		'Atlasa visus pakalpojumus
    		set rPakalpojumi = conn.Execute("SELECT * FROM piet_saite INNER JOIN vietu_veidi ON piet_saite.vietas_veids = vietu_veidi.id " + " WHERE pid = " + cstr(rec("pid")) + " AND did = " + cstr(rec("did")) + " AND piet_saite.papildv = 0 and piet_saite.deleted = 0")
    		x = 0
    		Response.Write "<td>"
    		while not rPakalpojumi.eof
    			if x = 1 then Response.Write "<BR>"
    		    Response.Write rPakalpojumi("Nosaukums")
    		    x = 1
    			rPakalpojumi.movenext
    		wend
    		Response.Write "</td>"
    	end if
    end if
	 '-----------------------------------------------
    if request.form("pakalpojumi_det") = "yes" then
		set rVV = conn.execute("SELECT * FROM vietu_veidi where tips NOT IN('P','G') AND gid="+cstr(gid)+" ORDER BY  id ASC")
		if not rVV.eof then
			while not rVV.eof 
		
				if rec("persona") = true then
					'Atlasa visus pakalpojumus
					set rPakalpojumi = conn.Execute("SELECT * FROM piet_saite WHERE pid = " + cstr(rec("pid")) + " AND did = " + cstr(rec("did")) + " AND piet_saite.deleted = 0 AND vietas_veids="+cstr(rVV("id")))
					
					Response.Write "<td>"
					if not rPakalpojumi.eof then						
						Response.Write "&#10004;"
					else rw "&nbsp"
					end if
					Response.Write "</td>"
				end if
			rVV.movenext
			wend
		end if
    end if
    '-----------------------------------------------
    if request.form("kajite") = "yes" then
      response.write "<td>"
      x=x+1
      set rKaj = conn.execute("select veids from kajite where id in (select kid from piet_saite where isnull(kid,0)<>0 and deleted = 0 and pid = "+cstr(rec("pid"))+") ")
      while not rKaj.eof 
       Response.Write KajVeidaNos_local(rkaj("veids"))
       rKaj.movenext
       if not rKaj.eof then Response.Write ","
      wend
      response.write "</td>"
    end if
    '-----------------------------------------------
    if request.form("gdatumi") = "yes" then
      response.write "<td>"+cstr(twodigits(day(rGrupa("sakuma_dat"))))+"."+cstr(twodigits(month(rGrupa("sakuma_dat"))))+".-"+cstr(twodigits(day(rGrupa("beigu_dat"))))+"."+cstr(twodigits(month(rGrupa("beigu_dat"))))+".</td>"
    end if
    '-----------------------------------------------
    if request.form("vardadienas") = "yes" then
		response.write "<td>"
		vardi = Split(NullPrint(rec("vards")))

		Where = ""
		For iv = lbound(vardi) To ubound(vardi)
			If vardi(iv) <> "" Then
				If where<>"" Then 
					Where = Where + " OR "
				Else
					Where = "("
				End If
				Where = Where + "upper(vards) like upper(N'%,"+vardi(iv)+",%')"
			End if
			
		Next 
		If Where <> "" Then 
			Where = Where + ")"
		Else
			Where = "1=0"
		End if

		Set rvd = conn.execute("select * from vardadienas where " + where)
		If Not rvd.eof Then
			while not rvd.eof
				For d = rGrupa("sakuma_dat") To rGrupa("beigu_dat")
					If day(d) = rvd("datums") And month(d) = rvd("menesis") then
						response.write CStr(rvd("datums"))+"/"+CStr(rvd("menesis"))
					End if
					'response.write CStr(rvd("datums"))+"/"+CStr(rvd("menesis"))
				next
				rvd.movenext
			wend
		Else
			%>nav kalendârâ<%
		End if
		response.write "</td>"
    end if
    '-----------------------------------------------
    if request.form("dzimsanas_diena") = "yes" then
		response.write "<td>"
		

		For d = rGrupa("sakuma_dat") To rGrupa("beigu_dat")
			if not IsNull(rec("dzimsanas_datums")) then
				If day(d) = day(rec("dzimsanas_datums")) And month(d) = month(rec("dzimsanas_datums")) then
					response.write CStr(day(d))+"/"+CStr(month(d))
				End if
			end if
		next
		response.write "</td>"
    end if
    '-----------------------------------------------
    if request.form("zidainis") = "yes" then
		response.write "<td>"
		If zid<>0 Then
			Set rzid = conn.execute("select * from dalibn where id = "+CStr(zid))
			If Not rzid.eof then
				Response.write nullprint(rzid("vards")) + " " + nullprint(rzid("uzvards")) + " "+nullprint(rzid("pk1"))+"-"+nullprint(rzid("pk2"))
			End if
		End if
		response.write "</td>"
    end if
    '----------------------------------------------- 29180541

    response.write "</tr>"
    i = i + 1
    
   next 'next isk
   
  end if 'bez atlikuma  

  end if

 
  
  lastpid = pid
  lastdid = did

  '------
  'RT 13.02.2019 aizkomentçju ðo, savâdâk daþas atskaites lîdz galam neizdrukâjâs
  'Response.Flush '--- noversh response.buffer limit exceeded. suuta datus uz browseri cikla beigaas
  '------ pieveinots 22.feb.2010
  
 rec.movenext 
wend

'--- kopsummas ------------------------------------------------------------------------------------------------


if request.form("kopsumma") = "yes" then
	colspan = 1 'for Nr column and dalibn nr.
	if request.form("uzvards") = "yes" then colspan = colspan + 1
	if request.form("vards") = "yes" then colspan = colspan + 1
	if request.form("papildvieta") = "yes" then colspan = colspan + 1
	if request.form("pk") = "yes" then colspan = colspan + 2
	if request.form("dzimsanas_datums") = "yes" then colspan = colspan + 1
	if request.form("pase") = "yes" then colspan = colspan + 2
	if request.form("pase_der") = "yes" then colspan = colspan + 1
	if request.form("id_karte") = "yes" then colspan = colspan + 3
	if request.form("datums") = "yes" then colspan = colspan + 1
	if request.form("talrunism") = "yes" then colspan = colspan + 1
	if request.form("talrunisd") = "yes" then colspan = colspan + 1
	if request.form("talrunisMob") = "yes" then colspan = colspan + 1
	if request.form("epasts") = "yes" then colspan = colspan + 1
	if request.form("cena") = "yes" then colspan = colspan + 1
	if request.form("atlaides") = "yes" then colspan = colspan + 1

	Response.Write "<tr><td colspan="+cstr(colspan)+" align=left><b>Summa kopâ: </b></td>"

	if request.form("jamaksa") = "yes" then
		Response.Write "<td><b>"+Curr3Print2(total_jamaksaLVL,total_jamaksaUSD,total_jamaksaEUR)+"</b></td>"
	end if

	if request.form("iemaksas") = "yes" then
		Response.Write "<td><b>"+Curr3Print2(total_iemaksasLVL,total_iemaksasUSD,total_iemaksasEUR)+"</b></td>"
	end if
	if request.form("summa") = "yes" then
		Response.Write "<td><b>"+Curr3Print2(total_summaLVL,total_summaUSD,total_summaEUR)+"</b></td>"
	end if
	if request.form("bilance") = "yes" then
		Response.Write "<td><b>"+Curr3Print2(total_bilanceLVL,total_bilanceUSD,total_bilanceEUR)+"</b></td>"
	end if
	if request.form("neapstiprinatas") = "yes" then
			if (Curr3value(total_neapstLVL,total_neapstUSD,total_neapstEUR)>0) then
				font_color = "red"      		
			else
				font_color = "black"  
			end if
		Response.Write "<td><b><font color='"+font_color+"'>"+Curr3Print2(total_neapstLVL,total_neapstUSD,total_neapstEUR)+"</font></b></td>"
	end if
end if


response.write "</tr>"

'--- END kopsummas -----------------------------------------------------------------------------------------

%>
</table>
<% else %>
<font color = "BLACK" size = "5"><BR><BR>Grupâ dalîbnieki nav pieteikuðies</font>
<% end if %>


</BODY>
</HTML>
<%
function KajVeidaNos_local(veids_p)
 if session("kajveidanos"+cstr(veids_p))<>"" then
  KajVeidaNos_local = session("kajveidanos"+cstr(veids_p))
  exit function
 end if
 set rl = conn.execute("select nosaukums from kajites_veidi where id = "+cstr(veids_p))
 if not rl.eof then
  KajVeidaNos_local = rl("nosaukums")
  session("kajveidanos"+cstr(veids_p)) = rl("nosaukums")
 end if
end function

function PrintTalr(kods,talr)
	PrintTalr = ""
	if nullprint(talr) <> "" then 
		if nullprint(kods) <> "" then	
			PrintTalr = "+"+nullprint(kods)
		end if
		PrintTalr = PrintTalr + nullprint(talr)
	end if
end function



%>