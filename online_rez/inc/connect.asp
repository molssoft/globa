<% 
Class cls_db

	Public Conn

	private sub Class_Initialize()
		'response.write("CON DB !")
		connect()
	end sub 

	private sub Class_Terminate()
		'response.write("DC DB !")
		disconnect()
	end sub 

	Public Sub connect
		Set Conn=server.createobject("ADODB.connection") 

			'response.write("			Provider=SQLOLEDB;DRIVER={"&Application("db_driver")&"};UID="&Application("db_user")&";pwd="&Application("db_pass")&";Network Library=DBMSSOCN;server=192.168.1.101;")

			conn.open "Provider=MSDASQL;DSN=globa"
			'Conn.Open "			Provider=SQLOLEDB;DRIVER={"&Application("db_driver")&"};UID="&Application("db_user")&";pwd="&Application("db_pass")&";Network Library=DBMSSOCN;server="&Application("db_server")&";"
			
			'Conn.DefaultDatabase = Application("db_database")
	End Sub

	Public Sub disconnect
			Conn.Close
			set conn = Nothing
	End Sub

	Public Sub insert_step_02()
			Conn.Close
			set conn = Nothing
	End Sub

End Class
%>