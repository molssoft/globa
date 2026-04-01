<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

title = request.form("title"+cstr(id))
katalogs = SQLBit(Request.Form("katalogs"+cstr(id)))
aktivs = SQLBit(Request.Form("aktivs"+cstr(id)))
aktivs_laiks = SQLBit(Request.Form("aktivs_laiks"+cstr(id)))
tips = SQLBit(Request.Form("tips"+cstr(id)))
virsraksts = SQLBit(Request.Form("virsraksts"+cstr(id)))
mazs_virsraksts = SQLBit(Request.Form("mazs_virsraksts"+cstr(id)))
datums = SQLBit(Request.Form("datums"+cstr(id)))
jaunums = SQLBit(Request.Form("jaunums"+cstr(id)))
banneris = SQLBit(Request.Form("banneris"+cstr(id)))
liela_bilde = SQLBit(Request.Form("liela_bilde"+cstr(id)))
raksta_bilde = SQLBit(Request.Form("raksta_bilde"+cstr(id)))
ievads = SQLBit(Request.Form("ievads"+cstr(id)))
teksts = SQLBit(Request.Form("teksts"+cstr(id)))
url = SQLBit(Request.Form("url"+cstr(id)))
saistitie_raksti = SQLBit(Request.Form("saistitie_raksti"+cstr(id)))
efekts = SQLBit(Request.Form("efekts"+cstr(id)))
carters = SQLBit(Request.Form("carters"+cstr(id)))
grupas = SQLBit(Request.Form("grupas"+cstr(id)))
marsruti = SQLBit(Request.Form("marsruti"+cstr(id)))
cena = SQLBit(Request.Form("cena"+cstr(id)))
icon = SQLText(Request.Form("icon"+cstr(id)))

conn.execute("update types set title = '"+SQLText(title)+"', " + _
 " bit_katalogs = "+katalogs + "," + _ 
 " bit_aktivs = "+aktivs + "," + _ 
 " bit_aktivs_laiks = "+aktivs_laiks + "," + _ 
 " bit_tips = "+tips + "," + _ 
 " bit_virsraksts = "+virsraksts + "," + _ 
 " bit_mazs_virsraksts = "+mazs_virsraksts + "," + _ 
 " bit_datums = "+datums + "," + _ 
 " bit_jaunums = "+jaunums + "," + _ 
 " bit_banneris = "+banneris + "," + _ 
 " bit_liela_bilde = "+liela_bilde + "," + _ 
 " bit_raksta_bilde = "+raksta_bilde + "," + _ 
 " bit_ievads = "+ievads + "," + _ 
 " bit_teksts = "+teksts + "," + _ 
 " bit_url = "+url + "," + _ 
 " bit_saistitie_raksti = "+saistitie_raksti + "," + _ 
 " bit_efekts = "+efekts + "," + _ 
 " bit_carters = "+carters + "," + _ 
 " bit_grupas = "+grupas + "," + _ 
 " bit_marsruti = "+marsruti + "," + _ 
 " bit_cena = "+cena + "," + _ 
 " icon = '"+icon + "'" + _ 
 " where id = '"+cstr(id))+"'"

response.redirect "types.asp"
%>
