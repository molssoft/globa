<!-- #include file = "../conn.asp" -->
<!-- #include file = "procs.asp" -->

<%
dim conn
openconn

grupa = Request.Form("grupa")

dat = sqldate(now)
if grupa = "" then
 set r = conn.execute("select * from theMain where first_page_start <= '"+dat+"' and (first_page_end >= '"+dat+"' or first_page_end is null) order by first_page_start desc")
else
 set r = conn.execute("select * from theMain where first_page_start <= '"+dat+"' and (first_page_end >= '"+dat+"' or first_page_end is null) and rg = '"+grupa+"' order by first_page_start desc")
end if

set rc = conn.execute("select isnull(count(*),0) from theMain where isnull(parent_id,'') = '"+parent+"'")
set rparent = conn.execute("select * from theMain where id = '"+parent+"'")
%>

<center>
<font face=Tahoma>
<font size=5>Raksti</font><br><br>
<%top_links%>
<hr>


<form name=forma method=POST><%
set rg = conn.execute("select * from theMain where parent_id = 'RAKSTGRUPAS' and active = 1 order by order_num") 
%>
 <select name=grupa>
 <option value="">Visas grupas</option>
<%
while not rg.eof
 %><option value='<%=rg("id")%>'  <%if grupa=rg("id") then Response.Write " selected " %>><%=rg("title")%></option><%
 rg.movenext
wend


%>
</select>
<input type=submit value=Atlasît name=poga>
</form>

<p align=left>

<table border = 0>
<% if parent<>"" and not rparent.eof then %>
 <tr>
  <td width=150><a href=main.asp?parent=<%=rParent("parent_id")%>>...</a></td>
  <td>Bilde</td>
  <td>Nr</td>
  <td  width=200>Nosaukums</td>
  <td></td></tr>
 <% 
else
 %><tr>
  <td width=150></td>
  <td></td>
  <td></td>
  <td width=200></td>
  <td></td>
 </tr><%
end if 

dim i
i = 1
while not r.eof
 %>
 <tr>
 <td>
  <a href=main.asp?parent=<%=r("id")%>><font size=1><%=r("id")%></font></a>
 </td>
 <td>
  <% if nullstring(r("liela_bilde"))<>"" then %>
   <img src="http://www.impro.lv/common_images/<%=r("liela_bilde")%>" width=100>
  <% end if%>
 </td>
 <td><%=r("order_num")%></td>
 <td>
  <% if r("active") then  %>
	<font color=green> <%=r("title")%></font>
    <% else %>
	<font color=red> <%=r("title")%></font>
<% end if %>
 </td>
 <td>
  <%=r("hiti")%>
 </td>
 <td>
  <a href=main_edit.asp?id=<%=r("id")%>>Labot</a>
  | <a href=main_del.asp?id=<%=r("id")%> onclick="return confirm('Patieğâm dzçst?')">Dzçst</a>
  <% if i<>1 then %>
   | <a href=main_up.asp?id=<%=r("id")%>>Uz augğu</a>
  <% end if %>
  <% if i<>rc(0) then %>
   | <a href=main_down.asp?id=<%=r("id")%>>Uz leju</a>
  <% end if %>
 </td></tr><%
 r.movenext
 i = i + 1
wend
%></table><br>

<a href=main_new.asp?parent=<%=parent%>>Jauns (pilnais variants)</a><br>
<a href=main_new_first.asp?parent=<%=parent%>>Jaunums pirmajâ lapâ</a><br>
<a href=main_new_side.asp?parent=<%=parent%>>Jaunums <i>uzmanîbu</i> sadaïâ</a>
