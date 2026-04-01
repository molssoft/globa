<?
class Valstis {
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';

		require_once($path.'m_init.php');
		$this->db = new Db;	
	}
	

	function GetId($id){
		$query = "SELECT 
            * 
            ,(
            select count(*) 
            from portal.dbo.Geo_marsruti gm
            join portal.dbo.Marsruti m on gm.marsruts = m.ID
            join portal.dbo.Grupas g on g.marsruts = m.ID
            join globa.dbo.grupa gg on gg.kods = g.gr_kods
            where 
                gm.geo = ge.ID
                and gg.internets = 1
                and gg.sakuma_dat > getdate()
            ) as aktivi
            FROM portal.dbo.geo ge WHERE id='".$id."'";
		$params = array($id);
		
		$result = $this->db->Query($query,$params);
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}
	}
	
    function GetAll(){
        $query = "SELECT 
            *
           ,(
            select count(*) 
            from portal.dbo.Geo_marsruti gm
            join portal.dbo.Marsruti m on gm.marsruts = m.ID
            join portal.dbo.Grupas g on g.marsruts = m.ID
            join globa.dbo.grupa gg on gg.kods = g.gr_kods
            where 
                gm.geo = ge.ID
                and gg.internets = 1
                and gg.sakuma_dat > getdate()
            ) as aktivi
            FROM portal.dbo.geo ge where type_id = 'V'";
        $params = array();

        return $this->db->query_array($query,$params);
    }

	function Update($data){
		$table = "portal.dbo.geo";
		$values = array(
            "slug" => $data["slug"],
            "meta_desc" => $data["meta_desc"]
		);

		$this->db->Update($table,$values,$data["id"]);
	}
}
?>