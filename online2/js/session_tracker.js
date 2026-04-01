var msg_box;

function start_session_tracker() {

	var mins = 30 ;
	//var t = setTimeout(create_session_dialog,(mins*60000));
	var tx = setTimeout(showAlert, (mins*60000));

}

/*function create_session_dialog() {

	var tx = setTimeout(showAlert, 60000);
	
	msg_box = $("<div>Sesijas laiks beigsies pçc 1 minûtes. Pagarinât sesijas laiku?</div>").dialog({
			bgiframe: true,
			resizable: false,
			modal: true,
			close: function(event, ui) {
				if (jQuery.browser.msie) {
					$('select, input[type=checkbox]').show();
				}
			},
			open: function(event, ui) {
				if (jQuery.browser.msie) {
					$('select, input[type=checkbox]').hide();
				}
			},
			hide: "blind",
			show: "blind",
			buttons: {
					'Jâ': function() {
						$.get('update_session.asp',function(data, textStatus){
							if (data == "done"){
								
								clearTimeout(tx);
								start_session_tracker(1);

							} else {
								
								showAlert ();
								
							}
						});

						$(this).dialog('close');

					},
					'Nç': function() {
						
						$(this).dialog('close');

					}
				}
	});
}*/

function showAlert ()
{
	
	$("<div>Rezervâcijas veikðanai paredzçtais laiks iztecçjis. Lûdzu, veiciet rezervâciju no jauna!</div>").dialog({
			bgiframe: true,
			resizable: false,
			modal: true,
			close: function(event, ui) {
				window.location="c_reservation.php?f=TimeExceeded";
											
				if (jQuery.browser.msie) {
					$('select, input[type=checkbox]').show();
				}
			},
			open: function(event, ui) {
				if (jQuery.browser.msie) {
					$('select, input[type=checkbox]').hide();
				}
			},
			hide: "blind",
			show: "blind",
									buttons: {
										'Ok' : function() {
											window.location="c_reservation.php?f=TimeExceeded";
											$(this).dialog('close');
										}

									}
	});

	//msg_box.dialog('destroy');

}


start_session_tracker();