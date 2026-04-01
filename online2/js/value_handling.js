$(document).ready(function(){
	if (typeof values === 'undefined') {
		return;
	}
	$.each(values, function(key, value) {
		var $el = $("[name='" + key.replace(/'/g, "\\'") + "']");
		if (!$el.length) {
			return;
		}
		var v = value;
		$el.each(function() {
			var $f = $(this);
			var type = ($f.attr("type") || "").toLowerCase();
			if (type === "checkbox") {
				$f.prop("checked",
					v === "1" || v === 1 || v === true || v === "on" || String(v).toLowerCase() === "true");
			} else if (type === "radio") {
				$f.prop("checked", String($f.val()) === String(v));
			} else {
				$f.val(v === null || typeof v === "undefined" ? "" : v);
			}
		});
	});
});