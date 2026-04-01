<?
class Skatijumi {
	var $db;
	var $path;

	public function __construct() { 
		if (defined("PATH_TO_FILES")){
			
			$this->path =PATH_TO_FILES;
		}
		else $this->path = '';
		//echo $path.'m_init.php';
		require_once($this->path.'m_init.php');
		$this->db = new Db;	
		
	}
	function Insert($gid,$ip){
		$qry = "INSERT INTO globa.dbo.skatijumi (gid,ip,datums) VALUES (?,?,GETDATE())";
		$params = array($gid,$ip);
		$this->db->Query($qry,$params);
	}
	
	//atgriež šīs dienas grupas info skatījumos pēc ip adreses
	function GetByIpToday($gid,$ip){
		$start_of_day = date("Y-m-d 00:00:00");
		$qry = "SELECT * FROM globa.dbo.skatijumi WHERE ip=? AND gid=? AND datums>='$start_of_day'";
		$params = array($ip,$gid);
		$result = $this->db->Query($qry,$params);
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		return $row;
	}
	
	//atgriež skatījumu skaitu konkrētai grupai
	function GetCountById($gid){
		$qry = "SELECT COUNT(id) as skaits FROM skatijumi WHERE gid=?";
		$params = array($gid);
		$result = $this->db->Query($qry,$params);
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);		
		return $row['skaits'];
		
	}
	
	//atgriež top skatītākās grupas datumu intervālā
	function GetTOPGroups($start_date,$end_date){
	
		require_once("m_grupa.php");
		$gr = new Grupa();
		
		/*((from log in dc.GetTable<skatijumi>()
                  where log.datums >= startDateTime && log.datums <= endDateTime
                  select new { log.gid, log.ip }).Distinct()).GroupBy(x=> x.gid).Select(group => new
                  {
                      gid = group.Key,
                      Count = group.Count()
                  }).OrderByDescending(t => t.Count).Take(limit);*/
		$qry = "SELECT t.gid,COUNT(*) as skaits FROM 
				(SELECT DISTINCT gid,ip FROM skatijumi WHERE datums>=? AND datums <=?)
				t
				GROUP BY t.gid
				ORDER BY skaits DESC";
		$params = array(date("Y-m-d",strtotime($start_date)),date("Y-m-d",strtotime($end_date)));
		$result = $this->db->Query($qry,$params);
		$data = array();
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC)){
			$row['grupa'] = $gr->GetId($row['gid']);
			$data[] = $row;
		}	
		return $data;
		
	}
}
	?>