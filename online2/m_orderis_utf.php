<?php
class Orderis {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init_utf.php');
		$this->db = new Db;	
	}
	
	function GetSummasOnlineRez($online_rez_id){
		require_once("m_pieteikums_utf.php");
		$piet = new Pieteikums();
		$pieteikumi = $piet->GetPietOnlineRez($online_rez_id);
		$maksajumi = array ('iemakats' => 0,
							'izmaksats' => 0);
		$iem_valuta = '';
		$izm_valuta = '';
		if (DEBUG){
			echo "<br>!!!pieteikumi:<br>";
			var_dump($pieteikumi);
			echo "<br><br>";
		}
		foreach ($pieteikumi as $pieteikums){
			$pid = $pieteikums['id'];
			$query = "SELECT valuta.val as valuta, SUM(summaval) as summa FROM orderis 
						LEFT JOIN valuta ON orderis.valuta = valuta.id
						WHERE pid=? AND deleted=0 AND parbaude=0 GROUP BY valuta.val";
			$params = array($pid);
			
			$result = $this->db->Query($query,$params);
			if (DEBUG){
				echo $query."<br>";
				var_dump($params);
				
			}
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				//print_r($row);
				$maksajumi['iemaksats'] +=  $row['summa'];	
					$iem_valuta = $row['valuta'];
			}
			$query = "SELECT valuta.val as valuta, SUM(summaval) as summa FROM orderis 
						LEFT JOIN valuta ON orderis.valuta = valuta.id
						WHERE nopid=? AND deleted=0 AND parbaude=0 GROUP BY valuta.val";
			$params = array($pid);
			
			$result = $this->db->Query($query,$params);
			
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				$maksajumi['izmaksats'] +=  $row['summa'];
				$izm_valuta = $row['valuta'];				
			}
		}
		require_once("i_functions.php");
		if ($iem_valuta == $izm_valuta){
			$maksajumi['bilance'] = $maksajumi['iemaksats'] - $maksajumi['izmaksats'];
			$maksajumi['bilance'] = CurrPrint($maksajumi['bilance']).' '. $iem_valuta;			
		}
		else
			$maksajumi['bilance'] = '?';
		
		$maksajumi['iemaksats']  = CurrPrint($maksajumi['iemaksats']).' '. $iem_valuta;
		$maksajumi['izmaksats'] = CurrPrint($maksajumi['izmaksats']).' '. $izm_valuta;
		return $maksajumi;
	
		//$query = "SELECT id FROM pieteikums WHERE "
	}

	/**
	 * Latest incoming payment date for a pieteikums: MAX(orderis.datums) where pid = pieteikums.id.
	 *
	 * @param int $pid pieteikums.id
	 * @return mixed SQL Server datetime value (often a DateTime from sqlsrv), or null if none / error
	 */
	function GetLatestPaymentDatums($pid) {
		$pid = (int)$pid;
		if ($pid <= 0) {
			return null;
		}
		$query = "SELECT MAX(datums) AS mx FROM orderis WHERE pid = ? AND deleted = 0";
		$result = $this->db->Query($query, array($pid));
		if ($result === false) {
			return null;
		}
		$row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC);
		if (empty($row) || !array_key_exists('mx', $row) || $row['mx'] === null) {
			return null;
		}
		return $row['mx'];
	}

	
	function Confirm($id){
		$this->db->Update('orderis',array('parbaude'=>0),$id);
		$this->db->LogAction('orderis',$id,'Apstiprinja');
		
	}
	
	
	

}
?>