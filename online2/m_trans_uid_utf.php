<?
class TransUid {
	var $db;
	
	public function __construct() { 
		require_once('m_init_utf.php');
		$this->db = new Db;
	
	}
	
	function GetId($id){
		$query = "SELECT * FROM trans_uid WHERE ID=?";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}		
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
			
		}		
	}
	
	function Save($rez_id, $user_id, $s_post) {
	
		//--- saglabaa maksajumu summas starptabulaa
		//--- atgriez trans_id formaa: profileId_transId (20)

		require_once("i_functions.php");
		$temp_uid = GUID();
		
		$trans_id = substr($user_id."_".$temp_uid,0,19);
		if (DEBUG){
			echo "<br>S_POST<br>";
			var_dump($s_post);
			echo "<br><br>";
		}
		foreach ($s_post as $key=>$val){
			//if (substr($key,0,8)=="payment_") {
				
				$summa = $s_post[$key];
				//lai netaisītu nulles orderus
				if ($summa != '0.00'){
					//$str_array = explode("_",$key);
					//$pid = $str_array[1];
					$pid=$key;
					$values = array('trans_id' => $trans_id,
									'rez_id' => $rez_id,
									'pid' => $pid,
									'summa' => $summa);
					$this->db->Insert('trans_uid',$values);

				}
			//}
		}
 
		return  $trans_id;
	
	}


	

}
?>