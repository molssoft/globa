<!-- #include file = "procs.inc" -->
<!-- #include file = "dbprocs.inc" -->

<%
dim conn
openconn
skaitit = 0
set r = conn.execute("SELECT id FROM viesnicas_veidi WHERE gid in (select id from grupa where sakuma_dat>=Getdate()) order by id desc")
while not r.eof 
if (skaitit<1273) then
rw r(0)
rw "<br>"
	RefreshViesnVeids(r(0))
	skaitit  = skaitit+1
	end if
	r.movenext
wend
 

%>