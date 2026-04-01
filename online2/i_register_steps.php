<style>
.tab {
	display:inline-block;
	padding-top:10px;
	padding-bottom:10px;
	width:100px;
	background-color:green;
	color:white;
	margin-top:5px;
	margin-bottom:5px;
}
</style>
<div style="width:100%; text-align:center">
	<a href="c_home.php"><img src=img/logo2.png style="margin:20px;width:150px;"></a>

</div>
<div style="width:100%; text-align:center">
<? 
$tabs = $_SESSION['tabs'];

$disable = false;
$current = false;
foreach($tabs as $key=>$tab) {
	$current = false;
	if ($tab['title']) {
		$style = '';
			$style = 'color:white;';
		if ($key==$tabs['current']) {
			$style = 'color:orange;';
			$current = true;
			
			// disable following tabs
			if ($tabs['wizzard'])
				$disable = true;
		}
		
		if (($disable && !$current) && !(isset($_SESSION['username']))) {
			
			$style = 'background-color:#80C080;color:white;';
			?><div class=tab style="<?=$style?>"><?=$tab['title']?></div> <?
			
		} else {
			?><a href="<?=$tab['link']?>" style="<?=$style?>"><div class=tab style="<?=$style?>"><?=$tab['title']?></div></a> <?
		}
		
	}
} ?>
</div>
<? if (isset($_SESSION['uncompleted_profile_message'])){
	?>
	<div class="col-sm-4 col-sm-offset-4">
	<br>
	<div class="alert alert-warning"><?=$_SESSION['uncompleted_profile_message'];?></div>
	</div>
	<?
}?>

