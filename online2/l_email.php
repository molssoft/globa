<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'E:\globa\wwwroot\online2\PHPMailer\src\Exception.php';
require 'E:\globa\wwwroot\online2\PHPMailer\src\PHPMailer.php';
require 'E:\globa\wwwroot\online2\PHPMailer\src\SMTP.php';
 
//==============================================================
//Sii klase atbild par visu e-pastu suutiishanu. Gan rezervacijam, gan registrâcijaam utt.
//Janis Akmentins
//12.03.2009
//==============================================================
Class Email{
	var $db;
	
	public function __construct() { 
		if (isset($_SESSION['path_to_files'])){
			$path = $_SESSION['path_to_files'];
		}
		else $path = '';
		//echo $path.'m_init.php';
		require_once($path.'m_init.php');
		$this->db = new Db;	
	}
 
 
	
	 
	function htmlspecialch($someString) {
			
			// Critical that ampersand is converted first, since all entities contain them.
			$string =  str_replace("'","''",$someString);
		
			$string =  str_replace( "â","#a",$string);
			
			$string = str_replace( "è","#c",$string);
			$string =  str_replace( "ç","#e",$string);
			$string =  str_replace( "ì","#g",$string);
			$string =  str_replace( "î","#i",$string);
			$string =  str_replace( "í","#k",$string);
			$string =  str_replace( "ï","#l",$string);
			$string =  str_replace( "ò","#n",$string);
			$string =  str_replace( "ð","#s",$string);
			$string =  str_replace( "û","#u",$string);
			$string =  str_replace( "þ","#z",$string);
			$string =  str_replace( "ô","#o",$string);
	 
			$string =  str_replace( "Â","#A",$string);
			$string =  str_replace( "È","#C",$string);
			$string =  str_replace( "Ç","#E",$string);
			$string =  str_replace( "Ì","#G",$string);
			$string =  str_replace( "Î","#I",$string);
			$string =  str_replace( "Í","#K",$string);
			$string =  str_replace( "Ï","#L",$string);
			$string =  str_replace( "Ò","#N",$string);
			$string =  str_replace( "Ð","#S",$string);
			$string =  str_replace( "Û","#U",$string);
			
			$string =  str_replace( "Þ","#Z",$string);
			$string =  str_replace( "Ô","#O",$string);
			
			return $string;
	 
		//htmlspecialchars = Replace(replace(replace(replace(replace(someString, "&", "&amp;"), ">", "&gt;"), "<", "&lt;"), """", "&quot;"),"'","&#39;")
	}
	 
	function ForgotPasswordData($user_name,$new_pw,$recipient) { 
		$msg = $this->PrepaireForgotPasswordData($user_name,$new_pw);
		$result = $this->SendO365($msg,"Jaunâ parole",$recipient);
	}
	 
	function ForgotPassword($verify_string,$id,$recipient) { 
		$result = send_mail(prepaireForgotPassword($verify_string,$id),"Paroles atjaunoðana",$recipient);
	}
	 
	function ReservationConfirmation($recipient,$data,$dk = 0, $pdf = null,$is_profile=1) { 
		//dim $result;
		if (!$dk){
			$msg = $this->PrepaireReservationConfirmation($data);
			//return $msg;
			//echo die($recipient);
		}
		//dâvanu kartes gadîjumâ izsûta savâdâku ziòu
		else{
			$msg = $this->PrepaireReservationConfirmationDk($data,$pdf,$is_profile);
		}
		$result = $this->SendMail($msg,"Maksâjuma apstiprinâjums",$recipient,true);
	}

	function prepaireForgotPasswordData($user_name,$new_pw) {
		
		$msg = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf8'></head><body>"."\n".
									"Sveicinâti!<br><br>"."\n".
									"Lietotâja vârds: ".$user_name."<br>"."\n".
									"Jaunâ parole: ".$new_pw."<br>"."\n".
									"<br>Pçc autorizâcijas sistçmâ paroli var nomainît sadaïâ Paroles maiòa<br>"."\n".
									"</body></html>";
		return  $msg;
	}
	
	function PrepaireReservationConfirmation($data) { 
		//iekïaut kopsavilkumu
		$msg = "<html>"."\n".
					"<head>"."\n".
					"<meta http-equiv='Content-Type' content='text/html; charset=charset=utf8'></head><body>";
					
		$msg .= "Paldies, Jûsu maksâjums";
		if (isset($data['maksajuma_summa']) && !empty($data['maksajuma_summa'])){
			$msg .= " (".$data['maksajuma_summa'].")";
		} 		
		$msg .= " ir reìistrçts!<br>";
					
						
		$msg .= "<h2>".$data['celojuma_nos']." (".$data['sakuma_dat']." - ".$data['beigu_dat'].")</h2>
								";
							
		if (!empty($data['termini'])){
			$msg .= "<h3>Maksâjumu termiòi</h3>
							<ol>";
			
			 $i=1; 
			foreach($data['termini'] as $termins){
				$when = "Lîdz <b>".$termins['datums']."</b>";
				if ($i==1){
					$how_much = "<b>".$termins['summa']." ".$data['grupas_valuta']."</b>";
					$when = 'Piesakoties';
				}
				else if ($i== count($data['termini'])){
					$how_much = 'pilna summa';
				}
				else{
						$how_much = 'vçl '."<b>".$termins['summa']." ".$data['grupas_valuta']."</b>";
				}
				$msg .= "<li>$when jâiemaksâ $how_much</li>";
			
				$i++;
			}
												
			$msg .= "</ol>";
		}					
		
		
		$msg .= "<h3>
					Pasûtîtie pakalpojumi</h3>
						<ul class='list-unstyled'>";
						//var_dump($data['celotaji']);
						//echo "ceïotâji";
						//exit();
		if ($data['celotaji']){
		foreach ($data['celotaji'] as $dalibn){
				$msg .= "<li><b>".$dalibn['vards'].' '.$dalibn['uzvards'].'</b>
							<table class="table " style="padding-left:20px">';
			foreach ($dalibn['pakalpojumi'] as $pakalpojums){
				$msg .= "<tr><td>".$pakalpojums['nosaukums'].": </td>
												<td width='200px'>".$pakalpojums['summaEUR']."</td>
											</tr>";
			}
				$msg .="</table>		
						</li>";
										
		}
		}
		$msg .= "</ul>";
							
		$msg .= '<h3>Norçíini</h3>
						<table class="table">
									<tr>
										<th>Ceïojuma cena:</th>
										<td align="right">'.$data['kopsumma'].' EUR</td>
									</tr>
									<tr>
										<th>Iemaksâts:</th>
										<td align="right">'.$data['iemaksats'].' EUR</td>
									</tr>
									<tr>
										<th>Vçl jâmaksâ:</th>
										<td align="right">'.$data['jamaksa'].' EUR</td>
									</tr>
								</table>
								';
		$msg = $msg."<br /><b>Paldies, ka izmantojât Impro pakalpojumus!</b><br />";
		$msg = $msg."<b>Ceïojuma apmaksas termiòus un veikto maksâjumu kopsummu skatiet arî savâ IMPRO online kontâ!</b>";
		$msg = $msg."</body></html>";	 
									
										
		return  $msg;
	}
	 
	function SendMail($msg, $subj, $recipient,$save = false,$from_proc = 'online_rezervacija') {
	 
		$msg = str_replace("'","''",$msg);
		$subj = str_replace("'","''",$subj);
		$recipient = str_replace("'","''",$recipient);
		
		if (!$save){
			$query = "exec email_proc @message=?, @subject=?,@to=?";
			
			
			$params = array($this->htmlspecialch($msg),$this->htmlspecialch($subj),$recipient);
			
			
			//
			//$params = array($msg,$subj,$recipient);
			$this->db->Query($query,$params);
		}
		else{
			
			$values = array('[to]'=>$recipient,'[subject]'=>$this->htmlspecialch($subj),'[text]'=>$this->htmlspecialch($msg),'date'=>date("Y-m-d H:i:s"),'from_proc'=>$from_proc);
			$this->db->Insert('epasts',$values);
			
		}
		
	}
	
	function SendO365($msg, $subj, $recipient,$save = false,$from_proc = 'online_rezervacija') {
		
		$mail = new PHPMailer(true);
		$mail->isSMTP();
		$mail->Host = 'smtp.office365.com';
		$mail->Port       = 587;
		$mail->SMTPSecure = 'tls';
		$mail->SMTPAuth   = true;
		$mail->Username = 'mail2022@impro.lv';
		$mail->Password = 'chjrgydmjvplmdht';

		$mail->SetFrom('mail2022@impro.lv', 'IMPRO');
		$mail->addAddress($recipient, $recipient);
		$mail->IsHTML(true);

		$mail->Subject = $subj;
		$mail->Body    = $msg;

		if(!$mail->send()) {
			return false;
		} else {
			return true;
		}
	}
	
	
	function SendGroupPdfChanges($grupa,$new=1){
		//
		$recipient = 'vilnis@impro.lv; meitenes@impro.lv';
		if ($new){
			 $action = 'pievienots';
			 $apraksts = '<a href="http://www.impro.lv/pdf/'.$grupa['pdf'].'.pdf" target="_blank">ceïojuma apraksts</a>';
		 }
		 else {
			 $action = 'noòemts';
			 $apraksts = 'ceïojuma apraksts';
		 }
		 $subject = $action." ceïojuma apraksts";
		 
		 require_once("m_marsruts.php");
		 $marsr = new Marsruts();
		 $marsruts = $marsr->GetGid($grupa['ID']);
		 $celojums = $grupa['kods'].' '.$marsruts['v'].' '.$this->db->Date2Str($grupa['sakuma_dat']);
		 $subject .= " ".$celojums;
		 	$msg = "<html>"."\n".
					"<head>"."\n".
					"<meta http-equiv='Content-Type' content='text/html; charset=charset=utf8'></head><body>";
		 $msg .= '<p>Grupai <a href="http://globa/grupa_edit.asp?gid='.$grupa['ID'].'">'.$celojums."</a> $action $apraksts.</p></body></html>";
		$result = $this->SendMail($msg,$subject,$recipient,true);
	}
	 
	 //aptiprinaajuma meils par SAÒEMTU MAKSÂJUMU DÂVANU KARTEI
	function PrepaireReservationConfirmationDk($data, $pdf, $is_profile){ 
		
		if (isset($pdf)){
			$mailto = 'r.treikalisha@gmail.com';
			$from_name = 'LUBUS PDF Test';
			$from_mail = 'email@domain.com';
			$replyto = 'email@domain.com';
			$uid = md5(uniqid(time())); 
			$subject = 'mdpf email with PDF';
			$message = 'Download the attached pdf';
			$filename = 'lubus_mpdf_demo.pdf';
			$header = "From: ".$from_name." <".$from_mail.">\r\n";
			$header .= "Reply-To: ".$replyto."\r\n";
			$header .= "MIME-Version: 1.0\r\n";
			$header .= "Content-Type: multipart/mixed; boundary=\"".$uid."\"\r\n\r\n";
			$header .= "This is a multi-part message in MIME format.\r\n";
			$header .= "--".$uid."\r\n";
			$header .= "Content-type:text/plain; charset=iso-8859-1\r\n";
			$header .= "Content-Transfer-Encoding: 7bit\r\n\r\n";
			$header .= $message."\r\n\r\n";
			$header .= "--".$uid."\r\n";
			$header .= "Content-Type: application/pdf; name=\"".$filename."\"\r\n";
			$header .= "Content-Transfer-Encoding: base64\r\n";
			$header .= "Content-Disposition: attachment; filename=\"".$filename."\"\r\n\r\n";
			$header .= $pdf."\r\n\r\n";
			$header .= "--".$uid."--";
			$is_sent = mail($mailto, $subject, "", $header);
		}
		//iekïaut kopsavilkumu
		$msg = "<html>"."\n".
					"<head>"."\n".
					"<meta http-equiv='Content-Type' content='text/html; charset=charset=utf8'></head><body>";
					
		$msg .= "
					
						
					<h2>Dâvanu karte (".$data['sakuma_datums']." - ".$data['beigu_datums'].")</h2>
								";
							
			$msg .= "<table>
					<tr>
						<th>Iegâdes datums</th>
						<th>Summa</th>
						<th>Kam</th>
						<th>Nr.</th>
						<th><b>Droðîbas kods</th>
						
					</tr>
					
					<tr>
						<td>".$data['datums']."</td>
						<td>".$data['cena']." EUR</td>
						<td>".$data['dk_kam']."</td>
						<td>";
			if (!empty($data['dk_serija'])){
				$msg .= $data['dk_serija']."-";
			}
			$msg .= $data['dk_numurs']."</td>
						<td>".$data['dk_kods']."</td>
					</tr>
					</table>";
		
		
							

		//visiem sûtam dk linku - 07.09.2018
		//if (!$is_profile){
			$msg .= '<a href="https://www.impro.lv/online/c_reservation.php?f=PrintDk&num='.$data['dk_numurs'].'&k='.$data['dk_kods'].'">Atvçrt dâvanu karti</a><br>';
		//}			
		$msg = $msg."<br /><b>Paldies, ka izmantojât Impro pakalpojumus!</b><br />";
		if ($is_profile){
			$msg = $msg.'<b>Dâvanu karti varat apskatît un izdrukât arî savâ <a href="https://www.impro.lv/online/c_reservation.php?f=SavedReservations">IMPRO online kontâ</a>!</b>';
		}
		$msg = $msg."</body></html>";	 
									
										
		return  $msg;
	}
	 
}
?>

