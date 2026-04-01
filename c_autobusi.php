<?
//----------------------
// c_autobusi.php
//----------------------
session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once($_SESSION['path_to_files']."m_autobusi.php");
$db = New Db();
$autobusi = new Autobusi();
$target_folder = "E:\\www\\autobusu_bildes\\";

require_once($_SESSION['path_to_files']."i_functions.php");

$function = $_GET['f'];
if (!isset($_GET['f'])) $function = 'index';
if ($function == 'index') Index();
if ($function == 'edit') {
	Edit();
}
if ($function == 'delete') Delete();
if ($function == 'upload_plans') {$id = (int)$_GET['id']; UploadPlans($id);}
if ($function == 'upload_images') {$id = (int)$_GET['id']; UploadImages($id);}
if ($function == 'delete_bilde') {$image_id = (int)$_GET['image_id']; $id = (int)$_GET['id']; DeleteBilde($image_id,$id);}
if ($function == 'set_image_main') {$image_id = (int)$_GET['image_id']; $id = (int)$_GET['id']; SetImageMain($image_id,$id);}
function Index(){
	global $autobusi;
	$data['autobusi'] = $autobusi->Get();
	
	//var_dump($data['autobusi']);
	require_once("v_autobusi.php");
}

function Edit(){
	global $autobusi;
	global $db;
	
	if (isset($_GET['id']) && (int)$_GET['id'] >0){
		$id = (int)$_GET['id'];
	}
	else $id = 0;
	
	if (isset($_POST['post']) && $_POST['post'] == 1){
		$values = $db->EscapeValues($_POST,'partneris,nosaukums,nr,soferis,mobilais,vietas,krasa,modelis,papildv,bagaza,aprikojums,baka,augstums,platums,garums,paterins');
		//var_dump($values);
		$values['nosaukums'] = Encode($values['nosaukums']);
		$values['soferis'] = Encode($values['soferis']);
		if (isset($_POST['radit_web'])) $values['radit_web'] = 1;
		else $values['radit_web'] = 0;

		if ($id){			
			$autobusi->Update($values,$id);
		}
		else{
			$id = $autobusi->Insert($values);
			
		}
		$_SESSION['message'] = '<font color=black size="4">Izmaiòas saglabâtas.</font><br>';
		
			
	}
	
	if ($id){
		$data['autobuss'] = $autobusi->GetId($id);
		//var_dump($data['autobuss']);
		
	}
	else{
		$data['autobuss'] = array("pnos" => "",
									"nosaukums" => "",
									"nr" => "",
									"soferis"  => "",
									"mobilais"   => "",
									"vietas"   => "",
									"krasa" => "",
									"modelis"=>"",
									"papildv" => "",
									"radit_web"=>"",
									"bagaza"=>"",
									"aprikojums"=>"",
									"baka"=>"",
									"augstums"=>"",
									"platums"=>"",
									"garums"=>"",
									"paterins"=>""
									);
	}
	$data['partneri'] = $autobusi->GetPartneriAuto();
	$data['bildes'] = $autobusi->GetBildes($id);
	require_once("v_autobuss_edit.php");
	require_once("v_autobuss_bildes.php");
}

function Delete(){
	global $autobusi;
	if (isset($_POST['id']) && (int)$_POST['id'] >0){
		$id = (int)$_POST['id'];
		$autobusi->Delete($id);
		$_SESSION['message'] = '<font color=black size="4">Autobuss dzçsts.</font><br>';
			
		header("Location: c_autobusi.php?f=index");
		exit();
		
	}
	else{
		die("Nav norâdîts autobusa ID#");
	}
}
function UploadPlans($id){
	
	global $autobusi;
	global $target_folder;
	//$data['id'] = $id;
	if (isset($_POST['post'])) {

		//var_dump($_POST);
		//var_dump($_FILES['file_array']);
		if(isset($_FILES['file'])){
			
			$tmp_name = $_FILES['file']['tmp_name'];
			$size = $_FILES['file']['size'];
			//var_dump(count($tmp_name));
			//for($i=0; $i < count($tmp_name);$i++){
				//echo $i;
				if(exif_imagetype($tmp_name)){
					//var_dump(($size / 1024));
					if(round(($size / 1024),2) <= 10000)
					{
						
						
						//Galvenâs bildes veidoðana
						$newfilename =  $id.'_'. date('YMdDHis').'.'.FileExtension($_FILES['file']['name']);
						$newfilename = MakePath($newfilename);
						if (file_exists($target_folder.$newfilename))
						{
							$newfilename = time()."_".$newfilename;
						}
						
						move_uploaded_file($tmp_name, $target_folder.$newfilename);
						$data['plans'] = $newfilename;
						$image_id = $autobusi->Update($data,$id);						
						
					}
					else {
						echo "FILE SIZE LIMIT EXCEEDED ";
					}
				}//else echo "not";
		}
		
		header("Location: c_autobusi.php?f=edit&id=".$id);
	}
	$data['id'] = $id;
	require_once("v_autobuss_upload_plans.php");

}

