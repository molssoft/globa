<?php

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");
require_once("online2/i_functions.php");

$db = New db();



function dd($value, $exit = true)
{
    echo '<pre>';
    var_dump($value);
    echo '</pre>';

    if ($exit === true)
    {
        exit();
    }
}
$global_config = array();
$global_config['base_url'] = 'dokuments.php';
$global_config['files'] = array();
$global_config['files']['base_upload_dir'] = __DIR__ . DIRECTORY_SEPARATOR . 'uploads';
$global_config['files']['base_upload_url'] = 'documents/uploads';

class Documents
{
    public $form_errors = array();

    protected $config;
    protected $db_connection;
    protected $db_table = 'dbo.dokumenti';
    protected $images_extensions = ['gif', 'jpg', 'jpeg', 'png'];

    public function __construct($config)
    {
        $this->config = $config;
    }

    public function db_delete($id)
    {
		global $db;
        $query = 'DELETE FROM ' . $this->db_table . ' WHERE id = ' . (int) $id;
        return $db->Query($query);
    }

    public function add($input, $files)
    {
		global $db;
        if (empty($files['document_file']))
        {
            $this->form_errors[] = 'Dokumenta fails ir obligāts!';
            return false;
        }

        // Set insert-data
        $file_name_parts = explode('.', $files['document_file']['name']);
        $insert_data = [
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => null,
            'deleted_at' => null,
            'notes' => ! empty($input['notes']) ? $input['notes'] : '',
            'year' => date('Y'),
            'month' => date('m'),
            'file_original_name' => basename($files['document_file']['name']),
            'file_extension' => (count($file_name_parts) > 1) ? end($file_name_parts) : '',
            'file_name' => time() . '__' . $files['document_file']['name'],
        ];
		
		if ($input['did']!="") {
			$insert_data['did'] = $input['did'];
		}
		
		if ($input['pid']!=""){
			$insert_data['pid'] = $input['pid'];
		}


        // Create upload directories if they do not exist
        $upload_dir = $this->config['files']['base_upload_dir'] . DIRECTORY_SEPARATOR . $insert_data['year'] . DIRECTORY_SEPARATOR . $insert_data['month'];
        if ( ! file_exists($upload_dir))
        {
            if ( ! mkdir($upload_dir, 0777, true))
            {
                $this->form_errors[] = 'Neizdevās izveidot augšupielādes mapes!';
                return false;
            }
        }

        // Move file from tmp to upload-dir
        $move_to = $upload_dir . DIRECTORY_SEPARATOR . $insert_data['file_name'];
        $file_was_moved = move_uploaded_file($files['document_file']['tmp_name'], $move_to);
        if ( ! $file_was_moved)
        {
            $this->form_errors[] = 'Neizdevās augšupielādēt failu!';
            return false;
        }

        // Insert data in db
        $insert_result = $db->Insert('dokumenti',$insert_data);

		
        if ( ! $insert_result)
        {
            $this->form_errors[] = 'Neizdevās saglabāt dokumentu datubāzē!';
            return false;
        }

        return true;
    }

    public function get_all()
    {
		global $db;
		global $did;
		global $pid;
        $return_data = [];



        // Get data from db
		if ($did)
			$query = 'SELECT * FROM ' . $this->db_table . ' WHERE did = ' . $did . ' ORDER BY id ';
		if ($pid)
			$query = 'SELECT * FROM ' . $this->db_table . ' WHERE pid = ' . $pid . ' ORDER BY id ';
		
        $result = $db->Query($query);
        if ( ! empty($result))
        {
            while($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC) )
            {
                $return_data[] = $row;
            }
        }

        // Prepare and/or add extra data
        foreach ($return_data as $i => $row)
        {
            $return_data[$i]['file_url'] = $this->config['files']['base_upload_url'] . '/' . $row['year']
                . '/' . $row['month'] . '/' . $row['file_name'];
            $return_data[$i]['file_path'] = $this->config['files']['base_upload_dir'] . DIRECTORY_SEPARATOR
                . $row['year'] . DIRECTORY_SEPARATOR . $row['month'] . DIRECTORY_SEPARATOR . $row['file_name'];
            $return_data[$i]['is_image'] = in_array($row['file_extension'], $this->images_extensions);

            $temp = explode('.', $row['file_original_name']);
            if (count($temp) > 1)
            {
                unset($temp[count($temp) - 1]);

            }
            $return_data[$i]['file_original_name_no_ext'] = implode('.', $temp);
        }

        return $return_data;
    }
}

$did = $_GET['did'];
$pid = $_GET['pid'];

// Create documents object
$documents = new Documents($global_config);


// Set view data
$all_documents = $documents->get_all();
$action = (isset($_GET['action']) && in_array($_GET['action'], ['create', 'edit', 'delete', 'download', 'download-image-as-pdf'])) ? $_GET['action'] : 'create';
$active_item_id = $_GET['id'];


if ($_POST['action'])
{
	$save_id = $_POST['save_id'];
	$active_item_id = $save_id;
	$action = $_POST['action'];
}

if ( ! empty($active_item_id))
{
    foreach ($all_documents as $temp_item)
    {
        if ((int) $temp_item['id'] == $active_item_id)
        {
            $active_item = $temp_item;
            break;
        }
    }
}


