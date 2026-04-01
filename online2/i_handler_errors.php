<?php if(isset($data['errors'])){ 
?>
	<script type="text/javascript">
		var errors = {};
		<?php foreach($data['errors'] as $key => $value){ ?>
			errors['<?=$key?>'] = '<?=$value?>';
		<?php } ?>
	</script>
		<? if (isset($_SESSION['path_to_files'])) $path = $_SESSION['path_to_files'];
	else $path = '';?>
	<script src="<?=$path;?>js/error_handling.js"></script>
<?php } ?>