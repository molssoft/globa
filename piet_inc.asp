<%
'----------------------------
'GenerateComplexLevels - Izveido javafunkcijas lai nodroðinât daudzlîmeòu pakalpojumu izvçli
'----------------------------
Sub GenerateComplexLevels(gid_p,rinda_l)
lastlim = 5
for lim = 1 to lastlim-1
	set r_l = conn.execute ("select * from vietu_veidi where (not isnull(tips,'') like '%_NA') and  gid = "+cstr(gid_p)+" and limenis = " + cstr(lim+1) + " ORDER BY virsnieks ")
	%>
	<SCRIPT LANGUAGE="JScript">
	function limenis<%=rinda_l%>_<%=lim%>() {
	<% for clear_box = lim+1 to lastlim-1 %>
	document.all.vieta<%=rinda_l%>_<%=clear_box%>.innerHTML = "";
	<% next %>
	
	<% curlev = 0
	teksts = "<select id='viet_veid" + cstr(rinda_l) + "_" + cstr(lim+1) + "' name='viet_veid" + cstr(rinda_l) + "_" + cstr(lim+1) + "' onchange='limenis"+cstr(rinda_l)+"_"+cstr(lim+1)+"()'><option value = 0>-</option>"
	while not r_l.eof 
		if r_l("virsnieks")<>curlev then
			if curlev <> 0 then
				teksts = teksts + "</select>"
				%>
				if (document.all.viet_veid<%=rinda_l%>_<%=lim%>.value == <%=curlev%> )
					{document.all.vieta<%=rinda_l%>_<%=lim+1%>.innerHTML = "<%=teksts%>";}
				<% 
			end if
			curlev = r_l("virsnieks")
			teksts = "<select id='viet_veid" + cstr(rinda_l) + "_" + cstr(lim+1) + "' name='viet_veid" + cstr(rinda_l) + "_" + cstr(lim+1) + "' onchange='limenis"+cstr(rinda_l)+"_"+cstr(lim+1)+"()'><option value = 0>-</option>"
		end if
		teksts = teksts + "<option value = " + cstr(r_l("id")) + ">" + cstr(r_l("nosaukums")) 
		if getnum(r_l("limits")) <> 0 then
		 if nullprint(r_l("limita_grupa"))<>"" then
		  'nosakam cik aizòemts
		  set rAiznemts = conn.execute("select sum(vietsk) from piet_saite where vietas_veids in (select id from vietu_veidi where limita_grupa = '"+r_l("limita_grupa")+"')")
		 else
		  set rAiznemts = conn.execute("select sum(vietsk) from piet_saite where vietas_veids = "+cstr(r_l("id")))
		 end if
		 teksts = teksts +  " (Palicis"+cstr(r_l("limits")-getnum(rAiznemts(0)))+" no "+cstr(r_l("limits"))+")"
		end if
		teksts = teksts + "</option>"
	r_l.movenext
	wend

	if curlev <> 0 then
		teksts = teksts + "</select>"
		%>
		if (document.all.viet_veid<%=rinda_l%>_<%=lim%>.value == <%=curlev%> )
			{document.all.vieta<%=rinda_l%>_<%=lim+1%>.innerHTML = "<%=teksts%>";}
		<% 
	end if %>
	}
	</SCRIPT>
<% 
next
End Sub

