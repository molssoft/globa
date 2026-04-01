<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->
<%
dim conn
openconn
%>
<html>
<%kods = Request.querystring("kods")
set rKods = conn.execute("select Num from [SER-1\SQL14].s20"+mid(kods,1,2)+".dbo.resursi where Num like '"+kods+".%' order by num asc")
'set rKods = conn.execute("select Num from g20"+mid(kods,1,2)+".dbo.resursi where Num like '"+kods+".%' order by num asc")
while not rKods.eof
  tempkods = rKods("num")
  rKods.movenext
wend
  'Response.Write("'"+cstr(kods1)+cstr(reg)+cstr(val)+cstr(mar)+cstr(monthv)+"%'")
  'Response.Write(cstr(year(Formateddate(beigu_dat,"dmy"))))
  If tempkods = "" then 
    tempkods = kods+".1"
  else
    If mid(tempkods, len(tempkods), 1)="9" then
      tempkods = mid(tempkods,1,len(tempkods)-1)+"A"
    elseif mid(tempkods, len(tempkods), 1)="H" then	'izlaižam I burtu
      tempkods = mid(tempkods,1,len(tempkods)-1)+"J"
    elseif mid(tempkods, len(tempkods), 1)="N" then	'izlaižam O burtu
      tempkods = mid(tempkods,1,len(tempkods)-1)+"P"
    elseif mid(tempkods, len(tempkods), 1)="Z" then
	  tempkods = tempkods + "1"
    else
		nextchar = cstr(chr(asc(mid(tempkods, len(tempkods), 1))+1))
		if nextchar = "I" or nextchar = "G" then
			nextchar = cstr(chr(asc(mid(tempkods, len(tempkods), 1))+2))
		end if
		tempkods = mid(tempkods,1,len(tempkods)-1)+nextchar
    end if
  end if 
  Response.Write tempkods
%>
<body onload="opener.forma.kods.value='<%=tempkods%>';window.close()">
</body>
</html>
