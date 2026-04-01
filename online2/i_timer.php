<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
			 
<script type="text/javascript" src="js/session_tracker.js"></script>
<?
$timer_sek_left = 0;
//testam
//$timer_sek_total = 1;
if (isset($_SESSION['test']) && false){
	require_once("m_online_rez.php");
	$online_rez = new OnlineRez();
	$r = $online_rez->GetId($_SESSION['reservation']['online_rez_id']);
	$deriga_lidz = new DateTime($r['deriga_lidz']);

	//echo "deriga_lidz $deriga_lidz";
	if (!$r['no_delete']){
		$now = new DateTime();
		$timer_sek_left = $deriga_lidz->GetTimestamp() - $now->GetTimestamp();
		?>
		
		<!doctype html>
		<html lang="en">
		<head>
		  <meta charset="utf-8">
		  <meta name="viewport" content="width=device-width, initial-scale=1">
		  <title>jQuery UI Dialog - Modal message</title>
		  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
		  <link rel="stylesheet" href="/resources/demos/style.css">
		  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
		  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
		  <script>
		  $( function() {
			$( "#dialog-message" ).dialog({
			  modal: true,
			  buttons: {
				Ok: function() {
				  $(this ).dialog( "close" );
				  location.replace("c_reservation.php?f=TimeExceeded");
				  
				}
			  },
			  close: function( event, ui ) {
				  location.replace("c_reservation.php?f=TimeExceeded");
				 }
			});
		  } );
		  </script>
		</head>
		<body>
		</body>
		</html>	
		<?
		if ($r['datums'] < $deriga_lidz){
			?>
				<script type="text/javascript">
				window.onload=WindowLoad;
				function WindowLoad(event) {    
					ActivateCountDown(<?=$timer_sek_left;?>);
				}
				function cls_info_line(id)
				{
					this.info_line = id;
					this.set = info_line_set_msg;	
				}
				function info_line_set_msg(msg)
				{
					obj = document.getElementById(this.info_line);
					obj.innerHTML = msg;
				}
			</script>	
			<script src="js/CountDown.js"></script>
							
			<p align="right" >Laiks rezervâcijas veikðanai: <span id="CountDownPanel" ></span></p>
				<?
		}
		else  {?>	
			<div class="col-md-4 col-md-offset-4" style="padding-bottom:20px">
				<div class="col-sm-12">
					Rezervâcijas veikðanai paredzçtais laiks iztecçjis. Lûdzu, veiciet rezervâciju no jauna!<br />

				</div>
				<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
				<a class="btn btn-block btn-default" href="c_home.php" style="background-position:0 0">Atgriezties uz sâkumu</a>
			</div>
			</div>
				 <?
			//require_once('v_reservation_time_exceeded.php');
			exit();
		}
	}
}
else{
	$timer_sek_total = 1800; //'--- rezervacijas laiks 30 minutes

	$time_passed = GetTimer($_SESSION['reservation']['online_rez_id']);
	//echo "TIME PASSED: $time_passed and (int)=". (int)$time_passed ."<br>";
	if ((int)$time_passed>=0 && is_numeric($time_passed) /*$time_passed != "no delete"*/){
		//&& $time_passed != 'no delete'
		//echo 'râdâm';
		$timer_sek_left = $timer_sek_total - $time_passed;
		//echo "timer_sek_left: $timer_sek_left <br>";
		if (!isset($timer_text)) $timer_text = 'rezervâcijas';
		if ($timer_sek_left >0){
		?>
		<script type="text/javascript">
			window.onload=WindowLoad;
			function WindowLoad(event) {    
				ActivateCountDown(<?=$timer_sek_left;?>);
			}
			function cls_info_line(id)
			{
				this.info_line = id;
				this.set = info_line_set_msg;	
			}
			function info_line_set_msg(msg)
			{
				obj = document.getElementById(this.info_line);
				obj.innerHTML = msg;
			}
		</script>	
		<script src="js/CountDown.js"></script>
						
		<p align="right" >Laiks <?=$timer_text;?> veikðanai: <span id="CountDownPanel" ></span></p>
					<?
		}
		else{
			//header('Location: c_reservation.php?f=TimeExceeded');
			 ?>	
					<div class="col-md-4 col-md-offset-4" style="padding-bottom:20px">
						<div class="col-sm-12">
							Rezervâcijas veikðanai paredzçtais laiks iztecçjis. Lûdzu, veiciet rezervâciju no jauna!<br />

						</div>
						<div class="col-sm-12 btn-toolbar" style="margin-top:10px;">
						<a class="btn btn-block btn-default" href="c_reservation.php?f=CancelReservation&par=1" onclick=""style="background-position:0 0">Atgriezties uz sâkumu</a>
					</div>
					</div>
						 <?
			//require_once('v_reservation_time_exceeded.php');
			exit();
		}
	}
	//else echo 'no';
}


function GetTimer($rez_id) {
	if (!empty($rez_id)) {
		require_once("m_online_rez.php");
		$online_rez = new OnlineRez();
		$r = $online_rez->GetId($rez_id);
		//var_dump($r);
		//$ssql = "SELECT datums,no_delete FROM online_rez WHERE deleted = 0 AND id = ".$rez_id;
		//SET $r = $db.$Conn.Execute($ssql);

		if (!empty($r)) {
			if ($r['no_delete']){
				$result = 'no delete';
			}
			else{
				$interval = date_diff(($r["datums"]),new DateTime()); //time()&" / "&FormatDateTime(r("datums"),3)&" / "&
				if (DEBUG){
					var_dump($interval);
					echo "<br><br>";
				}
				$result = $interval->format("%s");
				$date = $r["datums"];
				$date2 = new DateTime( );
				$result = $date2->getTimestamp() - $date->getTimestamp();
				if (DEBUG) var_dump($result);
				if (($result >= 1800 )) {
					if ( $r["no_delete"] == 0 ){
					//require_once("v_reservation_time_exceeded.php");
					//exit();
					//response.redirect "laiks_beidzies.asp";
					?>

						<!doctype html>
						<html lang="en">
						<head>
						  <meta charset="utf-8">
						  <meta name="viewport" content="width=device-width, initial-scale=1">
						  <title>jQuery UI Dialog - Modal message</title>
						  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
						  <link rel="stylesheet" href="/resources/demos/style.css">
						  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
						  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
						  <script>
						  $( function() {
							$( "#dialog-message" ).dialog({
							  modal: true,
							  buttons: {
								Ok: function() {
								  $(this ).dialog( "close" );
								  location.replace("c_reservation.php?f=TimeExceeded");
								  
								}
								
								
							  },
							  close: function( event, ui ) {
								  location.replace("c_reservation.php?f=TimeExceeded");
								 }
							});
						  } );
						  </script>
						</head>
						<body>
						 
						<!--<div id="dialog-message" title="">
						  <p>
						  Sesijas laiks ir beidzies. Jums jâautorizçjas no jauna.
							<!--Rezervâcijas veikðanai paredzçtais laiks iztecçjis. Lûdzu, veiciet rezervâciju no jauna!
						 --> </p>
						 <!--
						</div>-->
						 
						
						 
						</body>
						</html>		
					
					
					<?
					
					
					}
					else{
					
						$result = 'no delete';
					}
				}
			}
		}
	}
	return  $result;
	
}

?>