function UploadImages($id){
	global $autobusi;
	global $target_folder;
	$data['autobusi_id'] = $id;
	if (isset($_POST['post'])) {

		//var_dump($_POST);
		//var_dump($_FILES['file_array']);
		if(isset($_FILES['file_array'])){
			$tmp_name = $_FILES['file_array']['tmp_name'];
			$size = $_FILES['file_array']['size'];
			//var_dump(count($tmp_name));
			for($i=0; $i < count($tmp_name);$i++){
				//echo $i;
				if(exif_imagetype($tmp_name[$i])){
					//var_dump(($size[$i] / 1024));
					if(round(($size[$i] / 1024),2) <= 10000)
					{
						
						
						//Galvenâs bildes veidoðana
						$newfilename = $_FILES['file_array']['name'][$i];
						//$newfilename =  $id.'_'. date('YMdDHis').'.'.FileExtension($_FILES['file_array']['name'][$i]);
						$newfilename = MakePath($newfilename);
						if (file_exists($target_folder.$newfilename))
						{
						//	echo $newfilename."<br>";
							$newfilename = time()."_".$newfilename;
							//echo $newfilename."<br>";
						}
						
						//$newfilename_small = $random.'_small.jpg';
						move_uploaded_file($tmp_name[$i], $target_folder.$newfilename);
						$data['bilde'] = $newfilename;
						$image_id = $autobusi->AddBilde($data);						
						if ($i==0){
							$first_image_id = $image_id;
						}
					}
					else {
						 //$this->form_validation->set_message('file_array', 'Image file can not exceed 10MB size limit.');
						echo "FILE SIZE LIMIT EXCEEDED ";
					}
				}//else echo "not";
			}
		}
		//ja nav gakevâ bilde uzstâdîta, uzstâda pirmo no ielâdçtajâm
		$galvena_bilde = $autobusi->GetGalvenaBilde($id);
		if (empty($galvena_bilde) && isset($first_image_id)){
			$autobusi->UpdateBilde(array('galvena'=>1),$first_image_id);
			
		}
		header("Location: c_autobusi.php?f=edit&id=".$id);
		//redirect("estate/edit/".$estate_id."/".$this->session->userdata('token'));
	}
	$data['id'] = $id;
	require_once("v_autobuss_upload_images.php");
}
	
	
 function DeleteBilde($image_id,$id){
	global $db;
	global $autobusi;
	global $target_folder;
	$data=array("id"=>$image_id);
	$image = $db->GetId('autobusi_bildes',$image_id);
	
	$filename = $image['bilde'];
	$autobusi->DeleteBilde($image_id);
	unlink($target_folder.$filename);
	header("Location: c_autobusi.php?f=edit&id=".$id);
}
	
 function SetImageMain($image_id,$id){
	global $autobusi;
		//atiestata iepriekðçjo galveno
		$galvena = $autobusi->GetGalvenaBilde($id);
		if (!empty($galvena)){
			$first_image_id = $galvena['id'];
			$autobusi->UpdateBilde(array('galvena'=>0),$first_image_id);
		}
	
	
		$autobusi->UpdateBilde(array('galvena'=>1),$image_id);
		header("Location: c_autobusi.php?f=edit&id=".$id);
}

 function FileExtension($file){
		$c = explode('.', $file);
		$x = end($c);
		return strToLower($x);
}
	
function MakePath($txt, $slash = true){
	$FromChars = '“„”_ "âèçìîíïòºðûþÂÈÇÌÎÍÏÒªÐÛÞ????????????????????????????????????????????????????????????????';
	$ToChars = '______acegiklnrsuzacegiklnrsuzicukengsszhifivaproldzeacsmitibuicukengsszhifivaproldzeacsmitibu';
	$n = mb_strLen($FromChars);
	for ($i = 0; $i < $n; $i++)
	{
		$txt = str_replace(mb_substr($FromChars, $i, 1, 'utf-8'), mb_substr($ToChars, $i, 1, 'utf-8'), $txt);
		$txt = str_replace('__', '_', $txt);
	}
	$txt = str_replace(' ', '-', $txt);
	#    $txt = eregi_replace("/[^a-zA-Z0-9\-_]+", '',);
	if ($slash)
	{
		$txt = str_replace('<', '', $txt);
		$txt = str_replace(' ', '_', $txt);
		$txt = str_replace('>', '', $txt);
		$txt = str_replace('[', '', $txt);
		$txt = str_replace(']', '', $txt);
		$txt = str_replace('/', '-', $txt);
		$txt = str_replace('?', '-', $txt);
	}
//	$txt = strip_tags($txt);
	return $txt;
}
?>