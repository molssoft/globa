<?

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/m_grupa.php");
require_once("online2/m_tiesibas.php");
$db = New db();
$gr = new Grupa();
$tiesibas = new Tiesibas();


 if ($tiesibas->IsAccess(T_CELOJUMU_APR)){
	
	 if ((isset($_GET['gid']) && (int)$_GET['gid'] >0) || isset($_POST['gid']) || isset($_SESSION['aizstat']['gid'])){
		 if ( isset($_POST['gid'])){
			  $gid = (int)$_POST['gid'];
		 }
		 elseif ( isset($_SESSION['aizstat']['gid'])){
			  $gid = (int)$_SESSION['aizstat']['gid'];
			  	 unset($_SESSION['aizstat']['gid']);
		 }
		 else{
			$gid = (int)$_GET['gid'];
		 }
		  if (isset($_GET['neaizstat'])){
			 unset($_SESSION['aizstat']);
		 }
		 $grupa = $gr->GetId($gid);
		 if (empty($grupa)){
			 die("grupa ar ID# $gid nav atrasta");
		 }
		 $data['gid'] = $gid;
		// var_dump($grupa);

		 $targetfolder0_0 = "F:\\pdf\\";
		 $subfolder = $grupa['sakuma_dat']->format("Y")."\\";
		
		 $targetfolder0 = $targetfolder0_0.$subfolder;
		  if (!file_exists($targetfolder0)) {
			mkdir($targetfolder0, 0777, true);
			}
			//var_dump($_POST);
		 if (isset($_POST['delete'])){
			// echo 'noòemsim tikai linku grupai uz pdf';
			$gr->UnlinkPdf($gid);
			 $grupa = $gr->GetId($gid);
		 }
		 if (isset($_POST['link'])){
			 $apraksts = $_POST['apraksts'];
			 $filename = $subfolder.pathinfo($apraksts, PATHINFO_FILENAME);
			 $gr->LinkPdf($gid,$filename);
			  $grupa = $gr->GetId($gid);
			// die($filename);
			 
		 }
		 
		if (isset($_POST['upload'])  || isset($_SESSION['aizstat']['files'])){
			$error = array();
			// Use 
			if ($_FILES['file']['error'] === UPLOAD_ERR_OK) { 
			//uploading successfully done 
			} else { 
				die("Kïûda. Failu neizdevâs auugðupielâdçt<br>". new UploadException($_FILES['file']['error'])); 
				
			}
		 
		 //dabû grupas gadu:
		  if( isset($_SESSION['aizstat']['files'])){
			  $_FILES =  $_SESSION['aizstat']['files'];
			   unset($_SESSION['aizstat']['files']);
		  }
		  require_once($_SESSION['path_to_files']."i_functions.php");
		  
		 $file_name_for_db = SanitizeFilename(pathinfo(basename( $_FILES['file']['name']), PATHINFO_FILENAME)) . "_" . $gid . "_" . rand(10000,99999);
		 //echo $file_name_for_db;
		 //die();
		 $pdf_name = $subfolder.$file_name_for_db;
		 
		 $file_name = $file_name_for_db.".pdf"; //SanitizeFilename(basename( $_FILES['file']['name']));
			$targetfolder = $targetfolder0.$file_name ;
			//die($targetfolder);
			$ok=1;

			$file_type=$_FILES['file']['type'];
			//var_dump($file_type);
			if ($file_type=="application/pdf" || $file_type=="image/gif" || $file_type=="image/jpeg") {
				//var_dump($_FILES['file']['tmp_name']);
				//var_dump(file_exists( $_FILES['file']['tmp_name']));
				//exit();
				if (isset($_SESSION['aizstat']['tmp_filename']) && !file_exists( $_FILES['file']['tmp_name'])){
					//unlink($targetfolder);
					$from_folder = $_SESSION['aizstat']['tmp_filename'];
					
					unlink($targetfolder);
					$user_upload  = false;
				}
				else{
					$from_folder = $_FILES['file']['tmp_name'];
					$user_upload  = true;
				}
				
				if (!file_exists($targetfolder)){
					
					//var_dump(($from_folder));
					//var_dump($targetfolder);
					if ($user_upload){
						$result = move_uploaded_file($from_folder, $targetfolder);
					}
					else{
						$result = rename($from_folder, $targetfolder);
					}
				//var_dump(move_uploaded_file($from_folder, $targetfolder));
					if($result)
					 {
						 

						$gr->LinkPdf($gid,$pdf_name);
					 //echo "The file ". basename( $_FILES['file']['name']). " is uploaded";
					  $grupa = $gr->GetId($gid);

					 }
					 else {
						$error['file'] = "Kïûda, augðupielâdçjot failu";
						//echo "Kïûda, augðupielâdçjot failu";

					}
					if (isset($_SESSION['aizstat']['tmp_filename'])){
						
						if (file_exists($_SESSION['aizstat']['tmp_filename'])){
							unlink($_SESSION['aizstat']['tmp_filename']);
						}
						unset($_SESSION['aizstat']['tmp_filename']);
					}
					
				}
				else{
					$error['file'] ="Ðâds fails jau eksistç. Izvçlieties citu faila nosaukumu vai izvçlieties kâdu no jau augðupielâdçtajiem failiem.";
					$_SESSION['aizstat']['files'] = $_FILES;
					$_SESSION['aizstat']['gid'] = $gid;
					//saglabâjam pagaidu folderî failu:
					$tmp_targetfolder= $targetfolder0_0."tmp\\";
					//echo $tmp_targetfolder;
					//var_dump(file_exists($tmp_targetfolder));
					if (!file_exists($tmp_targetfolder)) {
						mkdir($tmp_targetfolder, 0777, true);
					}
					
					$tmp_filename = "tmp_".time()."_".basename( $_FILES['file']['name']);
					$tmp_targetfolder .= $tmp_filename;
					move_uploaded_file($_FILES['file']['tmp_name'], $tmp_targetfolder);
					$_SESSION['aizstat']['tmp_filename'] = $tmp_targetfolder;
					$subfolder = $grupa['sakuma_dat']->format("Y")."\\";
					$data['script'] = '<script>
										var r = confirm("Fails ar ðâdu nosaukumu jau eksistç! Vai aizstât esoðo ar jauno?");
										if (r == true) {
											window.location.reload();
											//window.location.href="?aizstat=1";
										} else {
											window.location.href="?neaizstat=1";
											
										} </script>';
				//	echo "Ðâds fails jau eksistç. Izvçlieties citu faila nosaukumu vai izvçlieties kâdu no jau eksistçjoðajiem failiem.";
				}

			 

			}

			else {
				$error['file'] = "Nepiemçrots faila formâts.<br>";
				//echo "Nepiemçrots faila formâts.<br>";

			}


			
			if (count($error) > 0) {
				// kïûda		
				// râdam vecâs vçrtîbas un kïûdas paziòojumu
				
				$data['errors'] = $error;
			}
			else{
				
				
			}
			
			$data['values'] = $_POST;
			
		}
		
		
		require_once("online2/m_marsruts.php");
		 $marsr = new Marsruts();
		 $marsruts = $marsr->GetGid($gid);
		 $data['celojums'] = $grupa['kods'].'<br>'.$marsruts['v'].'<br>'.$db->Date2Str($grupa['sakuma_dat']);
		 $data['apraksts'] = $grupa['pdf'];
		 if (empty($data['apraksts'])){
			 //atrod jau augðpuielâdçtos aprakstus
			
			  if (!file_exists($targetfolder0)) {
				mkdir($targetfolder0, 0777, true);
			}
			$data['esosie_apraksti'] = scandir($targetfolder0);
			
			//lai negrupçtos atseviðíi lielie un mazie burti
			natcasesort($data['esosie_apraksti']);
			//var_dump($data['esosie_apraksti']);
		 }
		include_once("v_celojuma_apraksts.php") ;
		if (isset($_SESSION["message"]) && $_SESSION["message"] != "") {
			echo "<center><font color='RED' size='5'><b>".$_SESSION["message"]."</b></font>";
			$_SESSION["message"] = "";
		}
		
	 }
	 
	 else{
		 exit('Nav norâdîts grupas ID#');
	 }
 }
 else{
	 exit("Jums nav pieejas tiesîbu ðai lapai");
 }
 
 function file_upload(){
 }
 
 class UploadException extends Exception 
{ 
    public function __construct($code) { 
        $message = $this->codeToMessage($code); 
        parent::__construct($message, $code); 
    } 

    private function codeToMessage($code) 
    { 
        switch ($code) { 
            case UPLOAD_ERR_INI_SIZE: 
                $message = "The uploaded file exceeds the upload_max_filesize directive in php.ini"; 
                break; 
            case UPLOAD_ERR_FORM_SIZE: 
                $message = "The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form";
                break; 
            case UPLOAD_ERR_PARTIAL: 
                $message = "The uploaded file was only partially uploaded"; 
                break; 
            case UPLOAD_ERR_NO_FILE: 
                $message = "No file was uploaded"; 
                break; 
            case UPLOAD_ERR_NO_TMP_DIR: 
                $message = "Missing a temporary folder"; 
                break; 
            case UPLOAD_ERR_CANT_WRITE: 
                $message = "Failed to write file to disk"; 
                break; 
            case UPLOAD_ERR_EXTENSION: 
                $message = "File upload stopped by extension"; 
                break; 

            default: 
                $message = "Unknown upload error"; 
                break; 
        } 
        return $message; 
    } 
} 

 

?>



