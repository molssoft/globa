<?
class PietAtsk {
	var $db;
	var $pid0;
	var $ord0;
	var $grupa_no;
	var $grupa_lidz;
	
	public function __construct($pid0,$ord0,$grupa_no,$grupa_lidz) { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db;
		$this->pid0 = $pid0;
		$this->ord0 = $ord0;
		$this->grupa_no = $grupa_no;
		$this->grupa_lidz = $grupa_lidz;
	
	}
	
	public function Create($pid,$ord){
		/*echo $pid;
		echo "<br>";
		echo $ord;
		echo "<br>";*/
		$this->db->Query("delete from pid_tmp");
		$this->db->Query("insert into pid_tmp (pid) ".$pid);
		$this->db->Query("delete from ord_tmp");
		$this->db->Query("insert into ord_tmp (oid) ".$ord);			
	}
	
	public function GetGsk(){
		$qry = "select isnull(count(distinct p0.gid),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)";
		$result = $this->db->Query($qry);			
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row[0];			
		}		
	}
	
	public function GetPsk(){
		$qry = "select isnull(count(distinct p0.id),0) from pieteikums p0 where p0.id in (select pid from pid_tmp)";
		$result = $this->db->Query($qry);			
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row[0];			
		}		
	}
	
	public function GetPsm(){
		$qry = "select Sum(isnull(p0.summaEUR,0)) - Sum(isnull(p0.atlaidesEUR,0)) + Sum(isnull(p0.sadardzinEUR,0)) from pieteikums p0 where p0.id in (select pid from pid_tmp)";
		$result = $this->db->Query($qry);			
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row[0];			
		}		
	}
	
	public function GetOsk(){
		$qry = "select isnull(count(distinct o0.id),0) from orderis o0 where o0.id in (select oid from ord_tmp)";
		$result = $this->db->Query($qry);			
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row[0];			
		}		
	}
	
	public function GetOsmPlus(){
		$qry = "select isnull(sum(o0.summa),0) from orderis o0 where o0.pid in (select pid from pid_tmp) and o0.id in (select oid from ord_tmp)";
		$result = $this->db->Query($qry);			
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row[0];			
		}		
	}
	
	public function GetOsmMinus(){
		$qry = "select isnull(sum(o0.summa),0) from orderis o0 where o0.nopid in (select pid from pid_tmp) and o0.id in (select oid from ord_tmp)";
		$result = $this->db->Query($qry);			
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row[0];			
		}		
	}
	
	public function GetTd($pid,$ord){
		$this->Create($pid,$ord);
			
		$gsk = $this->GetGsk();
		$psk = $this->GetPsk();
		$psm = $this->GetPsm();
		$osk = $this->GetOsk();
		$osm_plus = $this->GetOsmPlus();
		$osm_minus = $this->GetOsmMinus();		
		$td ='<td align=center>'.$gsk
		.'<BR>'.$psk
		.'<BR>'.$osk
		.'<BR>'.($osm_plus - $osm_minus)
		.'<BR>'.($psm)
		.'<BR>'
		.'</td>';
		return $td;
	}
	
	public function KompleksieData(){
		$pid = $this->pid0 . " and p.gid in (select kompleks from parametri) ";
		$pid_all = "select pa.id from pieteikums pa where pa.gid in (select kompleks from parametri) ";	
		
		if ($this->grupa_no){
			$pid .=  " and isnull(sakuma_datums,time_stamp) >= '".date("Y-m-d",$this->grupa_no)."'";
		}
		if ($this->grupa_lidz){
			$pid .=  " and isnull(sakuma_datums,time_stamp) <= '".date("Y-m-d",$this->grupa_lidz)." 23:59'";
		}
		$ord = $this->ord0 . " and (o.pid in (" . $pid . ") or o.nopid in ("  . $pid ."))";
		
		$td = $this->GetTd($pid,$ord);		
		return $td;
	}
	
	public function CarteriData(){
		$pid = $this->pid0 . " and p.gid in (select charter from parametri) ";				
		
		if ($this->grupa_no){
			$pid .=  " and isnull(sakuma_datums,time_stamp) >= '".date("Y-m-d",$this->grupa_no)."'";
		}
		if ($this->grupa_lidz){
			$pid .=  " and isnull(sakuma_datums,time_stamp) <= '".date("Y-m-d",$this->grupa_lidz)." 23:59'";
		}
		$ord = $this->ord0 . " and (o.pid in (" . $pid . ") or o.nopid in ("  . $pid ."))";

		
		$td = $this->GetTd($pid,$ord);		
		return $td;
	}
	
	public function VaktasData(){
		$pid = $this->pid0. " and p.gid in (select id from grupa where kods like '__.V.%' ";
		$pid_all = "select pa.id from pieteikums pa where pa.gid in (select id from grupa where kods like '__.V.%') ";
		$ord = $this->ord0 . " and (o.pid in (" . $pid_all . ") or o.nopid in (" . $pid_all . "))";			
		
		if ($this->grupa_no){
			$pid .=  " and beigu_dat >= '".date("Y-m-d",$this->grupa_no)."'";
		}
		if ($this->grupa_lidz){
			$pid .=  " and beigu_dat <= '".date("Y-m-d",$this->grupa_lidz)." 23:59'";
		}
		$pid = $pid . ")";
		
		
		$td = $this->GetTd($pid,$ord);		
		return $td;
	}
	
	
	
	
	
	
	
}