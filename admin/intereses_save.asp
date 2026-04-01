<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->
<%
dim conn
openconn

id = request.form("id")

nosaukums = request.form("nosaukums"+cstr(id))

aktivs = Request.Form("aktivs"+cstr(id))
if aktivs = "on" then
 aktivs = "1" 
else
 aktivs = "0"
end if

conn.execute("update temas set nosaukums = '"+SQLText(nosaukums)+"',aktivs = "+aktivs+" where id = '"+cstr(id))+"'"

response.redirect "intereses.asp"
%>
