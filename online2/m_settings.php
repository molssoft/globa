<?
class Settings {
	var $db;
	var $bankas;
	var $admin_email = 'r.treikalisha@gmail.com';
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db;	
		$this->bankas = array('ar_karti'=>'Maksâjumu kartes','swedbank'=>'Swedbank internetbanka','dnb'=>'Luminor internetbanka','seb'=>'SEB internetbanka','citadele'=>'Citadele internetbanka');
		$this->bankas_akuz = array('ar_karti'=>'Maksâjumu kartes','swedbank'=>'Swedbank internetbanku','dnb'=>'Luminor internetbanku','seb'=>'SEB internetbanku','citadele'=>'Citadele internetbanku');
		
	}
	
		
	function GetBankas(){
		$qry = "SELECT * FROM settings where variable in ('".implode("' ,'",array_keys($this->bankas))."')";
		//echo $qry;
		$result = $this->db->Query($qry);
		$data = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			
			$data[$this->bankas[$row['variable']]] = $row;			
		}
		return $data;
	}
	
	function GetBankasShort(){
		$qry = "SELECT * FROM settings where variable in ('".implode("' ,'",array_keys($this->bankas))."')";
		//echo $qry;
		$result = $this->db->Query($qry);
		$data = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			
			$data[$row['variable']] = $row['valu'];			
		}
		return $data;
	}
	
	function ResetBankas(){
		foreach ($this->bankas as $variable=>$title){
			$qry = "UPDATE settings SET valu=0 WHERE variable=?";
			$params = array($variable);
			$result = $this->db->Query($qry,$params);
		}		
	}
	//vçstures saglabâðana
	function LogAction($variable,$value){
		
		$qry = "SELECT vesture FROM Settings WHERE variable = ?";
		$params = array($variable);
			
		$result = $this->db->Query($qry,$params);
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		$ves = $row["vesture"];
		
		if (empty($ves)) {
			$ves = '';
		}
		$action_p =  ($value ? 'pieslçdza' : 'atslçdza');
		$qry = "UPDATE settings SET [vesture] = '".$ves.$this->db->GetUser()." - ".$action_p." || ".date("d.m.Y H:i:s")."<br>' WHERE variable = ?";
			
		
		$this->db->Query($qry,$params);
	}
	
	function UpdateBankas($data){
		$old_values = $this->getBankasShort();
		$this->ResetBankas();
	
		foreach($data as $variable=>$valu){
			//print_r($row);
			$qry = "UPDATE settings SET valu=1 WHERE variable=?";
			$params = array($variable);
			$result = $this->db->Query($qry,$params);
		}
		$new_values = $this->getBankasShort();
		
		foreach ($new_values as $variable=>$valu){
			if ($valu != $old_values[$variable]){
				
				//saglabâ vçsturç izmaiòas
				$this->LogAction($variable,$valu);
				
				//aizsûta uz e-pastu info par izmaiòâm
				//echo 'nesakrît'.$variable.', jaunâ vçrtîba ir '.$valu."<br>";
				$this->NotifyBankChanges($variable,$valu);
			}
		}
		
	}
	
	//izsûta atbildîgajam e-pastu par bankas pieslçgðanu/atslçgðanu
	function NotifyBankChanges($bank,$value){
		require_once($_SESSION['path_to_files']."l_email.php");
		$email = new Email();
		$darbiba = ($value ? 'pieslçgta' : 'atslçgta');
		$subject = $darbiba." ".$this->bankas[$bank];
		$msg = "Informçjam, ka Online vidç ir <b>".$darbiba.'</b> iespçja maksât, izmantojot <b>'.$this->bankas[$bank].'</b>.<br>Darbîbu veica <i>'.$this->db->GetUser()."</i>";
		//echo $msg;
		//var_dump($email);
		$result = $email->SendMail($msg,"Online apmaksas veidu maiòa: ".$subject,$this->admin_email,true,'NotifyBankChanges');
		
	}
	
	//atgrieþ ziòojumu par bankâm, ar kurâm ðobrîd nav iespçjams samaksât
	function GetDisabledBankas(){
		$qry = "SELECT * FROM settings where variable in ('".implode("' ,'",array_keys($this->bankas))."') AND valu='0'";
		//echo $qry;
		$result = $this->db->Query($qry);
		$data = array();
		$msg=false;
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] .= "<b>".$this->bankas_akuz[$row['variable']]."</b>";
		}
		if (!empty($data)){
			$msg = "Paðlaik nav iespçjams veikt maksâjumus, izmantojot ".implode(", ",$data).".<br>Atvainojamies par sagâdâtajâm neçrtîbâm.";
			
		}
		return $msg;
	}
}