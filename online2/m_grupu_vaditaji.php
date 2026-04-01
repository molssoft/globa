<?
class GrupuVaditaji{
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		require_once($path.'m_init.php');
		$this->db = new Db();
	}
	
	public function ensure_dalibn_link($idnum){
		$vad = $this->get_by_idnum($idnum);
		if (count($vad)==0)
			return 0;
		
		if (!$vad['did']){
			$data = array();
			$data['vards'] = $vad['vards'];
			$data['uzvards'] = $vad['uzvards'];
			$data['piezimes'] = 'GRUPU VADĪTĀJS';
			$did = $this->db->insert('dalibn',$data,true);
			$this->db->Query("UPDATE grupu_vaditaji set did = $did where idnum=$idnum");
		} else {
			$did = $vad['did'];
		}
		
		$dalibn = $this->db->get_by_id('dalibn',$did);
		if ($dalibn['deleted'])
			return 0;
		else
			return $did;
		
	}
	
	public function GrafiksMenesim($y,$m){
		$days_in_month = date('t',strtotime($y."-".$m."-"."01"));
		$grafiks = array();
		$vaditaji = $this->GetAll();
		foreach($vaditaji as $vad){
			for ($d=1;$d<=$days_in_month;$d++){
				//$grafiks[$vad['vards'].' '.$vad['uzvards']][$d] = 0;
				$grafiks[$vad['idnum']."_".$vad['vards']." ".$vad['uzvards']][$d] = 0;
			}
		}
		
		$qry = "select * from grupa  
		where  atcelta = 0 and (vaditajs<>0 or vaditajs2<>0) 
		and (
			(beigu_dat >= '$m/1/$y' and beigu_dat<='$m/$days_in_month/$y')
			or (sakuma_dat >= '$m/1/$y' and sakuma_dat<='$m/$days_in_month/$y')
		)";
		//echo $qry;
		$result = $this->db->Query($qry);
		
		while( $grupa = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$sakuma_dat = date_timestamp_get ($grupa['sakuma_dat']);
			$beigu_dat = date_timestamp_get ($grupa['beigu_dat']);
			//var_dump($sakuma_dat);
			foreach($grafiks as $vaditajs=>$vad_row){
				$tmp = explode("_",$vaditajs);
				$idnum = $tmp[0];
				$vad_nos = $tmp[1];
				//var_dump($idnum);
				foreach ($vad_row as $diena=>$aiznemts){
					
					$datums = strtotime($y."-".$m."-".$diena);
					
					if (($grupa['vaditajs'] == $idnum or $grupa['vaditajs2'] == $idnum) and $datums>=$sakuma_dat and $datums<=$beigu_dat){
						$grafiks[$vaditajs][$diena] = $grupa['ID']."_".$grupa['kods'].' '.$this->db->Date2Str($grupa['sakuma_dat']).' '.$grupa['v'];//;
					}
				}
			}
			
		}
		
		return $grafiks;
	}
	
	public function GetAll(){
		$qry = "select gv.* 
			,(select vards + ' ' + uzvards from dalibn d where d.id = gv.did and deleted = 0) as globa_vards
			from grupu_vaditaji gv where deleted=0 order by vards, uzvards";
		$result = $this->db->Query($qry);
		$data = array();
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;		
		}
		return $data;
	}
	
	public function Delete($idnum)
	{
		$query = "UPDATE grupu_vaditaji SET deleted=1 where idnum = " .$idnum;
		$this->db->Query($query);
	}
	
	public function Add($id,$name,$lastname,$did)
	{
		$table = "grupu_vaditaji";
		$values = array(
		"id" => $id,
		"vards" => $name,
		"uzvards" => $lastname,
		"did" => $did,
		);
		$this->db->Insert($table,$values);
	}
	
	public function get_by_idnum($id){
		$query = "select * from grupu_vaditaji where idnum = ? and deleted = 0 order by vards, uzvards";
		$params = array($id);
		$result = $this->db->Query($query,$params);
		$data = array();
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;		
		}
		return $data[0];
	}
	
	public function GetById($idnum)
	{
		$query = "select * from grupu_vaditaji where idnum = ? order by vards, uzvards";
		$params = array($idnum);
		$result = $this->db->Query($query,$params);
		$data = array();
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;		
		}
		return $data;
	}
	
	public function IsFree($vad,$gid,$dat1,$dat2)
	{
		$query = "select izbr_laiks,iebr_laiks, * from grupa
			where 
			id <> $gid
			and vaditajs = $vad
			and izbr_laiks <= '$dat2'
			and iebr_laiks >= '$dat1'";
		
		$result = $this->db->Query($query,array());
		$data = array();
		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			$data[] = $row;		
		}
		
		if (count($data)==0)
			return true;
		else
			return false;
	}

	public function Update($idnum,$id,$name,$lastname,$did)
	{
		$table = "grupu_vaditaji";
		$values = array(
		"id" => $id,
		"vards" => $name,
		"uzvards" => $lastname,
		"did" => $did,
		);
		$this->db->UpdateGrupuVaditaji($table,$values,$idnum);
	}
}
?>