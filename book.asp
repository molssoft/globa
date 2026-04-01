<%
'Atver grâmatvedîbas datubâzi
sub OpenBookConn ()
set BookConn = server.createobject("ADODB.Connection")
BookConn.open "DSN=gramatvediba;database=g"+cstr(year(now))
end sub

Function NewBookOrder (oid)
'Dabon orderi pçc id
set rGlob = conn.execute ("SELECT * FROM ORDERIS WHERE ID = "+cstr(oid))
'Pârbauda kas tur ir atgriezies
if rGlob.eof then exit function

pamatojums = encode(nullprint(rglob("pamatojums")))
kas = encode(nullprint(rglob("kas")))
pielikums = encode(nullprint(rglob("pielikums")))

'parsledzas uz citu baazi ja vajag
if year(rGlob("datums"))<>year(now) then
 bookconn.close
 bookconn.open "DSN=gramatvediba;database=g"+cstr(year(rGlob("datums")))
end if

'-- Nosaka ordera veidu
veids = "ps"
if nullprint(rGlob("debets")) = nullprint(rGlob("kredits")) then exit function
'--- vai ienemumu orderis
if len(nullprint(rGlob("debets"))) > 3 then
 if mid(rGlob("debets"),1,3) = "261" then veids = "io"
end if
'--- vai izdevumu orderis
if len(nullprint(rGlob("kredits"))) > 3 then
 if mid(rGlob("kredits"),1,3) = "261" then veids = "oo"
end if

dim BookConn
'Atkarîbâ vai tas ir ieòçmumu vai izdevumu orderis pievieno ierakstu orderu tabulai
'un dokumentu tabulai, izveido transakciju
if veids = "io" then
	'Nosaka pçdçjâ ordera nummuru
	set BookConn = server.createobject("ADODB.Connection")
	BookConn.open "DSN=gramatvediba;database=g"+cstr(year(now))
	Set rNum = BookConn.Execute ("SELECT MAX(NUM) as n from Orders where type = 'io' and debets='"+ConvertAccount(rGlob("debets"),oid,"d")+"'")
	num = getnum(rNum("N"))+1
	rNum.close
	'Insertç ierakstu orderu tabulâ (ieòçmumu ord)
	conn.execute "INSERT INTO Orders " + _
		"(num,datums,kas,pamatojums,pielikums,summaval,debets,val,type,goid) VALUES "+ _ 
		"("+cstr(num)+",'" + _
		cstr(rGlob("datums"))+"','" + _
		kas+"','"+ _
		pamatojums+"','"+ _
		pielikums+"',"+ _
		cstr(rGlob("summaval"))+",'"+ _
		ConvertAccount(rGlob("debets"),oid,"d")+ "','"+ _
		"XXX',"+ _
		"'io',"+ _
		cstr(oid)+")"
	bookconn.close
end if
if veids = "oo" then
	'Nosaka pçdçjâ ordera nummuru
	Set rNum = BookConn.Execute ("SELECT MAX(NUM) as n FROM Orders where type = 'oo' and kredits = '"+ConvertAccount(rGlob("kredits"),oid,"k")+"'")
	num = getnum(rNum("N"))+1
	rNum.close
	'Insertç ierakstu orderu tabulâ (izdevumu ord)
	conn.close
	BookConn.Execute "INSERT INTO Orders " + _
		"(num,datums,kas,pamatojums,pielikums,summaval,kredits,val,type,goid) VALUES "+ _ 
		"("+cstr(num)+",'" + _
		cstr(rGlob("datums"))+"','" + _
		kas+"','"+ _
		pamatojums+"','"+ _
		pielikums+"',"+ _
		cstr(rGlob("summaval"))+",'"+ _
		ConvertAccount(rGlob("kredits"),oid,"k")+ "','"+ _
		"XXX',"+ _
		"'oo',"+ _
		cstr(oid)+")"
end if
exit function
conn.execute "update orderis set num = " +cstr(num) + " where id = " + cstr(oid)
NewBookOrder = num

bookconn.execute "Update Settings set valu ='1' where upper(variable) = 'CHECKACCOUNTS'"
end function


Function EditBookOrder (oid)
'Dabon orderi pçc id
set rGlob = conn.execute ("SELECT * FROM ORDERIS WHERE ID = "+cstr(oid))

