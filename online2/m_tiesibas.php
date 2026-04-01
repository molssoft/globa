<?
class Tiesibas{
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db;
		define("T_PIET_DAT",1);
		define("T_VEC_ORD_DZ",2);
		define("T_LIETOT_ADMIN",3);
		define("T_PARSK_REG",4);
		define("T_VEC_ORD_REG",5);
		define("T_ORD_LAB",6);
		define("T_NESTAND_ORD",7);
		define("T_ZAUD_LAB",8);
		define("T_KAJITES",9);
		define("T_V_PAKALPOJUMI",10);
		define("T_GRUPU_PAPILD_INFO",11);
		define("T_KURATORS",12);
		define("T_SK_EMAILI",13);
		define("T_SUT_EMAILI",14);
		define("T_GR_LAB1",15);
		define("T_GR_LAB2",16);
		define("T_ATCELT",17);
		define("T_GLOBAS_PARTNERI",18);
		define("T_NORAKSTIT",19);
		define("T_GRAMATVEDIS",20);
		define("T_DROSIBA",22);
		define("T_ANKETAS",23);
		define("T_BALLES_ORG",24);
		define("T_GRAFIKS_LAB",25);
		define("T_PIET_ATL_DAT",27);
		define("T_GRAFIKS_SHOF",28);
		define("T_PARADS",29);
		define("T_TIC_BALLE",30);
		define("T_ONLINE_REZ",31);
		define("T_VECU_PIET_ATLAIDES",32);
		define("T_CELOJUMU_APR",34);
	
	}
	
	function IsAccess($tiesibas) {
		// skatamies vispirms sesijaa
		//'if session("tiesibas_"+cstr(tiesibas)) ="true" then
		//'	IsAccess = true
		//'	exit function
		//'end if
		//'if session("tiesibas_"+cstr(tiesibas)) ="false" then
		//'	IsAccess = false
		//'	exit function
		//'end if
		
		$qry ="SELECT * FROM TiesibuSaites 
				WHERE LietotajsID = ? AND TiesibasID = ?";
		$params = array($this->db->GetCurUserID(),$tiesibas);
		$rAccess = $this->db->Query($qry,$params);
		if (sqlsrv_has_rows($rAccess)) {	
			return true;
			//session("tiesibas_"+cstr($tiesibas)) ="true";
		} else {
			return false;
			//session("tiesibas_"+cstr($tiesibas)) ="false";
		}
	}
	
	


	
}
?>