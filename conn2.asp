<%

'@ 0 OpenConn
sub OpenConn ()

	''if session("user_name")="" then 
''		response.redirect "login.asp"
''	end if

	set conn = server.createobject("ADODB.Connection")

	cst = "Provider=SQLOLEDB;" & _
	      "Data Source=ser-db3\MSSQL2008;" & _ 
	      "Initial Catalog=globa;" & _ 
	      "Network=DBMSSOCN;" & _ 
	      "User Id=globa;" & _ 
	      "Password=K$fRT+zFn}QLv2vW;"

	conn.open "DSN=globa;" & _
	      "User Id=globa;" & _ 
	      "Password=K$fRT+zFn}QLv2vW;"

	''conn.open cst

	if mid(get_user(),1,2) = "tt" or mid(get_user(),1,4) = "tic_" then
	 conn.close
	 response.redirect "http://www.impro.lv/rezervacija/"
	end if
	CheckGlobaAccess

end sub

function OpenGlobaConn ()
	cst = "Provider=SQLOLEDB;" & _
	      "Data Source=ser-db3\MSSQL2008;" & _ 
	      "Initial Catalog=globa;" & _ 
	      "Network=DBMSSOCN;" & _ 
	      "User Id=globa;" & _ 
	      "Password=K$fRT+zFn}QLv2vW;"
	 
	set conn = CreateObject("ADODB.Connection") 
	conn.open cst
end function

%>