<style>
.tab {
	display:inline-block;
	padding-top:10px;
	padding-bottom:10px;
	width:45px;
	height:45px;
	background-color:green;
	color:white;
	margin-top:5px;
	margin-bottom:5px;
}
</style>
<div style="width:100%; text-align:center">
	<a href="c_home.php" onclick="return confirmReturn()"><img src=img/logo2.png style="margin:20px;width:150px;" align="center"></a>
</div>
<div style="width:100%; text-align:center">
<? 
$tabs = $_SESSION['tabs'];

$disable = false;
$current = false;
$i=1;
foreach($tabs as $key=>$tab) {
	$current = false;
	if ($tab['title']) {
		$style = '';
			$style = 'color:white; border-radius: 50%;;
						behavior: url(PIE.htc); ';
		if ($key==$tabs['current']) {
			$style = 'color:orange;border-radius: 50%;';
			$current = true;
			
			// disable folowing tabs
			if ($tabs['wizzard'])
				$disable = true;
		}
		if (!$data['var_labot']){
			$disable = FALSE;
		}
		if (($disable && !$current)) {
			
			$style = 'background-color:#80C080;color:white;border-radius: 50%;';
			?><div class=tab style="<?=$style?>" data-toggle="tooltip" data-placement="top" title="<?=$tab['title']?>"><?=$i++?></div> <?
			
		} else {
			?><a data-toggle="tooltip" data-placement="top" title="<?=$tab['title']?>" href="<?=$tab['link']?>" style="<?=$style?>"><div class=tab style="<?=$style?>"><?=$i++?></div></a> <?
		}
		
	}
} ?>
</div>
<div id="confirmModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Rezerv‚cija nav pabeigta</h4>
      </div>
      <div class="modal-body">
        <center> <p>Vai vÁlaties atcelt rezerv‚ciju?</p>
		<button class="yes btn btn-primary" >J‚</button>
        <button type="button" class="btn btn-default no" >NÁ</button>
      </div>
      <div class="modal-footer">
	 
      </div>
    </div>

  </div>
</div>
<style>
#confirmBox

body { font-family: sans-serif; }
#confirmBox
{
    display: none;
    background-color: #eee;
    border-radius: 5px;
    border: 1px solid #aaa;
    position: fixed;
    width: 300px;
    left: 50%;
    margin-left: -150px;
    padding: 6px 8px 8px;
    box-sizing: border-box;
    text-align: center;
}
#confirmBox button {
    background-color: #ccc;
    display: inline-block;
    border-radius: 3px;
    border: 1px solid #aaa;
    padding: 2px;
    text-align: center;
    width: 80px;
    cursor: pointer;
}
#confirmBox button:hover
{
    background-color: #ddd;
}
#confirmBox .message
{
    text-align: left;
    margin-bottom: 8px;
}
	</style>
<?if ($tabs['current']!=8){?>

<script>
$(function () {
	  var confirmBox = $("#confirmBox");
	  confirmBox.hide();
	//if (($.isFunction('tooltip'))){
  $('[data-toggle="tooltip"]').tooltip()
	//}
	
})
function confirmReturn()
{
	console.log('return');
	
	<?//ja ir iesƒÅkta un nepabeigta rezrevƒÅcija
	//if (isset($_GET['test'])){//} && isset($_SESSION['reservation']['online_rez_id']) && !empty((int)$_SESSION['reservation']['online_rez_id']) && isset($data['var_labot']) && $data['var_labot'] && isset($data['ir_iemaksas']) && !$data['ir_iemaksas']){
		?>
		console.log('RezervƒÅcija nav pabeigta. Vai vƒìlaties to atcelt?');
		var msg = 'Rezerv‚Åcija nav pabeigta. Vai vÁlaties to atcelt?';
		var confirmBox = $("#confirmModal");
			//confirmBox.find(".message").text(msg);
		/*confirmBox.find(".yes,.no").unbind().click(function()
		{
			confirmBox.hide();
		});*/
		confirmBox.find(".yes").click(function(){
			//alert('yes');
			$.ajax({
			  url: "c_reservation.php?f=CancelReservationAjax",
			  method: "POST",
			  
			// dataType: "json"
				
			}).done(function( msg ) {
			 console.log('rezrevacija atcelta');
			 window.location.replace("c_home.php");
			}).fail(function( jqXHR, textStatus ) {
				
				console.log(jqXHR);
			  alert( "Request failed: " + textStatus );
			});
		});
		confirmBox.find(".no").click(function(){
			//alert('no');
			window.location.replace("c_home.php");
		});
		confirmBox.modal();
		return false;
		<?
	//}
	//else{
		?>
		//return true;
		<?
	//}
	?>
  
  /*
*/
}


</script>
<?}?>

