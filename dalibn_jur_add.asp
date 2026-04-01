<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
OpenConn

dfields = "vards uzvards pases pasenr pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD talrunisMob eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons"
dtypes = "text text text text text text text text text text text text text text text text text text text text num"
dforms = "vards uzvards pases pasenr pk1 pk2 "+ _
	"adrese pilseta indekss talrunisM talrunisD talrunisMob eadr nosaukums reg nmkods vaditajs kontaktieris piezimes dzimta rajons"


if request.form("subm") = "add" then
  NewRecord conn,"select * from dalibn",dfields,dforms

  session("dmessage") = "Jauns dalîbnieks pievienots veiksmîgi!"
  id = session("newid")
  loginsertaction "dalibn",id
  response.redirect "dalibn_jur.asp?i=" + cstr(id) 
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
      query = query + " and (pk1 = '"+request.form("pk1")+"' or isnull(pk1)) "
    end if
    if request.form("pk2") <> "" then
      query = query + " and (pk2 = '"+request.form("pk2")+"' or isnull(pk2)) "
    end if
    skaits = QRecordCount(query)
    '-- Ja tâda vel nav tad pievieno jaunu
    if skaits = 0 or request.form("nosaukums")<> "" then

      NewRecord conn,"select * from dalibn",dfields,dforms
      message = "Jauns dalîbnieks pievienots veiksmîgi!"
      id = session("newid")

'Arturs

jur_grupas_id = request.form(nextword("jur_grupas_id"))
%><%=jur_grupas_id%><%
response.end
while jur_grupas_id<>""
	EXEC_STRINGS="insert into dalibn_jur_grupas (jur_grupas_id,dalibn_id) VALUES ("&jur_grupas_id&","&ID&")"
%><%=EXEC_STRINGS%><%
	jur_grupas_id = request.form(nextword("jur_grupas_id"))
wend
response.end
	set r = Conn.Execute(EXEC_STRINGS)

	

      response.redirect "dalibn_jur.asp?i=" + cstr(id)
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
      url = "dalibn_jur.asp?i="
      dim headings(10)
      headings(0) = "<center><b>Vards"
      headings(1) = "<center><b>Uzvards"
      headings(2) = "<center><b>Nosaukums"
      headings(3) = "<center><b>Pers.k."
      headings(4) = "<center><b>Pilsçta"
      headings(5) = "<center><b>Adrese"
      QueryToLinkTable query,6,url,headings 
      %><form action="dalibn_jur_add.asp" method = POST>
        <%=fstring%>
        <input type=submit value="Pievienot jaunu dalibnieku: <%=dalibn_desc%>">
        <input type=hidden name=subm value="add">
      </form><%
    end if
  else
    docstart "Paziòojums","y1.jpg"
    headlinks
    response.write "<center><hr><font size = 5>Jâievada vârds un uzvârds vai arî nosaukums.</font><hr>"
  end if
end if
%>
