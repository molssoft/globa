<?

$site_base_url= " https://www.impro.lv/online/";
$_SESSION['application'] = array("site_base_url" => $site_base_url,
								"sebReturnGET" => $site_base_url."bank/get_seb.php",
								"dnbnordReturnGET" => $site_base_url."bank/get_dnbnord.php",
								"dnbnordReturnGET2" => $site_base_url."bank/get_dnbnord_status.php",
								"hansabankReturnGET" =>  $site_base_url."bank/get.php"
								//'https://www.impro.lv/online/bank/get.php'//
							);
					
/*	Application("site_base_url")= "https://www.impro.lv/online/" '"http://192.168.1.132/online/"
	Application("site_base_url_ssl")= "https://www.impro.lv/online/"
	Application("site_base_folder") = "E:\LanPub\portal\online" 
	Application("site_inc_folder") = Application("site_base_url")&"inc/"
	Application("site_css_folder") = Application("site_base_url")&"css/"
	Application("site_js_folder") = Application("site_base_url")&"scripts/"
	
	Application("hansabankReturnGET") = Application("site_base_url")&"bank/get.php" 
	Application("s_hansabankReturnGET") = Application("site_base_url_ssl")&"tset/bank/get.php"

	Application("dnbnordReturnGET2") = Application("site_base_url")&"bank/get_dnbnord_status.php"
	Application("dnbnordReturnGET") = Application("site_base_url")&"bank/get_dnbnord.php"
	
	Application("sebReturnGET") = Application("site_base_url_ssl")&"bank/get_seb.php"
	
	

	Application("site_email") = "info@impro.lv"
	Application("mail_server") = "192.168.1.167"
	
	Application("eklase_atlaide") = 5 


	Application("db_driver") = "SQL Server"
	Application("db_server") = "SER-DB"
	Application("db_user") = "www"
	Application("db_pass") = "www"
	Application("db_database") = "globa" 
	Application("db_tb_profili") = "profili"
	Application("db_tb_grupa") = "grupa"
	Application("db_tb_marsruts") = "marsruts"
	Application("db_tb_pieteikums") = "pieteikums"
	Application("db_tb_dalibnieki") = "dalibn"
	Application("db_tb_vietu_veidi") = "vietu_veidi"
	Application("db_tb_piet_saite") = "piet_saite"
	Application("db_tb_viesnicas") = "viesnicas"
	Application("db_tb_viesnicas_veidi") = "viesnicas_veidi"
	Application("db_tb_kajite") = "kajite"
	Application("db_tb_kajites_veidi") = "kajites_veidi"
	Application("db_tb_piet_atlaides") = "piet_atlaides"
	*/

?>