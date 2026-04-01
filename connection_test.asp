<%
Dim startTime
startTime = Timer

	set conn = server.createobject("ADODB.Connection")
	dim cc
	cc = 100

	response.write "Opening connection and executing simple select " + cstr(cc) + " times<BR><BR>"

	for i = 1 to cc
		conn.open "DSN=globa;" & _
	      "User Id=globa;" & _ 
	      "Password=K$fRT+zFn}QLv2vW;"
		  
		 set r = conn.execute("select top 1 * from dalibn")
		  
		conn.close
	next
	response.write "Finished<BR>"
	
	
	' End timing
Dim endTime
endTime = Timer

' Calculate and display the duration
Dim duration
duration = endTime - startTime
Response.Write("Execution time: " & duration & " seconds")
%>