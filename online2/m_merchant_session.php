<?
class MerchantSession {
	var $db;
	
	public function __construct() { 
		require_once('m_init.php');
		$this->db = new Db;	
	}
	
	function getRealIpAddr(){
		if (!empty($_SERVER['HTTP_CLIENT_IP'])){   //check ip from share internet
			$ip=$_SERVER['HTTP_CLIENT_IP'];
		} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])){   //to check ip is pass from proxy
			$ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
		} else {
			$ip=$_SERVER['REMOTE_ADDR'];
		}
		return $ip;
	}
	
	function GetHash($hash){
		$query = "SELECT * FROM merchant_session WHERE hash=?";
		$params = array($hash);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
	}
	
	function CreatePhpSession($rez_id = 0, $summa = 0, $description = '', $vars = array()){
		require_once("bank/i_bank_functions.php"); 
		$f_name = "m_merchant_session.php CreatePhpSession(".$rez_id.",".$summa.",$description,".print_r($vars,true).")";
		
		$ip = $this->getRealIpAddr();
		$hash = sha1('ms410a'.date('Y.m.d H:i:s').$this->getRealIpAddr().rand());
		
		
		
		$query = "INSERT INTO [globa].[dbo].[merchant_session] ([hash],[ip],[summa],[description],[timestamp],[rez_id]) VALUES ('$hash','$ip',$summa,'$description',GetDate(),$rez_id)";
		$text = "query: ".$query;
		Log2File($text,$f_name);
		$this->db->Query($query);
		/*$values = array('hash' => $hash,
						'ip' => $ip,						
						'summa' => $summa,
						'description' => $desc,
						'timestamp' => $formated_date,
						'rez_id' => $rez_id
						);
		$this->db->Insert('merchant_session',$values);*/
	
		//dabū merchant_session ID tikko saglabātās
		$query = "SELECT id ,hash FROM [globa].[dbo].[merchant_session] WHERE hash = '$hash' AND [ip] = '$ip' AND [timestamp] >= DATEADD(minute,-50,GETDATE())  order by id desc ";
		$res = $this->db->Query($query);
		$hash_result = array();
		$hash_result = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC);		
		
		$text = "query ".$query." with hash=".$hash." returned ".print_r($hash_result,true);
		Log2File($text,$f_name);	
	
		//save session variables in session_variables
		if ($vars) {			
			$this->CreateSessionVariables($vars, $hash, $hash_result['id']);			
		} 
		return  $hash_result;
	}
	
	function Insert($values){
		$this->db->Insert('merchant_session',$values);
	}
	
	function CreateSessionVariables($vars, $hash, $session_id = 0){
		if (!$session_id) {
			$query = "SELECT id FROM [globa].[dbo].[merchant_session] WHERE hash = '$hash'";
			$res = $this->db->Query($query);
			$row = sqlsrv_fetch_array( $res, SQLSRV_FETCH_ASSOC) ;
			$session_id = $row['id'];
		}
		if (is_array($vars) && sizeof($vars) > 0 && $session_id) {
			$query = $this->CreateInsertQueryStr($session_id, $vars);
			$res = $this->db->Query($query);
			return $res;
		} else {
			return array();
		}
	}
	
	function CreateInsertQueryStr($session_id, $vars){
	
		//izveido insert query string no masiva
		//rekursiivi iziet cauri xml strukturai, ja $vars ir xml masivs

		$query = "";
		foreach ($vars as $key => $value) {

			if (is_array($value) && sizeof($value) > 0) {
				$query .= $this->CreateInsertQueryStr($session_id, $value);
			}else{
				$query .= "INSERT INTO [globa].[dbo].[session_variables] ([session_id], [key], [value]) VALUES ($session_id, '$key', '".$this->db->MsEscapeString($value)."');";
			}
		}
		return $query;
	}
	
	function CreatePhpSession_0($rez_id , $summa, $desc, $trans_uid) {
	
		//dim $query,$result,$db,$datetime,$ip,$salt,$hash;
		$datetime = date("h:i:s A",time());
		$ip = $_SERVER["REMOTE_HOST"];
		$salt = "ms410a"; 

		$random_float = mt_rand() / mt_getrandmax();
		$hash =  sha1( $salt.$datetime.$ip.$random_float);
		$date = new DateTime();
		$date->setTimezone(new DateTimeZone('Europe/Riga'));	
		$formated_date = $date->format('Y-m-d H:i:s');
		$values = array('hash' => $hash,
						'ip' => $ip,
						'rez_id' => $rez_id,
						'summa' => $summa,
						'description' => $desc,
						'timestamp' => $formated_date,
						'trans_uid' => $trans_uid
						);
		$this->db->Insert('merchant_session',$values);
		
		return  $hash;
	}

	
	

	

}
?>