Function VietuVeidiCombo(gid_p,sel_p,rinda_p,virsn_p,lim_p)
	'sel_p izvçlçtais saraksta elements (IN)
	'rinda_p rinda pieteikumâ (IN)
	'virsn_p tekoðâ saraksta virsnieks (ja augstâkais lîmenis, tad 0) (OUT)
	'lim_p dziïuma lîmenis (OUT)
	set rViens_l = conn.execute ("SELECT * FROM Vietu_veidi WHERE id = " + cstr(GetNum(sel_p)))
	if rViens_l.eof then
		''set rSaraksts_l = conn.execute ("Select * FROM Vietu_veidi WHERE ((not isnull(tips,'') like '%_NA')  or id = "+CStr(getnum(sel_p))+")  and (gid = " + cstr(gid_p) + " or gid in (SELECT vietas_gid from grupa where id = "+cstr(gid_p)+")) and isnull(virsnieks,0) = 0 order by nosaukums " )
		set rSaraksts_l = conn.execute ("Select * FROM Vietu_veidi WHERE ((not isnull(tips,'') like '%_NA')  or id = "+CStr(getnum(sel_p))+")  and (gid = " + cstr(gid_p) + ") order by nosaukums " )
		virsn = 0
		lim_p = 1
	else
		virsn_p = rViens_l("virsnieks")
		lim_p = rViens_l("limenis")
		if virsn_p <> 0 then
			set rSaraksts_l = conn.execute ("Select * FROM Vietu_veidi WHERE Virsnieks = " + cstr(virsn_p) + " order by nosaukums ")
		else
			set rSaraksts_l = conn.execute ("Select * FROM Vietu_veidi WHERE  ((not isnull(tips,'') like '%_NA') or id = "+CStr(sel_p)+") and (gid = " + cstr(gid_p) + " or gid in (SELECT vietas_gid from grupa where id = "+cstr(gid_p)+")) and virsnieks = 0 order by nosaukums " )

		end if
	end if

	return_l = "<span id = ""vieta" + cstr(rinda_p) + "_" + cstr(lim_p) + """>"
	return_l = return_l + "<select name = 'viet_veid"+cstr(rinda_p)+"_"+cstr(lim_p)+"' onchange='limenis"+cstr(rinda_p)+"_"+ cstr(lim_p)+"()'>"
	return_l = return_l + "<option value = 0>-</option>"
	while not rSaraksts_l.eof
		if isnull(rSaraksts_l("tips")) or rSaraksts_l("tips")<>"G" then 'pakalpojumu sarakstaa neizvada "Grupas nauda", kas ir domats tikai grupas vaditajiem
		 
		 '--- izvada, ja dalibn jau ir ðis pakalpojums vai arî tad, kad pakalpojums vçl ir pieejams pçc limita
		 '--- pretçjâ gadijumâ pakalpojumu neizvada
		 
		 limits = getnum(rSaraksts_l("limits"))
		 if (nullprint(rSaraksts_l("id")) = nullprint(sel_p)) or (not reachedLimit(rSaraksts_l("id"), limits)) then
			
			return_l = return_l + "<option value = " + cstr(rSaraksts_l("id")) + " "
			if nullprint(rSaraksts_l("id")) = nullprint(sel_p) then return_l = return_l + "selected"
			return_l = return_l + ">" + nullprint(rSaraksts_l("nosaukums"))  + " " + cstr(getnum(rSaraksts_l("cenaEUR"))) + " EUR"
			
			
			if limits <> 0 then
				 if nullprint(rSaraksts_l("limita_grupa"))<>"" then
				  'nosakam cik aizòemts
				  set rAiznemts = conn.execute("select sum(vietsk) from piet_saite where vietas_veids in (select id from vietu_veidi where limita_grupa = '"+rSaraksts_l("limita_grupa")+"')")
				 else
				  set rAiznemts = conn.execute("select sum(vietsk) from piet_saite where deleted = 0 and vietas_veids = "+cstr(rSaraksts_l("id")))
				 end if
				
				 brivs = limits-getnum(rAiznemts(0))
				 if brivs >= 0 then
					return_l = return_l +  " (Palicis "+cstr(brivs)+" no "+cstr(limits)+")"
				 else
					return_l = return_l +  " (Limits "+cstr(limits)+" pârsniegts!!!!)"
				 end if
			end if
			
			return_l = return_l + "</option>"
		 end if	
		 
		end if
		rSaraksts_l.movenext
	wend
	return_l = return_l + "</select></span>"
	vietuVeidiCombo = return_l
End Function

function reachedLimit(p_vv, p_limit)
	
	res = false
	if p_limit <> 0 and not isnull(p_limit) then
		set rAiznemts = conn.execute("select sum(vietsk) from piet_saite where deleted = 0 and vietas_veids = "+cstr(p_vv))
		brivs = p_limit-getnum(rAiznemts(0))
		if brivs<=0 then
			res = true
		end if
	end if	
	reachedLimit = res
	
end function

Function VietuVeidiSubCombo(sel_p,rinda_p,lim_p)
	'sel_p izvçlçtais saraksta elements kura apakðsarakstu jâzîmç(IN)
	'rinda_p rinda pieteikumâ (IN)
	set rSaraksts_l = conn.execute ("Select * FROM Vietu_veidi WHERE Virsnieks = " + cstr(sel_p) + " order by nosaukums ")
	'rw rSaraksts_l("limits")
	return_l = "<span id = ""vieta" + cstr(rinda_p) + "_" + cstr(lim_p+1) + """>"
	if not rSaraksts_l.eof then
		return_l = return_l + "<select name = 'viet_veid"+cstr(rinda_p)+"_"+cstr(lim_p+1)+"' onchange='limenis"+cstr(rinda_p)+"_"+ cstr(lim_p+1)+"()'>"
		return_l = return_l + "<option value = 0>-</option>"
		while not rSaraksts_l.eof
			return_l = return_l + "<option value = " + cstr(rSaraksts_l("id")) + " "
			if cstr(rSaraksts_l("id")) = cstr(sel_p) then return_l = return_l + " selected "
			return_l = return_l + ">" + rSaraksts_l("nosaukums") 
			if getnum(rSaraksts_l("limits")) <> 0 then
			 if nullprint(rSaraksts_l("limita_grupa"))<>"" then
			  'nosakam cik aizòemts
			  set rAiznemts = conn.execute("select sum(vietsk) from piet_saite where vietas_veids in (select id from vietu_veidi where limita_grupa = '"+rSaraksts_l("limita_grupa")+"')")
			 else
			  set rAiznemts = conn.execute("select sum(vietsk) from piet_saite where vietas_veids = "+cstr(rSaraksts_l("id")))
			 end if
		  return_l = return_l +  " (Palicis"+cstr(rSaraksts_l("limits")-getnum(rAiznemts))+")"
			end if
			return_l = return_l + "</option>"
			rSaraksts_l.movenext
		wend
		return_l = return_l + "</select>"
	end if
	return_l = return_l + "</span>"
	vietuVeidiSubCombo = return_l
