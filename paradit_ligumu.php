<?

$ligums_id = (int)$_GET['id'];
	//require_once("i_functions.php");
	require_once('online2/m_ligumi.php');
	$ligumi  = new Ligumi();
	
	$ligums = $ligumi->GetId($ligums_id);
	//ppvar_dump($ligums);
	if (!empty($ligums)){ 
		$thousands = floor($ligums_id/1000)+1;
		$dir  = '\\\\ser-db3\\pdf-ligumi\\'.$thousands;	

		if (!empty($ligums['file_name'])){
		
			$old_filename = $dir. '\\'. $ligums['file_name'];
			//echo $ligums['file_name'];
			//echo $old_filename;
				if (file_exists($old_filename)){	
				
				  header('Content-type: application/pdf');
				  header('Content-Disposition: inline; filename="impro_ligums.pdf"');
				  header('Content-Transfer-Encoding: binary');
				  header('Accept-Ranges: bytes');
				  echo file_get_contents($old_filename);
				
				}
				else if (file_exists( '\\\\ser-db3\\pdf-ligumi\\'.$ligums['file_name'])){
					 header('Content-type: application/pdf');
				  header('Content-Disposition: inline; filename="impro_ligums.pdf"');
				  header('Content-Transfer-Encoding: binary');
				  header('Accept-Ranges: bytes');
				  echo file_get_contents('\\\\ser-db3\\pdf-ligumi\\'.$ligums['file_name']);
				}
				else echo "Fails nav atrasts";
					
				
			
			
		}
		//vecâ versija, kad lîgumi bija db
		elseif (!empty($ligums['bpdf'])){
			
			$filename = 'ligums';
			header("Content-type: application/pdf"); 	
			header('Content-Disposition: inline; filename="'.$filename.'"');  
			echo $ligums['bpdf'];
			
		}
	}
	else echo "Lîgums nav atrasts";
		
			

?>