'Pârbauda kas tur ir atgriezies
if rGlob.eof then exit function

'parsledzas uz citu baazi ja vajag
if year(rGlob("datums"))<>year(now) then
 bookconn.close
 bookconn.open "DSN=gramatvediba;UID=sa;database=g"+cstr(year(rGlob("datums")))
end if

veids = "ps"
if nullprint(rGlob("debets")) = nullprint(rGlob("kredits")) then exit function
'--- vai ienemumu orderis
if len(nullprint(rGlob("debets"))) > 3 then
 if mid(rGlob("kredits"),1,3) = "261" then veids = "io"
end if
'--- vai izdevumu orderis
if len(nullprint(rGlob("kredits"))) > 3 then
 if mid(rGlob("kredits"),1,3) = "261" then veids = "oo"
end if

'Nosaka ordera valûtu
set rVal = Conn.execute ("SELECT * FROM Valuta where id = " + cstr(rGlob("valuta")))
valuta = rVal("val")

'labo ierakstu orderu tabulâ
'un dokumentu tabulai, kâ arî izveido vienu transakciju
'Labo ierakstu orderu tabulâ
pamatojums = encode(nullprint(rglob("pamatojums")))
kas = encode(nullprint(rglob("kas")))
pielikums = encode(nullprint(rglob("pielikums")))
set r = bookconn.execute("select id from orders where goid = "+cstr(oid))
if veids = "io" or veids = "oo" then
 BookConn.Execute "UPDATE Orders SET " + _
	"datums = '" + cstr(rGlob("datums"))+"'," + _
	"kas = '" + kas+"',"+ _
	"pamatojums = '" + pamatojums+"',"+ _
	"pielikums = '" + pielikums+"',"+ _
	"summaval = " + cstr(rGlob("summaval"))+","+ _
	"debets = '" + ConvertAccount(rGlob("debets"),oid,"d")+ "',"+ _
	"kredits = '" + ConvertAccount(rGlob("kredits"),oid,"k")+ "',"+ _
	"val = '" + valuta+"', " + _
	"valuta = " + cstr(rGlob("valuta")) +" " + _
	"WHERE id = " + cstr(r("id")) 
end if

'Labo ierakstu dokumentu tabulâ
BookConn.Execute "UPDATE Operation SET " + _
	"date_edited = '" + sqldate(now) + "'," + _
	"currency = '" + valuta + "'," + _
	"amount = " + cstr(rGlob("summaval"))+",notes='"+pamatojums+"' " + _
	"WHERE goid = " + cstr(oid)

'Atrod ðo operâciju lai noteiktu id
set rOp = server.createobject("adodb.recordset")
rOp.open "select * FROM operation WHERE goid = " + cstr(oid),BookConn,3,3

'Izdzçð visas transakcijas ðim dokumentam
if rOp.eof then OpID = 0 else OpID = rOp("id")
BookConn.Execute "DELETE FROM Transakcijas WHERE operation = " + cstr(OpID)

'Insertç vienu transakciju ðim dokumentam
if OpID <> 0 then
 BookConn.Execute "INSERT INTO Transakcijas " + _
	"(operation,local_num,amount,balance_amount,debet,credit,notes,need_check) VALUES " + _
	"(" + cstr(OpID) + "," + _
	"1," + _
	cstr(rGlob("summaval")) + "," + _
	cstr(rGlob("summa")) + ",'" + _
	ConvertAccount(rGlob("debets"),oid,"d")+ "','"+ _
	ConvertAccount(rGlob("kredits"),oid,"k")+ "','"+ _
	kas + "',1)"
 if veids="io" then
  bookconn.execute "update transakcijas set iorder = " + cstr(rOp("document")) + " where operation = " + cstr(rOp("id"))
 end if
 if veids="oo" then
  bookconn.execute "update transakcijas set oorder = " + cstr(rOp("document")) + " where operation = " + cstr(rOp("id"))
 end if
 bookconn.execute "Update Settings set valu ='1' where upper(variable) = 'CHECKACCOUNTS'"
end if
end function

