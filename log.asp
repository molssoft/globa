<%

Sub LogInsertAction(table_p,id_l)
set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
s = nullprint(r_l("vesture"))
if s="" then
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '" + Get_User + " - Izveidoja. "+cstr(now)+"<br>' WHERE id = " + cstr(id_l))
else
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+s+nullprint(Get_User)+" - Izveidoja. "+cstr(now)+"<br>' WHERE id = " + cstr(id_l))
end if
End Sub

Sub LogEditAction(table_p,id_l)
set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
s = nullprint(r_l("vesture"))
if s="" then
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - Laboja. "+cstr(now)+"<br>' WHERE id = " + cstr(id_l))
else
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+s+nullprint(Get_User)+" - Laboja. "+cstr(now)+"<br>' WHERE id = " + cstr(id_l))
end if
End Sub

Sub LogDeleteAction(table_p,id_l)
set r_l = conn.execute ("SELECT vesture FROM " + table_p + " WHERE id = " + cstr(id_l))
s = nullprint(r_l("vesture"))
if isnull(r_l("vesture")) then
	conn.execute ("UPDATE " + table_p + " SET [vesture] = '"+Get_User+" - Izdzçsa. "+cstr(now)+"<br>' WHERE id = " + cstr(id_l))
else
	conn.execute ("UPDATE " +  table_p + " SET [vesture] = '"+s +Get_User+" - Izdzçsa. "+cstr(now)+"<br>' WHERE id = " + cstr(id_l))
end if
End Sub


%>