<?
		define('T_PIET_DAT',1);
		define('T_VEC_ORD_DZ',2);
		define('T_LIETOT_ADMIN',3);
		define('T_PARSK_REG',4);
		define('T_VEC_ORD_REG',5);
		define('T_ORD_LAB',6);
		define('T_NESTAND_ORD',7);
		define('T_ZAUD_LAB',8);
		define('T_KAJITES',9);
		define('T_V_PAKALPOJUMI',10);
		define('T_GRUPU_PAPILD_INFO',11);
		define('T_KURATORS',12);
		define('T_SK_EMAILI',13);
		define('T_SUT_EMAILI',14);
		define('T_GR_LAB1',15);
		define('T_GR_LAB2',16);
		define('T_ATCELT',17);
		define('T_GLOBAS_PARTNERI',18);
		define('T_NORAKSTIT',19);
		define('T_GRAMATVEDIS',20);
		define('T_DROSIBA',22);
		define('T_ANKETAS',23);
		define('T_BALLES_ORG',24);
		define('T_GRAFIKS_LAB',25);
		define('T_PIET_ATL_DAT',27);
		define('T_GRAFIKS_SHOF',28);
		define('T_PARADS',29);
		define('T_TIC_BALLE',30);
		define('T_ONLINE_REZ',31);
		define('T_VECU_PIET_ATLAIDES',32);


		define('AGENT_MODE', False);

		$_SESSION['CodePage'] = 1252;
		
function DocStart($title,$wallpaper,$include_bootstrap = false) {
 
	echo "<!DOCTYPE HTML PUBLIC ".chr(34)."-//IETF//DTD HTML//EN".chr(34).">";
	echo "<html>";
	 
	echo "<head>";
	echo "<meta http-equiv='Content-Type' ";
	echo "content= 'text/html; charset=UTF-8'>";
	if ($wallpaper==""){
		// jaunie stili
		echo "<link rel=stylesheet type='text/css' href='styles3.css'><style type='text/css'></style>";
	} else {
		echo "<link rel=stylesheet type='text/css' href='styles.css'><style type='text/css'></style>";
	}
	echo "<title>".$title."</title>";
	echo "<script type='text/javascript' src='https://code.jquery.com/jquery-latest.js'></script>";
	echo "<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js'></script>";
	echo "<script  src='https://code.jquery.com/ui/1.12.1/jquery-ui.min.js'  integrity='sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU='  crossorigin='anonymous'></script>";
	if ($include_bootstrap or $wallpaper=="") echo '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">';
	echo "</head>";
	 
	echo "<body text=".chr(34)."#000000".chr(34)."";
	echo "link=".chr(34)."#008040".chr(34)." vlink=".chr(34)."#804000".chr(34)." alink=".chr(34)."#FF0000".chr(34).">";
}

function DefJavaSubmit() {
 
	echo '<script LANGUAGE="JScript">';
	echo "function TopSubmit(url)";
	echo "{";
	echo "window.event.cancelBubble = true;";
	echo "	document.all['forma'].action = url;";
	echo "	document.all['forma'].submit();";
	echo "	return false;	";
	echo "};";
	 
	echo "function TopSubmit2(url)";
	echo "{";
	echo "	forma.action = url;";
	echo "}";
	 
	echo "</script>";
}

 
/*
  ASP Translator Messages (These can be removed later)
  ----------------------------------------------------

  1. Script uses Left(), Right(), or Mid(). See the Documentation for equivalent PHP functions

*/

function GetUser() {
	$get_user = $_SERVER["LOGON_USER"];
	for ($i=1; $i<=strlen($get_user); $i++) {
		if (substr($get_user,$i-1,1) == "\/" ) {
			$get_user = substr(Get_User,$i,strlen($get_user)-$i);
			return;
		}
	}
	if ($get_user = "") {$get_user = "unknown";}
	return $get_user;
}
 
 


//-------------------------------
//addUser - pievieno jaunu lietotāju, saņemot vārdu un aprakstu
//ja apraksta nav, tad tas kļūst par " "
//-------------------------------
function AddUser($vards, $info) {
	$username=trim($vards);
	if (strlen($info)==0) {$info=" ";}
	if (strlen($username)>20) {$username=substr($username,0,20);}
	if (strlen($username)==0) {return;}
	global $db;
	$values = array('lietotajs'=>$username, 'info' => $info);
	$id = $db->Insert('Lietotaji',$values,$values);
	return $id;
	//$qstrname="INSERT into Lietotaji (lietotajs, info) values ('"+$username+"','"+$info+"');";
	//$conn.execute ($qstrname);
	//set $rstLastUser=server.createobject("adodb.recordset");
	//$rstLastUser.$open "Select id from lietotaji where lietotajs='"+$username+"';",$conn,3,3;
	//return $rstLastUser["id"];
}

