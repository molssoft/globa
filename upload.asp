<center>
Faila pievienoðana<br>
<form name=forma enctype="multipart/form-data" method=post action="upload2.asp">
 <input type=file name=fails>
 Faila nosaukums:<input type=text name=nosaukums><br>
 <input type=submit name=poga value="Ielâdçt bildi">
 <input type=hidden name=var value=<%=request.querystring("var")%>>
 <input type=hidden name=prefix value=<%=request.querystring("prefix")%>>
</form>
