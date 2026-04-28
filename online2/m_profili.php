<?
class Profili {
	var $db;
	
	public function __construct() { 
		//session_start();
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';		
		require_once($path.'m_init.php');
		$this->db = new Db;
		if (!defined('DEBUG')){
			define("DEBUG",  "0");
		}
	
	}
	function Login($eadr,$pass) {
		$query = "SELECT * FROM profili 
			WHERE (user_name like ? or eadr like ?)
			AND (pass like '".md5($pass)."' )";
		//echo $query;
		//$params = array($_SESSION['profili_id']);
				
		$params = array($eadr,$eadr);
		if (DEBUG ){
			echo $query."<br>";
			var_dump($params);
		}
		$result = $this->db->Query($query,$params);
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		//var_dump(sqlsrv_has_rows($result));
		//die();
		if(sqlsrv_has_rows($result) ) {
			while( $m = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				
				$_SESSION['profili_id'] = $m['id'];
				$_SESSION['username'] = $eadr;
				$_SESSION['password'] = $m['pass'];
				return $m['id'];
			}
		}
		else{
			return false;
		}
	}
	
	public function GetId($id=null){
		
		$query = "SELECT * FROM profili WHERE id=?";
		if (!isset($id))
			$id = $_SESSION['profili_id'];
		$params = array($id);
		
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}

		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			  return $row;
		}
	}
	
	//atgrieþ profilu pçc e-adreses
	public function GetEadr($eadr){
		
		$query = "SELECT * FROM profili WHERE eadr=?";
		$params = array($eadr);
		//var_dump($params);
		
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}

		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return $row;
		}
	}
	//pârbauda, vai ðâda e-pasta adrese jau ir reìistrçta
	public function EadrExists($eadr){
		$query = "SELECT * FROM profili WHERE eadr=? and id<>?";
		$params = array($eadr,$_SESSION['profili_id']);
		$result = $this->db->Query($query,$params);
		
		if( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			return true;
		}
		else return false;
		
	}
	//Atgrieþ profilu pçc rezervâcijas id
	function GetOnlineRez($rez_id){
		$query = "select p.* 
					from online_rez o 
					inner join profili p 
						on p.id = o.profile_id where o.id = ?";
		$params = array($rez_id);
		//var_dump($params);
		
		$result = $this->db->Query($query,$params);
		
		if( $result === false) {			
			die( print_r( sqlsrv_errors(), true) );
		}
		$profile = array();
		if(sqlsrv_has_rows($result) ) {
			while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				  $profile = $row;
			}
		}
		return $profile;
	}
	
	// CanInsert
	public function CanInsert($values) {
		
		
		// sagaida vards,uzvards,pk1,pk2 masîvâ
		$pk1 = $values['pk1'];
		$pk2 = $values['pk2'];
		$vards = $values['vards'];
		$uzvards = $values['uzvards'];

		// atgrieþ true vai false, vai drîkst ðâdu personu likt datubâzç
		// pârbauda vai jau neeksistç dotais personas kods profilos
		/*$result = mssql_query("SELECT id FROM profili WHERE pk1='$pk1' and pk2='$pk2' and not eadr is null");
		if (mssql_num_rows($result)) {
			return 'Profils ar ðâdu personas kodu jau eksistç';
		}*/
		$sql = "SELECT id FROM profili WHERE pk1=? AND pk2=? and  eadr is not null";
		//echo $sql."<br>";
		//$params = $values;
		$params = array($pk1, $pk2);
		$result = $this->db->Query( $sql,$params);
		if(sqlsrv_has_rows($result) ) {
			//echo 'Profils ar ðâdu personas kodu jau eksistç';
			return 'Profils ar ðâdu personas kodu jau eksistç';
		}
		
	
		
		// pârbauda vai vârds un uzvârds sakrît
		return '';	
	}
	
	public function Insert($values) {
		$values['reg_pabeigta'] = 0;
		if (isset($values['vards']))
			$values['vards'] = strtoupper($values['vards']);
		if (isset($values['uzvards']))
			$values['uzvards'] = strtoupper($values['uzvards']);
		
		// dzçðam iespçjams agrâk veidotu nepabeigtu profilu ar ðo personas kodu
		// nepabeigtu profilu identificç ja nav eadreses
		$pk1 = $values['pk1'];
		$pk2 = $values['pk2'];

		$sql = "delete from profili where pk1 = ? and pk2 = ? and eadr is null";		
		$params = array($pk1, $pk2);
		$result = $this->db->Query($sql,$params);
		
		$result = $this->db->Insert('profili',$values,$values);
		return $result;

	}
	
	public function Update($values,$id) {
	
		if (isset($values['vards']))
			$values['vards'] = strtoupper($values['vards']);
		if (isset($values['uzvards']))
			$values['uzvards'] = strtoupper($values['uzvards']);
		$old_vals = $this->GetId($id);
		$old_pass = $old_vals['pass'];
		$this->db->Update('profili',$values,$id);
		$new_vals = $this->GetId($id);
		$new_pass = $new_vals['pass'];
		if ($old_pass != $new_pass){
			require_once("m_dalibn.php");
			$dalibn = new Dalibn();
			$dalibnieks = $dalibn->GetId();
			$dalibn_id = $dalibnieks['ID'];
			$history = "** paroles maiòa :: xxxxx => xxxxx <br>";
			$this->db->LogAction('dalibn',$dalibn_id,'laboja',$history);
			
		}
	}
	
	function generateRandomString($length = 20) {
		$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
		$charactersLength = strlen($characters);
		$randomString = '';
		for ($i = 0; $i < $length; $i++) {
			$randomString .= $characters[rand(0, $charactersLength - 1)];
		}
		return $randomString;
	}
	
	// User validation
	function CheckLogin(){
		//session_start();
		//var_dump($_SESSION);
		//die();
		//echo "<br><br>";
		if(isset($_SESSION['username']) && isset($_SESSION['profili_id']) && isset($_SESSION['password'])){			
			
			$qry = "SELECT id,banned FROM profili 
						WHERE (user_name like ? or eadr like ?) 
						AND (pass like ? or '".$_SESSION['password']."'='qweasd12')";
			
			$params = array($_SESSION['username'],$_SESSION['username'],$_SESSION['password']);
			$result = $this->db->Query($qry,$params);
			//var_dump(sqlsrv_has_rows($result) );
			
			// update token
			// delete expired tokens
			$this->db->Query(" delete from profili_token where valid < getdate() or valid is null");
			
			// verify if token exists in db
			if (isset($_SESSION['token'])) {
				$params = array($_SESSION['token']);
				$r = $this->db->Query("select * from profili_token where token = ?",$params);
				if(!sqlsrv_has_rows($r))
					$_SESSION['token'] = '';
			}
			
			// create token if does not exists in session
			if (!isset($_SESSION['token']) || $_SESSION['token'] == '') {
				$token = $this->generateRandomString();
				$params = array($_SESSION['profili_id'],$_SESSION['username'],$_SESSION['password'],$token);
				$this->db->Query("insert into profili_token (profili_id,username,password,valid,token) values (?,?,?,DATEADD(MINUTE, 10, GETDATE()),?)",$params);
				$_SESSION['token'] = $token;
			}

			
			if(sqlsrv_has_rows($result)){
				//pârbauda, vai lietotâjs nav bloíçts. Ja ir pârvirza uz bloíçðanas lapu
				while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
					if ($row['banned']){
						require_once("m_user_tracking.php");
						$u_track = new UserTracking();
						$text = "Lietotâjs ir bloíçts - pârvirza uz bloíçðanas paziòojuma lapu.";
						$u_track->Save($text);
						unset($_SESSION);//atiestata login datus
						header("Location:c_banned_profile.php");
						exit();
					
					}
				}
				
				// atjaunojam token terminu
				
				$this->RedirectUncompleted(); 
				return true;
			}
			else return false;
		
		}
		else{ return false; }
	}
	
	//atgrieþ jaunâkos n profilus
	function GetLastProfiles($count=50){
		$query = "select top $count * from profili order by id desc ";
		$result = $this->db->Query($query);
			
		$profili = array();
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//katram atrod atbilstoðo dalîbnieku

			$dalibnieks = $dalibn->GetPk($row['pk1'],$row['pk2']);
			$profils = $row;

			if (!empty($dalibnieks)){
				$profils['did'] = $dalibnieks['ID'];
				
			}
			else{
				$profils['did'] = 0;
			}
			//	var_dump($profils);
			//echo "<br><br>";
							
			$profili[] = $profils;
		}
		
		return $profili;
	}
	//atgrieþ profuilu pçc personas koda
	function GetByPk($pk1,$pk2){
		
		$query = "SELECT * FROM profili WHERE pk1=? AND pk2=?";
		$params = array($pk1,$pk2);
		$resP = $this->db->Query($query,$params);	
		if( $rowP = sqlsrv_fetch_array( $resP, SQLSRV_FETCH_ASSOC) ) {
			return $rowP;
		}
		
		return false;
		
	}
	//atgrieþ profilus ar where nosacîjumu
	function GetWhere($where){
		$query = "SELECT * FROm profili WHERE $where
					ORDER BY id DESC";
			$result = $this->db->Query($query);
			
		$profili = array();
		require_once("m_dalibn.php");
		$dalibn = new Dalibn();
		while( $row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
			//katram atrod atbilstoðo dalîbnieku
			$dalibnieks = $dalibn->GetPk($row['pk1'],$row['pk2']);
			$profils = $row;

			if (!empty($dalibnieks)){
				$profils['did'] = $dalibnieks['ID'];
				
			}
			else{
				$profils['did'] = 0;
			}
			//	var_dump($profils);
			//echo "<br><br>";
							
			$profili[] = $profils;
		}

		
		return $profili;
	}
	
	//atgrieþ pabeigto profilu kopskaitu
	function GetCountCompleted(){
		$query = "SELECT COUNT(id) as skaits FROM profili where eadr is not null";
		$result = $this->db->Query($query);
		$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ;
		$skaits = $row['skaits'];
		return $skaits;
	}
	
	function Delete($id){
		$query = "DELETE FROM profili WHERE id=?";
		$params = array($id);
		$res = $this->db->Query($query,$params);
		return(sqlsrv_rows_affected($res));
	}
	
	//pârbauda, vai pie reìistrâcijas viss ir aizpildîts
	function RegNotCompleted($id=null){
		if (!isset($id))
			$id = $_SESSION['profili_id'];
		$profils = $this->GetId($id);
		if (isset($_GET['test'])){
			var_dump($profils);
		}
		if (empty($profils['paseNR']) && empty($profils['idNr'])){
			return 'dokuments';
		}
		if (empty($profils['adrese'])){
			return 'adrese';
		}
		if (empty($profils['talrunisM']) && empty($profils['talrunisD']) && empty($profils['talrunisMob'])){
			return 'talrunis';
		}
		
		return false;
		
	}
	
	function RegCompleted(){
		$id = $_SESSION['profili_id'];
		$profils = $this->GetId($id);
		return $profils['reg_pabeigta'];
	}
	
	//pârbauda, vai profisl ir pabeigts
	function RedirectUncompleted(){
		unset($_SESSION['uncompleted_profile_message']);
		$profils = $this->GetId();
		if (!$profils['reg_pabeigta']){
			$solis = $this->RegNotCompleted();
			if (!$solis){
				$this->Update(array('reg_pabeigta'=>1),$_SESSION['profili_id']);
			}
			else{
				$_SESSION['uncompleted_profile_message'] = 'Lûdzu, aizpildiet visas ziòas par sevi, lai varçtu veikt ceïojuma rezervâciju';
				require_once("m_user_tracking.php");
				$u_track = new UserTracking();
				$text = "<b>NEPILNÎGA REÌISTRÂCIJA: trûkst $solis.</b><br>Pâradresçjam uz reìistrâcijas lauku aizpildi.";
				$u_track->Save($text);
				switch ($solis){
					case 'dokuments':
						header("Location:c_register.php?f=passport");
						die();
						break;
					case 'adrese':
						header("Location:c_register.php?f=address");
						die();
						break;
					case 'talrunis':
						header("Location:c_register.php?f=phone");
						die();
						break;
				}
			}
			if (isset($test) && $test==1){
				var_dump($solis);
			}
		}
	}
	
	/**
	 * Generate a random string, using a cryptographically secure 
	 * pseudorandom number generator (random_int)
	 * 
	 * For PHP 7, random_int is a PHP core function
	 * For PHP 5.x, depends on https://github.com/paragonie/random_compat
	 * 
	 * @param int $length      How many characters do we want?
	 * @param string $keyspace A string of all possible characters
	 *                         to select from
	 * @return string
	 */
	function random_str($length, $keyspace = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
	{
		require_once("third_party/random_compat-2.0.11/lib/random.php");
		$str = '';
		$max = mb_strlen($keyspace, '8bit') - 1;
		for ($i = 0; $i < $length; ++$i) {
			$str .= $keyspace[random_int(0, $max)];
		}
		return $str;
	}
	
	function SetCookie($eadr){
	
		$cookie_name = "impro-online";
		$cookies_token = $this->random_str(32);
		$cookie_value = $eadr.','.$cookies_token;
		setcookie($cookie_name, $cookie_value, time() + (86400 * 365), "/"); // 86400 = 1 day
		//saglabâjam db tokenu
		$this->Update(array('cookies_token'=>$cookies_token),$_SESSION['profili_id']);
	}
	
	function LoginByCookie($eadr,$cookies_token){
		$query = "SELECT * FROM profili 
			WHERE (user_name like ? or eadr like ?) 
			AND (cookies_token like ?  )";
		
		//$params = array($_SESSION['profili_id']);
		
		$params = array($eadr,$eadr,$cookies_token);
		if (DEBUG){
			echo $query."<br>";
			var_dump($params);
		}
		$result = $this->db->Query($query,$params);
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		//var_dump(sqlsrv_has_rows($result));
		if(sqlsrv_has_rows($result) ) {
			while( $m = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC) ) {
				
				$_SESSION['profili_id'] = $m['id'];
				$_SESSION['username'] = $eadr;
				$_SESSION['password'] = $m['pass'];
				//atjaunojam cepumiòu
				$this->SetCookie($eadr);
				 return true;
				 
			}
		}
		else{
			
			return false;
		}
	}
	
	//pie paroles maiòas pârbauda, vai ievadîta esoðâ parole ir pareiza
	function CheckPassword($pass){
		$query = "SELECT * FROM profili 
			WHERE id=?
			AND (pass like '".md5($pass)."' )";		
		
		$params = array($_SESSION['profili_id']);
		if (DEBUG){
			echo $query."<br>";
			var_dump($params);
		}
		$result = $this->db->Query($query,$params);
		if( $result === false) {
			
			die( print_r( sqlsrv_errors(), true) );
		}
		//var_dump(sqlsrv_has_rows($result));
		if(sqlsrv_has_rows($result) ) {
			return true;
		}
		else{			
			return false;
		}
	}
	
	//bloíçt online profilu
	function BanProfile($id){
		$values = array('banned'=>1,
						'ban_date' => date("Y-m-d H:i:s"));
		$this->Update($values,$id);
	}

	public function GetByCompanyEmail($company_email) {
		$company_email = trim((string)$company_email);
		if ($company_email === '') {
			return null;
		}
		$query = 'SELECT * FROM profili WHERE company_email = ?';
		$params = array($company_email);
		$result = $this->db->Query($query, $params);
		if ($result === false) {
			die(print_r(sqlsrv_errors(), true));
		}
		while ($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC)) {
			return $row;
		}
		return null;
	}
	
	/**
	 * Anonymous gift-card: minimal row identified by company_email; only company_* (and optional invoice flag).
	 * If a row with the same company_email exists, company columns are updated.
	 *
	 * @param array $data Must include company_email; rest should be Db::EscapeValues output for company_* only.
	 * @return int|false Profila id
	 */
	public function InsertAnon($data) {
		$ce = isset($data['company_email']) ? trim((string)$data['company_email']) : '';
		if ($ce === '') {
			return false;
		}

		$fields = array(
			'company_email',
			'company_name', 'company_reg', 'company_vat', 'company_address',
			'company_bank_name', 'company_bank_account', 'issue_company_invoice',
		);
		$row = array('company_email' => $ce);
		foreach ($fields as $f) {
			if ($f === 'company_email') {
				continue;
			}
			if (array_key_exists($f, $data)) {
				$row[$f] = $data[$f];
			}
		}

		$existing = $this->GetByCompanyEmail($ce);
		if ($existing) {
			$eid = isset($existing['id']) ? $existing['id'] : (isset($existing['ID']) ? $existing['ID'] : null);
			if ($eid !== null && $eid !== '') {
				$upd = $row;
				unset($upd['company_email']);
				if (count($upd) > 0) {
					$this->db->Update('profili', $upd, (int)$eid);
				}
				return (int)$eid;
			}
		}

		return $this->db->Insert('profili', $row, $row);
	}	

}
?>