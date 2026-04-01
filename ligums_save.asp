<%
set fso = new ActiveXObject("Scripting.FileSystemObject");
set a = fso.CreateTextFile("c:\\testfile.txt", true);
a.WriteLine("This is a test.");
a.Close();
%>