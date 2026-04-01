<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
OpenConn

dfields = "vards uzvards pases pasenr pasederdat pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD talrunisMob fax eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons novads ids idnr idderdat dzimsanas_datums"
dtypes = "text text text text text text text text text text text text text text text text text text text text text text num num text text text text"
dforms = "vards uzvards pases pasenr pasederdat pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD talrunisMob fax eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons novads id_s id_nr id_derdat dzimsanas_datums"

'Response.Write request.form("subm")

if request.form("subm") = "add" then
  NewRecord conn,"select * from dalibn where id = 1885",dfields,dforms
  session("dmessage") = "Jauns dalîbnieks pievienots veiksmîgi!"
  id = session("newid")
  
  conn.execute ("update dalibn " + _
	" set dzimsanas_datums = dbo.fn_pk1_datums(pk1) " + _
	" where  " + _
	" id = " + cstr(id) + _
	" and dzimsanas_datums is null " + _
	" and pk1 <> '' " + _
	" and vards <> 'X' " + _
	" AND dbo.fn_pk1_datums(pk1) IS NOT NULL ")
  
  '' update personcode here
  
  loginsertaction "dalibn",id
  response.redirect "dalibn.asp?i=" + cstr(id) 
'--- Kad nâk no dalîbnieka formas ---------------------------
elseif request.form("saglabatjaunu.x") <> "" then
  '-- Jâbût norâdîtam vainu vârdam un uzvârdam vai nosaukumam
  if (request.form("vards")<>"" and request.form("uzvards")<>"") or (request.form("nosaukums") <> "") then
    '-- pirms saglabâðanas pârliecinâs vai tâds cilvçks jau ir vai nav
    '-- veido kvçriju
    query = "Select vards, uzvards, nosaukums, pk1+'-'+pk2, pilseta, adrese, id , piezimes from dalibn where (not deleted = 1) "
    if request.form("vards") <> "" then
      query = query + " and vards like '"+request.form("vards")+"%' "
    end if
    if request.form("uzvards") <> "" then
      query = query + " and uzvards like '"+request.form("uzvards")+"%' "
    end if
    if request.form("pk1") <> "" then
      query = query + " and (pk1 = '"+request.form("pk1")+"' or (pk1 is null)) "
    end if
    if request.form("pk2") <> "" then
      query = query + " and (pk2 = '"+request.form("pk2")+"' or (pk2 is null)) "
    end if
	if request.form("pk1") <> "" and request.form("pk2") <> "" then
	 query = query + " or (pk1 = '"+request.form("pk1")+"' AND pk2 = '"+request.form("pk2")+"') "		
	end if
    skaits = QRecordCount(query)
    '-- Ja tâda vel nav tad pievieno jaunu
    if skaits = 0 or request.form("nosaukums")<> "" then
	
      '--pârbauda, vai pases termiòð nav lielâks par  +10 gadiem no ðî brîþa
	  if request.form("pasederdat")<> "" then
	  rw request.form("pasederdat")
	  rw cstr(now)
		if (CDate(request.form("pasederdat")) > DateAdd("yyyy",10,Now())) then
	
			docstart "Paziòojums","y1.jpg"
			headlinks
			response.write "<center><hr><font size = 5>No 20.11.2017. ceïojumiem ârpus Latvijas <b>neder pases ar derîguma termiòu uz 50 gadiem</b> (izsniedza lîdz 19.11.2007.)<b> un pases ar ielîmçtu fotokartîti </b>(izsniedza lîdz 30.06.2002.).</font><hr>"
			response.end		
		end if		
	  end if
	  
      NewRecord conn,"select * from dalibn where id = 1885",dfields,dforms
      id = session("newid")


	  conn.execute ("update dalibn " + _
		" set dzimsanas_datums = dbo.fn_pk1_datums(pk1) " + _
		" where  " + _
		" id = " + cstr(id) + _
		" and dzimsanas_datums is null " + _
		" and pk1 <> '' " + _
		" and vards <> 'X' " + _
		" AND dbo.fn_pk1_datums(pk1) IS NOT NULL ")

	  loginsertaction "dalibn",id
      session("dmessage") = message + "Jauns dalîbnieks pievienots veiksmîgi!"
      response.redirect "dalibn.asp?i=" + cstr(id)
    '-- Ja datubâzç ir kâds ar tâdu paðu vârdu un personas kodu
    else
      session("dfields") = dfields
      session("dforms") = dforms
      dalibn_desc = request.form("vards") + " " + request.form("uzvards") + " " + request.form("pk1") + "-" + request.form("pk2")
      Set result = conn.execute(query)
      '-- paziòojums par lîdzîgo dalîbnieku skaitu
      if skaits-int(skaits/10)*10 = 1 then
        Title = "Datubâzç jau eksistç "+CStr(skaits)+" lîdzîgs dalîbnieks"
      else
        Title = "Datubâzç jau eksistç "+CStr(skaits)+" lîdzîgi dalîbnieki"
      end if
      '-- Teksta izdrukas sâkums
      docstart "Dalibnieku saraksts","y1.jpg"
      %><center><font color="GREEN" size="5"><b><%=Title%></b></font><hr><%
      headlinks%><br><%
      url = "dalibn.asp?i="
      dim headings(10)
      headings(0) = "<center><b>Vards"
      headings(1) = "<center><b>Uzvards"
      headings(2) = "<center><b>Nosaukums"
      headings(3) = "<center><b>Pers.k."
      headings(4) = "<center><b>Pilsçta"
      headings(5) = "<center><b>Adrese"
      QueryToLinkTable query,6,url,headings 
      %>
      <form action="dalibn_add.asp" method = POST>
        <%=fstring%>
        <input type=submit value="Pievienot jaunu dalîbnieku: <%=dalibn_desc%>">
        <input type=hidden name=subm value="add">
      </form>
      <%
    end if
  else
    docstart "Paziòojums","y1.jpg"
    headlinks
    response.write "<center><hr><font size = 5>Jâievada vârds un uzvârds vai arî nosaukums.</font><hr>"
  end if
end if
%>