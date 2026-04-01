
  <head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta charset="UTF-8">
	<!-- Google Tag Manager -->
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
	new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
	j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
	'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
	})(window,document,'script','dataLayer','GTM-MBSZFHP');</script>
	<!-- End Google Tag Manager -->
	<script>
	  window.dataLayer = window.dataLayer || [];
	  function gtag(){dataLayer.push(arguments);}
	  gtag('js', new Date());

	  gtag('config', 'UA-30627014-2');
	</script>
	
	<!-- Jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

	<!-- Optional theme -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

	<!-- Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    <?php
    if (basename($_SERVER['SCRIPT_FILENAME']) == 'c_login.php' && isset($_GET['f']) && $_GET['f'] == 'forgot') {
    	echo '<meta name="description" content="IMPRO Ceļojumu veikals - Ievadiet sava lietotāja e-pasta adresi, uz kuru tiks nosūtīta jaunā parole. NESKAIDRĪBU GADĪJUMĀ SAZINIETIES AR MŪSU KONSULTANTIEM.">';
    } else if (basename($_SERVER['SCRIPT_FILENAME']) == 'c_login.php') {
    	echo '<meta name="description" content="IMPRO Ceļojumu veikals - apskatīt. Dažāda veida ceļojumu iespējas, gan ar autobusu, gan ar avio. Piedāvājumā dažādas kombinācijas.">';
    } else if (basename($_SERVER['SCRIPT_FILENAME']) == 'c_reservation.php' && isset($_GET['f']) && $_GET['f'] == 'BuyGiftCardNoUser') {
    	echo '<meta name="description" content="IMPRO Ceļojumu veikals - Pirkt dāvanu karti. Dažādi ceļojumi - Ar autobusu | Ar lidmašīnu | Ar autobusu + lidmašīnu.">';
    }
    ?>

    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">
	<link rel="stylesheet" href="css/main.css">
    <title>IMPRO Ceļojumu veikals</title>


	<?php if (isset($data['header'])) echo $data['header']; ?>
  </head>
