<? if (!$_SESSION['init']) die('Error:direct access denied');?>
<!DOCTYPE html>
<html lang="lv">
	<? include 'i_head.php'?>

	<body class="" style="background-color:gray;">
		
		<div class="container no-print" style="background-color:white;">		
				<?=$data['contract_data'];?>
		</div>
		<div class="print" style="text-align:center">
			Ðis ir lîguma paraugs. Lîgumu izdrukât varçsiet pçc iemaksas veikðanas.
		</div>
	</body>
	

	
</html>
<style>
.tbl {
	border: 1px solid black;
	
}
.tbl td{
	border: 1px solid black;
	padding:2px
}
.print {
	display:none;
}
@media print
{    
   .no-print {
    display: none;  /* hide whole page */
  }
  .print{
	  display:block
  }
}
</style><style>
			body{line-height:165%;}
			.base {font-size:9px;font-family:Arial;line-height:125%;}
			.base {font-size:9px;font-family:Arial;}
			.normal {font-size:12px;font-family:Arial;line-height:150%;}
			.bold {font-size:12px;font-family:Arial;font-weight:bold;font-style:italic;}
			.bbold {font-size:14px;font-family:Arial;font-weight:bold;}
			.td {font-size:12px;font-family:Arial;}
			.tdb {font-size:12px;font-family:Arial;font-weight:bold;}
			.tbl {background-color:#000;border-spacing: 2px;}
			.tbl td,th,caption{background-color:#fff}
		</style>