//------------------------------
//GetUserId - atgriež lietotāja Id pēc vārda (str*20)
//-----------------------------
function GetUserId($vards) {
	global $db;
	if ($vards=="") {
		return 0;
	}
	$qry = "SELECT lietotaji.id from Lietotaji 
			where UPPER(Lietotajs)=?;";
	$params = array(strtoupper($vards));
	$result = $db->Query($qry,$params);
	if(sqlsrv_has_rows($result) ) {
		while( $rUname = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//print_r($row);
			return $rUname["id"];
		
		}
	
	
	} else {
		//rUname.movefirst
		$ID = AddUser($vards,"unknown");
		return $ID;
				
		
	}
}

//------------------------------
//GetCurUserId - atgriež tekošā lietotāja Id
//-----------------------------
function GetCurUserID() {
	//'If Get_User() = Session("CurUser") and not isnull($_SESSION["CurUserID")) then
	//'	GetCurUserID = $_SESSION["CurUserID")
	//'else
		$_SESSION["CurUser"]   =  GetUser();
		$_SESSION["CurUserID"] =  GetUserID(GetUser());
		return  $_SESSION["CurUserID"];
	//'end if
}

//-----------------------
//Atgriež, vai tekošais lietotājs ir pilnvarots, ņemot vērā lietotāja tiesības (string*10)
//Ja tāda lietotāja nav, tad tas tiek piereģistrēts ar funkciju GetCurUserID
//----------------------
function IsAccess($tiesibas) {
	// skatamies vispirms sesijaa
	//'if session("tiesibas_"+cstr(tiesibas)) = "true" then
	//'	IsAccess = true
	//'	exit function
	//'end if
	//'if session("tiesibas_"+cstr(tiesibas)) = "false" then
	//'	IsAccess = false
	//'	exit function
	//'end if
	$qry = "SELECT * FROM TiesibuSaites WHERE LietotajsID = ? AND TiesibasID = ?";
	$params = array(GetCurUserID(),$tiesibas);
	
	global $db;
	$rAccess = $db->Query($qry,$params);

	if(sqlsrv_has_rows($rAccess) ) {
		$_SESSION["tiesibas_".$tiesibas] = "true";
		return true;
	} else {
		$_SESSION["tiesibas_".$tiesibas] = "false";
		return false;
	}
}

Function HeadLinks(){

?>
	<center><font size=2 face=Arial>
	 <nobr>[ <a href="default.asp">Mājas</a> ]</nobr>
	 <nobr>[ <a href="dalibn.asp">Dalībnieki</a> ]</nobr>  
	 <nobr>[ <a href="grupas2.asp">Labot grupas</a> ]</nobr> 
	 <nobr>[ <a href="out_grupa.asp">Ceļojumu grupas</a> ]</nobr> 
	<? if (IsAccess(T_GRUPU_PAPILD_INFO)) {?>
	 <nobr>[ <a href="out_grupa2.asp">Grupu info</a> ]</nobr>
	<? } ?>
	 <!--<nobr>[ <a href="terms.asp">Iemaksu termiņi</a> ]</nobr> -->
	 <nobr>[ <a href="kavetaji_param.asp">Kavētāju saraksts</a> ]</nobr> 
	<? if (!IsAccess(T_DROSIBA)) {?>
	 <nobr>[ <a href="ord_list.asp">Operāciju pārskats</a> ]</nobr> 
	<? } ?>
	 <!--<nobr>[ <a href="valuta.asp">Valūtas kursi</a> ]</nobr> -->
	<? if (!IsAccess(T_DROSIBA)) {?>
	 <nobr>[ <a href="agenti.asp">Aģenti</a> ]</nobr> 
	<? } ?>
	 <!--<nobr>[ <a href="agenti_stat.asp">Aģentu statistika</a> ]</nobr> -->
	 <nobr>[ <a href="piet_meklesana.asp">Pieteikumu pārskats</a> ]</nobr> 
	 <nobr>[ <a href="grafiks_sais.asp">Darba grafiks</a> ]</nobr>
	</font></center>
	<style>a{color: #008040;text-decoration:underline}</style>
<?}
function checkEmail($email) {
   $find1 = strpos($email, '@');
   $find2 = strpos($email, '.');
   return ($find1 !== false && $find2 !== false && $find2 > $find1);
}




?>
