<% 
Class cls_db

	Public Conn

	private sub Class_Initialize()
		connect()
	end sub 

	private sub Class_Terminate()
		disconnect()
	end sub 

	Public Sub connect

		Set Conn=server.createobject("ADODB.connection") 

		If session("site") = "online" then
			Conn.Open "Provider=SQLOLEDB;DRIVER={"&Application("db_driver")&"};UID="&Application("db_user")&";pwd="&Application("db_pass")&";Network Library=DBMSSOCN;server="&Application("db_server")&";SqlCollation=Latvian_CI_AS;"
		
			Conn.DefaultDatabase = Application("db_database")
		End If
		
		If session("site") = "globa" Or session("site") = "agenti" Then
			conn.open "Provider=MSDASQL;DSN=globa"

			if mid(get_user(),1,2) = "tt" or mid(get_user(),1,4) = "tic_" then
			 conn.close
			 response.redirect "http://www.impro.lv/rezervacija/"
			end if
		End if

	End Sub

	Public Sub disconnect
		Conn.Close
		set conn = Nothing
	End Sub

	Public Sub insert_step_02()
		Conn.Close
		set conn = Nothing
	End Sub

	function Get_User()
		Get_User = request.ServerVariables("LOGON_USER")
		for i = 1 to len(Get_User)
			if mid(Get_User,i,1) = "\" then
				Get_User = mid(Get_User,i+1,len(Get_User)-i)
				exit function
			end if
		next
		if get_user = "" then get_user = "unknown"
	end function


End Class
%>