End Function

Function VietuVeidiComboGV(gid_p, sel_p)
	'atgriezh combobox html, kur it tikai pakalpojumi ar tipu G - "Grupas nauda"
	'gid_p - grupa
	'sel_p - pakalpojuma id
	
	return_l = ""
	'atgrieþ tikai vecumam piemçrotos fitrus
	set rViens_l = conn.execute ("SELECT * FROM Vietu_veidi WHERE tips = 'G' and gid=" & gid_p) ' &" AND id=" + cstr(GetNum(sel_p))

	if not rViens_l.eof then
	

		return_l = "<span id = ""vieta1_1"">"
		return_l = return_l + "<select name = 'viet_veid1_1' onchange='limenis1_1()'>"
		'return_l = return_l + "<option value = 0>-</option>"
		while not rViens_l.eof 
			
			return_l = return_l + "<option value = " + cstr(rViens_l("id")) 
			if sel_p = rViens_l("id") then return_l = return_l + " selected"
			return_l = return_l + ">" + nullprint(rViens_l("nosaukums"))+"</option>"
			
			rViens_l.movenext
		wend
		return_l = return_l + "</select></span>"
	
	end if

	vietuVeidiComboGV = return_l
	
End Function

Function GetPakalpojumsSet (vid)
	ThisSet = cstr(vid)
	AllSet = cstr(vid)
	set r_l = conn.execute ("SELECT ID FROm Vietu_veidi WHERE Virsnieks IN ("+ThisSet+") ")
	while not r_l.eof
		ThisSet = cstr(r_l("id"))
		AllSet = AllSet + "," + cstr(r_l("id"))
		r_l.movenext
		while not r_l.eof
			ThisSet = ThisSet + "," + cstr(r_l("id"))
			AllSet = AllSet + "," + cstr(r_l("id"))
			r_l.movenext
		wend
		set r_l = conn.execute ("SELECT ID FROM Vietu_veidi WHERE Virsnieks IN ("+ThisSet+") ")
	wend
	GetPakalpojumsSet = AllSet
End Function

'atgrieþ dalîbnieka pilno gadus uz ceïojuma beigu datumu
Function GetPilniGadi(did_p,gid)
	dim r_g
	dim beigu_dat
	ssql = "SELECT beigu_dat FROM grupa WHERE atcelta = 0 AND id = "&gid
	set r_g = Conn.execute(ssql)
		
	if not r_g.eof then beigu_dat = DateAdd("d", 1, r_g("beigu_dat"))
	GetPilniGadi = vecums_new(did_p,beigu_dat)
End Function

