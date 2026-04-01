<?
class WebMeklesanaLog {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db;	
	}
	
	//atslēgas vārdu meklējumi un atrasto grupu skaits
	function Get($count = false,$datums_no = false,$datums_lidz = false){
	 
		if ($count){
			$query = "SELECT TOP $count *  FROM web_meklesana_log
					WHERE LEN(atslegas_vardi)>0 AND atslegas_vardi<>'0'
					ORDER BY datums DESC
					";
		}
		else{
			$where = "";
			if (!empty($datums_no)){
				$datums_no = date("Y-m-d 00:00:00",strtotime($datums_no));
				$where .= " AND datums>='$datums_no' ";
			}
			if (!empty($datums_lidz)){
				$datums_lidz = date("Y-m-d 23:59:59",strtotime($datums_lidz));
				$where .= " AND datums<='$datums_lidz' ";
			}
			if (!empty($where)){
				$query = "SELECT *  FROM web_meklesana_log
					WHERE LEN(atslegas_vardi)>0
					$where
					ORDER BY datums DESC";
			}
			else{
				$query = "SELECT TOP 200 *  FROM web_meklesana_log
					WHERE LEN(atslegas_vardi)>0
					ORDER BY datums DESC
					";
			}
			
		}
		
		//echo $query;
		$result = $this->db->Query($query);
			
		$data = array();
		$prev_sesijas_id = '';
		$prev_atrastas_grupas = '';
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			if ($row['sesijas_id'] != $prev_sesijas_id && $row['atrastas_grupas'] != $prev_atrastas_grupas){
					$data[] = $row;	
			}
			$prev_sesijas_id = $row['sesijas_id'];
			$prev_atrastas_grupas = $row['atrastas_grupas'];
				
		}
		return $data;
	}
	//biežāk meklētie atslēgas vārdi
	function GetTOPKeywords($datums_no,$datums_lidz){
	 
		$datums_no = date("Y-m-d 00:00:00",strtotime($datums_no));
		$datums_lidz = date("Y-m-d 23:59:59",strtotime($datums_lidz));
		$query = "SELECT t.atslegas_vardi,COUNT(*) as skaits FROM
						(SELECT DISTINCT atslegas_vardi,ip 
						FROM web_meklesana_log
						WHERE atslegas_vardi IS NOT NULL AND atslegas_vardi<>'0' AND LEN(atslegas_vardi)>0
						AND datums>='$datums_no'
						AND datums<='$datums_lidz') t
						GROUP BY t.atslegas_vardi						
					  ORDER BY skaits DESC";
		
			
		//echo $query;
		//$params = array(date("Y-m-d",strtotime($datums_no)),date("Y-m-d",strtotime($datums_lidz)));
		//echo $query;
		$result = $this->db->Query($query);
			
		$data = array();
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;
				
		}
		return $data;
	}
	
	
	//biežāk meklētās valstis
	function GetTOPValstis($datums_no,$datums_lidz){
	 
		$datums_no = date("Y-m-d 00:00:00",strtotime($datums_no));
		$datums_lidz = date("Y-m-d 23:59:59",strtotime($datums_lidz));
		$query = "SELECT t.valstis,COUNT(*) as skaits FROM
						(SELECT DISTINCT valstis,ip 
						FROM web_meklesana_log
						WHERE valstis IS NOT NULL 
						AND datums>='$datums_no'
						AND datums<='$datums_lidz') t
						GROUP BY t.valstis						
					  ORDER BY skaits DESC";
		
			
		//echo $query;
		//$params = array(date("Y-m-d",strtotime($datums_no)),date("Y-m-d",strtotime($datums_lidz)));
		//echo $query;
		$result = $this->db->Query($query);
			
		$data = array();
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;
				
		}
		return $data;
	}
	
	//biežāk meklētie reģioni
	function GetTOPRegioni($datums_no,$datums_lidz){
	 
		$datums_no = date("Y-m-d 00:00:00",strtotime($datums_no));
		$datums_lidz = date("Y-m-d 23:59:59",strtotime($datums_lidz));
		$query = "SELECT t.regions,COUNT(*) as skaits FROM
						(SELECT DISTINCT regions,ip 
						FROM web_meklesana_log
						WHERE regions IS NOT NULL AND regions<>'0' AND LEN(regions)>0
						AND datums>='$datums_no'
						AND datums<='$datums_lidz') t
						GROUP BY t.regions					
					  ORDER BY skaits DESC";
		
			
		//echo $query;
		//$params = array(date("Y-m-d",strtotime($datums_no)),date("Y-m-d",strtotime($datums_lidz)));
		//echo $query;
		$result = $this->db->Query($query);
			
		$data = array();
		
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			
			$data[] = $row;
				
		}
		return $data;
	}
}
?>