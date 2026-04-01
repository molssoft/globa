<?
class Anketas {
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
	
	//saglabâ jaunu anketu
	function Insert($values){
		$values = $this->PrepareDataForInsert($values);
		$this->db->Insert('globa.dbo.anketas',$values);
	}
	
	function PrepareDataForInsert($data){
		$data['izveles_iemesls'] = implode('|',$data['izveles_iemesls']);
		$data['avots'] = implode('|',$data['avots']);
		$data['socialais_konts'] = implode('|',$data['socialais_konts']);
		$data['grib_aizbraukt'] = implode('|',$data['grib_aizbraukt']);
		
		foreach($data as $key=>$val){
			$data[$key] = $this->db->MsEscapeString($val);
		}
		return $data;
	}
	
	function GetByGid($gid){
		$qry = "SELECT * FROM anketas WHERE gid = ? AND isnull(spams,0)<>1 ORDER BY datums DESC";
		$params = array($gid);
		$result = $this->db->Query($qry,$params);
		$data = array();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;
		}
		return $data;
	}
	
	function PrintMultiAnswers($str){
	
			$arr = explode("|",$str);			
			$str = implode(", ",array_filter($arr));
			return $str;
		
	}
	
	function GetAverage($field,$gid){
		$qry = "select avg($field) as vid from anketas where not $field is null and gid = ? AND isnull(spams,0)<>1";
		$params = array($gid);
		$result = $this->db->Query($qry,$params);
		$avg = false;
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$avg = $row['vid'];
		}
		return round($avg);
	}
}
?>