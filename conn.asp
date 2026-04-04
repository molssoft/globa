<%
public Const MAIL_SERVER = "192.168.1.166"
public Const GLOBA_CONN_STR = "DSN=globa" 

sub OpenConn ()
set conn = server.createobject("ADODB.Connection")
conn.open "DSN=portal","www","www"
end sub

sub OpenGlobaConn ()
set globaconn = server.createobject("ADODB.Connection")
globaconn.open "DSN=glo","www","www"
end sub


%>