// Handle actions
if ($action === 'create')
{
    // Add
    if ( ! empty($_POST) && ! empty($_FILES))
    {
        $documents->add($_POST, $_FILES);
        // Redirect
		if ($did) {
			header('Location: ' . $global_config['base_url'] . '?did=' . $did);
		}
		if ($pid) {
			header('Location: ' . $global_config['base_url'] . '?pid=' . $pid);
		}
		
    }
}
else if ($action === 'edit' && ! empty($active_item))
{
    if ( ! empty($_POST))
    {
		$data = array();
		$data['notes'] = $_POST['notes'.$active_item_id];
		
		echo $data['notes'];
		$data['did'] = $_POST['did'];
		$data['pid'] = $_POST['pid'];
		$db->Update('dokumenti',$data,$active_item_id);

        // Redirect
		if ($did)
			header('Location: ' . $global_config['base_url'] . '?' . http_build_query(['action' => 'edit', 'id' => $active_item_id, 'did' => $did]));
		if ($pid)
			header('Location: ' . $global_config['base_url'] . '?' . http_build_query(['action' => 'edit', 'id' => $active_item_id, 'pid' => $pid]));
    }
}
else if ($action === 'delete' && ! empty($active_item))
{
    // Delete file
    unlink($active_item['file_path']);

    // Delete db row
    $documents->db_delete($active_item['id']);

    // Redirect
	if ($did)
		header('Location: ' . $global_config['base_url'] . '?did=' . $did);
	if ($pid)
		header('Location: ' . $global_config['base_url'] . '?pid=' . $pid);
	
}
else if ($action === 'download' && ! empty($active_item))
{
    if (file_exists($active_item['file_path']))
    {
        header('Content-Description: File Transfer');
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="' . basename($active_item['file_path']) . '"');
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        header('Content-Length: ' . filesize($active_item['file_path']));
        readfile($active_item['file_path']);
        exit();
    }
}
else if ($action === 'download-image-as-pdf' && ! empty($active_item))
{
    // @see http://www.fpdf.org/
    include_once('fpdf.php');
    $pdf = new FPDF();
    $pdf->AddPage();
    $pdf->Image($active_item['file_path'], 10, 10, -300);
    $pdf->Output('D', $active_item['file_original_name_no_ext'] . '.pdf');
}

?>
<?require_once("i_functions.php");
//standarts visaam lapaam
Docstart ("Dokumenti","y1.jpg");
DefJavaSubmit();?>
<? if(isset($data['script'])){
	echo $data['script'];?>
<?}
?>
<font face=Tahoma>
<center><font color="GREEN" size="5"><b>Dokumenti</b></font><hr>

<?
// standarta saites
 
Headlinks();
?>
<BR>
    <div>
		<center>
        <form id="forma" method="post" action="<?php echo $global_config['base_url'] . '?did=' . $did . '&pid=' . $pid; ?>" id="submit-document-form" enctype="multipart/form-data">
        <table border=1>
            <tr>
                <th>Fails</th>
                <th>Piez�mes</th>
                <th>Darb�bas</th>
            </tr>
            <?php foreach ($all_documents as $item) { ?>
                <tr>
                    <td>
                        <a href="<?php echo $global_config['base_url'] . '?' . http_build_query(['action' => 'download','did' => $did, 'id' => $item['id'], 'pid' => $pid]); ?>" target="_blank">
                            <?php echo $item['file_original_name']; ?>
                        </a>
                        <?php if ($item['is_image']) { ?>
                            <a href="<?php echo $global_config['base_url'] . '?' . http_build_query(['action' => 'download-image-as-pdf', 'id' => $item['id'], 'pid' => $pid]); ?>" target="_blank">[pdf]</a>
                        <?php } ?>
                    </td>
                    <td><input type=text value="<?php echo $item['notes']; ?>" size=30 name="notes<?=$item['id']?>"></td>
                    <td>
                        <a href="#"
							onclick="
								document.getElementById('save_id').value = <?=$item['id']?>;
								document.getElementById('action').value = 'edit';
								document.getElementById('forma').submit();
							"
						>[saglab�t]</a>
                        
                        <a href="<?php echo $global_config['base_url'] . '?' . http_build_query(['action' => 'delete', 'id' => $item['id'], 'pid' => $pid, 'did' => $did]); ?>" onclick="return confirm('Vai tie��m v�laties dz�st?')">[dz�st]</a>
                    </td>
                </tr>
            <?php } ?>
			
			<tr>
				<td><input type="file" name="document_file" id="document_file" /></td>
				<td><input type="text" name="notes" id="notes" size=30></td>
				<td><a href=# 
					onclick="
						document.getElementById('action').value = 'create';
						document.getElementById('forma').submit();
					">[pievienot]</a>
				</td>
			</tr>
        </table>
		<input type="hidden" id="save_id" name="save_id" value="0" size=30>
		<input type="hidden" id="action" name="action" size=30>
		<? if ($did) { ?>
		<input type="hidden" id="did" name="did" value=<?=$did?> size=30>
		<? } ?>
		<? if ($pid) { ?>
		<input type="hidden" id="pid" name="pid" value=<?=$pid?> size=30>
		<? } ?>
		</form>
    </div>

	<? if ($did) { ?>
	<a href=dalibn.asp?i=<?=$did?>>Atgriezties</a>
	<? } ?>

	<? if ($pid) { ?>
	<a href=pieteikums.asp?pid=<?=$pid?>>Atgriezties</a>
	<? } ?>

</body>
</html>