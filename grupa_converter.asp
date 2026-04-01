<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
submit = Request.Form("submit")
%>
<html><body>

<form name=forma method=POST>
<%
if submit = "1" then
set rTemp = conn.execute ("select kods, beigu_dat, id from grupa where kods like '______'")
i=0
while not rTemp.eof
  kods = rTemp("kods")
  dat = rTemp("beigu_dat")
  id = rTemp("id")
  If (mid(kods,1,1)>="A" and mid(kods,1,1)<="Z") or (mid(kods,1,1)>="a" and mid(kods,1,1)<="z") then
    kods_new = cstr(twodigits((year(dat) mod 100)))+"."+mid(kods,1,1)+"."+mid(kods,2,1)+"."+mid(kods,3,1)+"."+mid(kods,4,1)+"."+mid(kods,5,1)+"."+mid(kods,6,1)
    conn.execute ("UPDATE grupa SET kods = '"+kods_new+"' where ID='"+cstr(id)+"'")
  end if
  rTemp.movenext
  i = i+1
wend

%>

<center><font size = 5>
Kodi konvertçti veiksmîgi
</center></font>

<% else %>

<center><font size = 5>
Lai konvertçtu visus kodus grupu tabulâ no formas X11111 uz formu YY.X.1.1.1.1.1 nospiediet turpinat<br>
<input type=submit name=poga value=Turpinat>
<input type=hidden name=submit value=1>
<input type=button value=Atcelt onclick="history.back()">
</center></font>
<% end if %>
</form>
</body>
</html>
