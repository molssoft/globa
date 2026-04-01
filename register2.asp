<!-- #include file = "dbprocs.inc" -->
<!-- #include file = "procs.inc" -->

<%
dim conn
OpenConn

email = Request.Form("email")
password = request("password")
password2 = request("password2")

if CheckEmail(email) = FALSE then
 message = "E-pasta adrese ir kïûdaina. Nospiediet BACK, lai izlabotu."
end if

if message = "" then
 if password = "" then
  message = "Parole nevar bût tukða. Nospiediet BACK, lai izlabotu."
 end if
end if

if message = "" then
 if password <> password2 then
  message = "Paroles pârbaude nesakrît ar paroli. Nospiediet BACK, lai izlabotu."
 end if
end if

if message = "" then
 'pârbauda vai tâda adrese jau nav ievadîta
 set r = conn.execute ("select * from email_list where LOWER(email)='"+lcase(email)+"'")
 if not r.eof then
  message = "Ðâda adrese jau ir reìistrçta."
 end if
end if

if message = "" then
 randomize(minute(now)+second(now)+hour(now))
 kods = round(rnd(0)*10000)
 conn.execute "insert into email_list (email,datums_izv,status,parole,kods) VALUES ('"+email+"','"+sqldate(now)+"','N','"+password+"',"+cstr(kods)+")"
 Response.Redirect "confirm_add.php?email="+email
end if

response.write message
%>

