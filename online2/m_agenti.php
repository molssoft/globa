<?
class Agenti{
	
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		require_once($path.'m_init.php');
		$this->db = new Db();
	}
	
	function GetActive(){
		$query = "Select *,(select count(id) from lietotaji where aid = agenti.id) as lsk from agenti where aktivs = 1 ORDER BY pilseta,vards";
		$result = $this->db->Query($query);
		$data = array();
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;		
		}
		return $data;
	}
	
	function GetNonActive(){
		$query = "Select *,(select count(id) from lietotaji where aid = agenti.id) as lsk from agenti where aktivs = 0 ORDER BY pilseta,vards";
		$result = $this->db->Query($query);
		$data = array();
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;		
		}
		return $data;
	}
	
	function GetById($id){
		$query = "Select *,(select count(id) from lietotaji where aid = agenti.id) as lsk from agenti where id = ? ORDER BY pilseta,vards";
		$params = array($id);
		$result = $this->db->Query($query, $params);
		
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}
		
	}
	
	function Delete($id){
		$query = "Delete from agenti where id = ?";
		$params = array($id);
		$this->db->Query($query, $params);
	}
	
	function Update($data){
		$active;
		if($data["aktivs"] == "on")
		{
			$active = 1;
		}
		else{
			$active = 0;
		}
		$table = "agenti";
		$values = array(
		"aktivs" => $active,
		"pilseta" => $data["pilseta"],
		"vards" => $data["vards"],
		"dkonts" => $data["dkonts"],
		"ckonts" => $data["ckonts"]
		);
		$this->db->Update($table,$values,$data["id"]);
	}
	
	function Add($data){
		$table = "agenti";
		$this->db->Insert($table,$data);
	}
	function UpdateLigumaInfo($id,$data){
		$table = "agenti";
		$this->db->Update($table,$data,$id);
	}
	
	function GetStat($qry){
	
		$result = $this->db->Query($qry);
	
		$data = array();
			
		$IemaksatsLVL = 0;
		$IemaksatsEUR = 0;
		$IemaksatsUSD = 0;
	
		$SummaLVL = 0;
		$SummaUSD = 0;
		$SummaEUR= 0;	
	
		$AprekinatsLVL = 0;
		$AprekinatsUSD = 0;
		$AprekinatsEUR = 0;
		
		$s=0;
		$agentaVards = "";
		$records = array();
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
	
			$s++;
			$qry = "select max(CAST(zils AS INT)) as zils from orderis where deleted = 0 and pid = ?";
			$params = array($row['id']);
			$resultIemaks = $this->db->Query($qry,$params);			
			//$row['iemaks'] = sqlsrv_has_rows($resultIemaks);
			if ($rowIemaks = sqlsrv_fetch_array( $resultIemaks, SQLSRV_FETCH_ASSOC)){
				$row['iemaks'] = $rowIemaks;
			}
			
			$qry = "select sum(summaLVL) as LVL, sum(summaUSD) as USD, sum(summaEUR) as EUR from piet_starpnieciba where pid = ?";
			$params = array($row['id']);
			$resultStarp = $this->db->Query($qry,$params);
			$row['starp'] = array();
			if ($rowStarp = sqlsrv_fetch_array( $resultStarp, SQLSRV_FETCH_ASSOC)){
				$row['starp'] = $rowStarp;
			}
		
			$IemaksatsLVL = $IemaksatsLVL + $row["iemaksasLVL"]-$row["izmaksasLVL"];
			$IemaksatsUSD += $row["iemaksasUSD"]-$row["izmaksasUSD"];
			$IemaksatsEUR += $row["iemaksasEUR"]-$row["izmaksasEUR"];
			$SummaLVL += $row["summaLVL"];
			$SummaUSD += $row["summaUSD"];
			$SummaEUR += $row["summaEUR"];
			$AprekinatsLVL += $row['starp']["LVL"];
			$AprekinatsUSD += $row['starp']["USD"];
			$AprekinatsEUR += $row['starp']["EUR"];
			
			
			$agentaVards = $row['vards'];
			$records[] = $row;
		}
		$data['records'] = $records;
		$data['recordCount'] = $s;
		$data['agentaVards'] = $agentaVards; 
		$kopsummas = array();
		$kopsummas['IemaksatsLVL'] = $IemaksatsLVL;
		$kopsummas['IemaksatsUSD'] = $IemaksatsUSD;
		$kopsummas['IemaksatsEUR'] = $IemaksatsEUR;
		$kopsummas['SummaLVL'] = $SummaLVL;
		$kopsummas['SummaUSD'] = $SummaUSD;
		$kopsummas['SummaEUR'] = $SummaEUR;
		$kopsummas['AprekinatsLVL'] = $AprekinatsLVL;
		$kopsummas['AprekinatsUSD'] = $AprekinatsUSD;
		$kopsummas['AprekinatsEUR'] = $AprekinatsEUR;
		$data['kopsummas'] = $kopsummas;
			
	
		return $data;
	}
	
	function GetStatLimited($agents,$no,$lidz,$zilie,$orderfield = false,$currPage = false,$limit = false){
		$select = "sakuma_dat, pieteikums.agents, pieteikums.datums as piet_datums, agenti.vards, pieteikums.id, pieteikums.info, summaLVL, summaUSD, summaEUR, iemaksasLVL, iemaksasUSD, iemaksasEUR, izmaksasLVL, izmaksasUSD, izmaksasEUR, krasa,isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums)) as datums 
			";
		$where = "pieteikums.deleted <> 1 and gid <> 0 ";
		if ($agents!="" and $agents<>"0"){
			$agents=" and agenti.id=".$agents." ";
		}
		elseif ($agents == "0"){
			$agents=" and isnull(agents,0)=0 ";
		}
		else{
			 $agents = " and isnull(agents, 0)<>0 ";
		}
		//ceļojuma sākuma datuma filtrs
		$datanolidz = "";
		if (!empty($lidz)){
			$datanolidz .= " and isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))<='".date("Y-m-d",strtotime($lidz)). "' ";
		}
		if (!empty($no)){
			$datanolidz .= " and isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))>='".date("Y-m-d",strtotime($no))."' ";
		}
		if ($zilie == "zilie"){
			$zilie = " and pieteikums.id in (select pid from orderis where zils = '1' and deleted<>'1')";
		}elseif($zilie == "nezilie"){
			$zilie = " and pieteikums.id not in (select pid from orderis where zils = '1' and deleted<>'1')";
		}elseif ($zilie=='visizilie'){
			$zilie = " and pieteikums.id in (select pid from orderis where zils = '1')";
		}
		else{
			 $zilie = "";
		}
	
		$where .= $agents.$datanolidz.$zilie;
		$order = ($orderfield ? $orderfield : "isnull(sakuma_dat,isnull(pieteikums.sakuma_datums,pieteikums.datums))");
	 
		$offset =($currPage-1)*$limit; 


		$tables = "pieteikums LEFT JOIN grupa ON pieteikums.gid = grupa.id LEFT JOIN agenti ON pieteikums.agents = agenti.id ";		
		
		$query = "SELECT $select FROM $tables WHERE $where";
		//echo $query;
		
		$data = array();
		$data['rowcount'] = $this->db->GetQryCount($query);
		$data['first_row'] = intval($offset)+1;

		$data['last_row'] = intval($offset+$limit);
	
		if ($data['rowcount'] < $data['last_row'])
			$data['last_row'] = $data['rowcount'];
		//var_dump($rowcount);
		//echo "<<<<< <br><br>";
		$qry = $this->db->offset($offset, $limit, $select, $tables, $order, $where);
		//echo $qry."<br><br>";
		
	
		$data = array_merge($this->GetStat($qry),$data);
		return $data;	
		
	}
	
	
	
}
?>