<% @ LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<!-- redirektee ordera logu uz pieteikuma formu -->
<script language="javascript">window.opener.history.go(-1);</script>

<%

dim valkurs
dim conn
openconn

error = 0
vajag_paroli = ""
validation = 1

If request.querystring("balles_biletes") <> "" Then
	conn.execute("update pieteikums set balle_datums = '"+SQLDate(request.form("datums"))+"' where id = " + Request.querystring("pid"))

End if

if Request.Form("tips") = "iemaksa" then
	if  validation =1 and dateprint(date) <> Request.Form("datums") then 
		validation = 0
		if IsAccess(T_VEC_ORD_REG) then validation = 1
		if validation = 0 then vajag_paroli = "Lai reìistrçtu iemaksu ar datumu, kas nav ðodienas datums, vajadzîgas lielâkas tiesîbas."
	end if
	if validation = 1 and MID(Request.Form("debets"),1,5) <> "2.6.1" and MID(Request.Form("debets"),1,7) <> "2.6.2.5" and MID(Request.Form("debets"),1,5) <> "5.3.6" and MID(Request.Form("debets"),1,7) <> "2.6.2.5" then 
		validation = 0
		'atïauj bankas kontus
		if IsAccess(T_NESTAND_ORD) then validation = 1
		if validation = 0 then vajag_paroli = "Lai reìistrçtu iemaksu uz kontu, kas nav kases konts vajadzîgas lielâkas tiesîbas."
	end if
end if
if Request.Form("tips") = "izmaksa" then
	if  validation =1 and dateprint(date) <> Request.Form("datums") then 
		validation = 0
		if IsAccess(T_VEC_ORD_REG) then validation = 1
		if validation = 0 then vajag_paroli = "Lai reìistrçtu izmaksu ar datumu, kas nav ðodienas datums, vajadzîgas lielâkas tiesîbas."
	end if
	if validation = 1 and MID(Request.Form("kredits"),1,5) <> "2.6.1" and MID(Request.Form("kredits"),1,7) <> "2.6.2.5" and MID(Request.Form("kredits"),1,5) <> "5.3.6"  and MID(Request.Form("kredits"),1,7) <> "2.6.2.5" then 
		validation = 0
		'atïauj bankas kontus
		'if ucase(get_user) = "ELITA" and (mid(request.form("debets"),1,4)="2624" or mid(request.form("kredits"),1,4)="2624") then validation = 1
		if IsAccess(T_NESTAND_ORD) then validation = 1
		if validation = 0 then vajag_paroli = "Lai reìistrçtu iemaksu uz kontu, kas nav kases konts vajadzîgas lielâkas tiesîbas."
	end if
end if
if Request.Form("tips") = "parskaitijums" then
	validation = 0
	vajag_paroli = "Lai izdarîtu pârskaitîjumu vajadzîga parole."
	if IsAccess(T_PARSK_REG) then validation = 1
end if

if validation = 0 then
	set r = conn.Execute ("SELECT parole from parole WHERE kada = 'piet_datums'")
	if Request.Form("parole") <> r("parole") then 
		message = "Autorizâcijas kïûda."
		error = 1
	end if
end if

if error = 1 then
	docstart "Kïûda","y1.jpg"
	if vajag_paroli <> "" then Response.Write "<center><font color = red size = 5>" + vajag_paroli + "<br>"
	Response.Write "<center><font color = red size = 5>" + message + "<br>" + "Nospieþiet BACK lai izlabotu kïûdu.<br>"
else

	set valkurs = server.createobject("ADODB.Recordset")
	if session("editedcurrency") <> 1 then
		session("item") = "orderis"
		session("did") = request.form("did")
		session("datums") = request.form("datums")
		session("kas") = request.form("kas")
		session("pamatojums") = request.form("pamatojums")
		session("pielikums") = request.form("pielikums")
		session("kredits") = request.form("kredits")
		session("debets") = request.form("debets")
		session("summa") = request.form("summa")
		session("valuta") = request.form("valuta")
		session("NoPid") = request.form("NoPid")
		session("UzPid") = request.form("UzPid")
		session("parsk") = request.form("parsk")
		session("num") = request.form("num")
		session("zils") = request.form("zils")
		session("tips") = Request.Form("tips")
		session("parvalutu") = Request.Form("parvalutu")
		session("dala_no") = CheckBox(Request.Form("dala_no"))
		session("dala_uz") = CheckBox(Request.Form("dala_uz"))
		session("rekins") = Request.Form("rekins")
		session("rekins_gads") = Request.Form("rekins_gads")
		session("rekins_pazime") = Request.Form("rekins_pazime")
		session("resurss") = Request.Form("resurss")
		session("resurss_uz") = Request.Form("resurss_uz")
		'sheit vareetu pievienot, lai atlaide arii tiktu paarnesta
	else
		session("editedcurrency") = 0
	end if


'Response.write "->"&request.form("registret")&"<br>"
'Response.end
	if request.form("a") = "registret" or request.form("registret")="" then session("poga") = "Reìistrçt"

	valkurs.open "select * from valutakurss where valuta = "+session("valuta")+" and datums = '" + sqldate(session("datums"))+"'",conn,3,3
	if valkurs.recordcount = 0 and session("valuta") <> 49 then
		session("message") = "Ðajâ datumâ valûtas kurss nav uzdots. Lûdzu pievienojiet to."
		session("valutaord") = 1
		response.redirect ("valuta.asp")
	Else
	
		if session("tips") = "parskaitijums" then response.redirect("drukord.asp"+qstring())
		if session("tips") = "izmaksa" then response.redirect("drukord_izm_test.asp"+qstring())
		if session("tips") = "iemaksa" then response.redirect("drukord.asp"+qstring())
		if session("izm") <> 1 then response.redirect("drukord_test.asp"+qstring())
		response.redirect("drukord_izm.asp"+qstring())	
	end if
end if

%>




