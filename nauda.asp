<%
function galotne(num,vsk,dsk)
s = dsk
if cipars(num,1)=1 then s = vsk
if cipars(num,2)=1 then s = dsk
galotne = s
end function

function cipars(num,k)
dim my
my = fix(num/(10^(k-1)))
cipars = my-(fix(my/10)*10)
end function
'--------------------------------------
'simts

function simts(num)
dim vieni(10)
dim celms(10)
dim vien
dim desm
dim sim
dim s
vieni(1)="viens"
vieni(2)="divi"
vieni(3)="trîs"
vieni(4)="èetri"
vieni(5)="pieci"
vieni(6)="seği"
vieni(7)="septiòi"
vieni(8)="astoòi"
vieni(9)="deviòi"
celms(1)="vien"
celms(2)="div"
celms(3)="trîs"
celms(4)="èetr"
celms(5)="piec"
celms(6)="seğ"
celms(7)="septiò"
celms(8)="astoò"
celms(9)="deviò"
desm = cipars(num,2)
vien = cipars(num,1)
if desm = 0 then
	s = vieni(vien)+" "
end if
if desm=1 then
	if vien<>0 then
		s=celms(vien)+"padsmit "
	else
		s="desmit "
	end if
end if
if desm>1 then
	if cipars(num,1)<>0 then
		s=celms(desm)+"desmit "+vieni(vien)+" "
	else
		s=celms(desm)+"desmit "
	end if
end if
sim = cipars(num,3)
if sim<>0 then
	s = vieni(sim)+" "+galotne(sim,"simts ","simti ")+s
end if
simts = s
end function
'--------------------------------------
'nauda

function nauda(num, valuta_l)
dim tukst
dim milj
dim sant
dim s
milj = int(num/1000000)
if milj>0 then
	s = s + simts(milj)+galotne(milj,"miljons ","miljoni ")
end if
tukst = int(num/1000)
if tukst>0 then
	s = s + simts(tukst)+galotne(tukst,"tûkstotis ","tûkstoği ")
end if
s = s + simts(num)+valuta_l+" "
sant = num*100
s = s+cstr(cipars(sant,2))+Cstr(cipars(sant,1))+" "
nauda = s
end function
%>