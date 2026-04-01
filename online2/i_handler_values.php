<?php if(isset($data['values'])){ 
	if (!function_exists('i_handler_values_json_segment')) {
		function i_handler_values_json_segment($value) {
			
			if (is_array($value) || is_object($value)) {
				$s = '';
			} else {
				$s = is_scalar($value) ? (string) $value : '';
			}
			// backslash first, then quote
			$s = str_replace('\\', '\\\\', $s);
			$s = str_replace("'", "\\'", $s);
			// optional: avoid `</script>` breaking HTML and tame `&` in odd parsers
			$s = str_replace('<', '\\u003c', $s);
			$s = str_replace('&', '\\u0026', $s);
			return $s;

		}
	}
?>
	<script type="text/javascript">
		var values = {};
		<?php foreach($data['values'] as $key => $value){
			if (!is_string($key) && !is_int($key)) {
				continue;
			}
			$keyEsc = htmlspecialchars((string)$key, ENT_QUOTES, 'UTF-8');
			$valEnc = i_handler_values_json_segment($value);
		?>
			values['<?= $keyEsc ?>'] = '<?= $valEnc ?>';
		<?php } ?>
	</script>
	<? if (isset($_SESSION['path_to_files'])) $path = $_SESSION['path_to_files'];
	else $path = '';?>
	<script src="<?=$path;?>js/value_handling.js"></script>
<?php } ?>