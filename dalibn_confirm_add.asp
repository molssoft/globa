<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn

id = Request.QueryString("id")
set r = conn.execute("select * from email_list where did = "+cstr(id))
if not r.eof then
 set msg = Server.CreateOBject( "JMail.Message" )
 msg.From = "e-jaunumi@impro.lv"
 msg.FromName = "IMPRO"
 msg.AddRecipient r("email"), r("email")
 msg.Subject = "Apstipriniet parakstisanos uz IMPRO zinam."
 msg.Body = "Lai apstiprinatu parakstisanos uz IMPRO zinam noklikskiniet uz so saiti: http://www.impro.lv/confirm_add.asp?id="+cstr(r("id"))+"&kods="+cstr(r("kods"))
 if msg.Send( "192.168.1.167" ) then
  response.write "OK"
 else
  Response.Write "BAD"
 end if
 Response.Redirect "dalibn.asp?i="+cstr(id)
end if

%>