'vietu veidi pçc dalîbnieka vecumam
Function VietuVeidiComboVecums(gid_p, sel_p, rinda_p, virsn_p, lim_p, did)
    'sel_p izveletais saraksta elements (IN)
    'rinda_p rinda pieteikuma (IN)
    'virsn_p tekoša saraksta virsnieks (ja augstakais limenis, tad 0) (OUT)
    'lim_p dziluma limenis (OUT)
    'atgriež tikai vecumam piemerotos pakalpojumus

    Dim vecums, rViens_l, rSaraksts_l, qry, return_l
    Dim limits, var_radit, rAiznemts, brivs


    vecums = GetPilniGadi(did, gid_p)


    Set rViens_l = conn.execute("SELECT * FROM Vietu_veidi WHERE id = " & CStr(GetNum(sel_p)))
    If rViens_l.eof Then
        qry = "Select * FROM Vietu_veidi WHERE ((not isnull(tips,'') like '%_NA') or id = " & CStr(GetNum(sel_p)) & ") and (gid = " & CStr(gid_p) & ") order by nosaukums "
        Set rSaraksts_l = conn.execute(qry)
        virsn_p = 0
        lim_p = 1
    Else
        virsn_p = rViens_l("virsnieks")
        lim_p = rViens_l("limenis")
        If virsn_p <> 0 Then
            Set rSaraksts_l = conn.execute("Select * FROM Vietu_veidi WHERE Virsnieks = " & CStr(virsn_p) & " order by nosaukums ")
        Else
            qry = "Select * FROM Vietu_veidi WHERE ((not isnull(tips,'') like '%_NA') or id = " & CStr(sel_p) & ") and (gid = " & CStr(gid_p) & " or gid in (SELECT vietas_gid from grupa where id = " & CStr(gid_p) & ")) and virsnieks = 0 order by nosaukums "
            Set rSaraksts_l = conn.execute(qry)
        End If
    End If


    return_l = return_l & "<span id = ""vieta" & CStr(rinda_p) & "_" & CStr(lim_p) & """>"
    return_l = return_l & "<select name = 'viet_veid" & CStr(rinda_p) & "_" & CStr(lim_p) & "' onchange='limenis" & CStr(rinda_p) & "_" & CStr(lim_p) & "()'>"
    return_l = return_l & "<option value = 0>-</option>"



    While Not rSaraksts_l.eof
        If IsNull(rSaraksts_l("tips")) Or rSaraksts_l("tips") <> "G" Then
            limits = GetNum(rSaraksts_l("limits"))
            If (nullprint(rSaraksts_l("id")) = nullprint(sel_p)) Or (Not reachedLimit(rSaraksts_l("id"), limits)) Then
                var_radit = 1
                If (rSaraksts_l("max_vecums") <> "") Then
                    If (vecums > rSaraksts_l("max_vecums")) Then
                        var_radit = 0
                    End If
                End If
                If (rSaraksts_l("min_vecums") <> "") Then
                    If (vecums < rSaraksts_l("min_vecums")) Then
                        var_radit = 0
                    End If
                End If

				If (nullprint(rSaraksts_l("id")) = nullprint(sel_p)) Then
					var_radit = 1
				End if

                If var_radit = "1" Then
                    return_l = return_l & "<option value = " & CStr(rSaraksts_l("id")) & " "
                    If nullprint(rSaraksts_l("id")) = nullprint(sel_p) Then return_l = return_l & "selected"
                    return_l = return_l & ">" & nullprint(rSaraksts_l("nosaukums")) & " " & CStr(GetNum(rSaraksts_l("cenaEUR"))) & " EUR"

                    If limits <> 0 Then
                        If nullprint(rSaraksts_l("limita_grupa")) <> "" Then
                            Set rAiznemts = conn.execute("select sum(vietsk) from piet_saite where vietas_veids in (select id from vietu_veidi where limita_grupa = '" & rSaraksts_l("limita_grupa") & "')")
                        Else
                            Set rAiznemts = conn.execute("select sum(vietsk) from piet_saite where deleted = 0 and vietas_veids = " & CStr(rSaraksts_l("id")))
                        End If

                        brivs = limits - GetNum(rAiznemts(0))
                        If brivs >= 0 Then
                            return_l = return_l & " (Palicis " & CStr(brivs) & " no " & CStr(limits) & ")"
                        Else
                            return_l = return_l & " (Limits " & CStr(limits) & " parsniegts!!!!)"
                        End If
                    End If

                    return_l = return_l & "</option>"
                End If
            End If
        End If
        rSaraksts_l.MoveNext
    Wend

    return_l = return_l & "</select></span>"
    VietuVeidiComboVecums = return_l
End Function

%>