Function DeleteBookOrder (oid)
'Dabon orderi pçc id
set rGlob = conn.execute ("SELECT * FROM ORDERIS WHERE ID = "+cstr(oid))
'Pârbauda kas tur ir atgriezies
if rGlob.eof then exit function

'parsledzas uz citu baazi ja vajag
if year(rGlob("datums"))<>year(now) then
 bookconn.close
 bookconn.open "DSN=gramatvediba;UID=sa;database=g"+cstr(year(rGlob("datums")))
end if


'Atrod operâciju operâciju lai noteiktu id
set rOp = BookConn.execute("select * FROM operation WHERE goid = " + cstr(oid))
if not rOp.eof then
	'Izdzçð visas transakcijas ðim dokumentam
	BookConn.Execute "DELETE FROM Transakcijas WHERE operation = " + cstr(rOp("id"))
	'Idzçð paðu dokumentu
	BookConn.Execute "DELETE FROM Operation WHERE goid = " + cstr(oid)
end if	
'Idzçð paðu orderi
BookConn.Execute "DELETE FROM ORders WHERE goid = " + cstr(oid)

bookconn.close
bookconn.open "DSN=gramatvediba;UID=sa;database=g"+cstr(year(now))

end function

Function ConvertAccount(acc_p,oid,kd)

acc = acc_p

ConvertAccount = "0"
if isnull(acc) then 
	ConvertAccount = "0"
	exit function
end if

exit function

acc = trim(ucase(acc))

'--- Ja garums mazaaks par 2 nav jeegas konverteet
if len(acc) < 2 then
	ConvertAccount = acc
	exit function
end if


'--- komplekso grupu kontiem speciala apstrâde
if acc="7K" then acc="7.K"
if acc="6K" then acc="6.K"
if acc="7.K" or acc="6.K" then
 set r_l = conn.execute("select pid,nopid from orderis where id = "+cstr(oid))
 if getnum(r_l("pid"))<>0 then 
  ConvertAccount = acc+"." + cstr(r_l("pid"))
  exit function
 end if
 if getnum(r_l("nopid"))<>0 then 
  ConvertAccount = acc+"." + cstr(r_l("nopid"))
  exit function
 end if
 ConvertAccount = acc+".0"
 exit function
end if

if acc="521" then acc="5.2.1"
if acc="5.2.1" then
 if kd = "k" then
  set r = conn.execute("select pid from orderis where id = " + cstr(oid))
  pid = getnum(r("pid"))
 end if
 if kd = "d" then
  set r = conn.execute("select nopid from orderis where id = " + cstr(oid))
  pid = getnum(r("nopid"))
 end if
 set r = conn.execute("select did from piet_saite where pid = " + cstr(pid))
 did = getnum(r("did"))
 ConvertAccount = acc+"."+cstr(did)
 exit function
end if

'---- Ja konts satur puktus tad nav jakonvertee.
if instr(acc,".")<>0 then
 ConvertAccount=acc
 exit function
end if

'---- Ieliek punktus starp visiem simboliem
ConvertAccount = mid(acc,1,1)
for i = 2 to len(acc)
	ConvertAccount = ConvertAccount+ "." + mid(acc,i,1)
next
End function

Function Encode(s)
 enlett = "âèçìîíïòðûþÂÈÇÌÎÍÏÒÐÛÞ"
 for u = 1 to len(s)
  z = mid(s,u,1)
  if instr(enlett,z) <> 0 then Encode = Encode + "#"
  if z = "â" then z = "a"
  if z = "è" then z = "c"
  if z = "ç" then z = "e"
  if z = "ì" then z = "g"
  if z = "î" then z = "i"
  if z = "í" then z = "k"
  if z = "ï" then z = "l"
  if z = "ò" then z = "n"
  if z = "ð" then z = "s"
  if z = "û" then z = "u"
  if z = "þ" then z = "z"
  if z = "Â" then z = "A"
  if z = "È" then z = "C"
  if z = "Ç" then z = "E"
  if z = "Ì" then z = "G"
  if z = "Î" then z = "I"
  if z = "Í" then z = "K"
  if z = "Ï" then z = "L"
  if z = "Ò" then z = "N"
  if z = "Ð" then z = "S"
  if z = "Û" then z = "U"
  if z = "Þ" then z = "Z"
  Encode = Encode + Z
 next
End Function
%>