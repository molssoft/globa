<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'E:\globa\wwwroot\online2\PHPMailer\src\Exception.php';
require 'E:\globa\wwwroot\online2\PHPMailer\src\PHPMailer.php';
require 'E:\globa\wwwroot\online2\PHPMailer\src\SMTP.php';

$mail = new PHPMailer(true);
$mail->isSMTP();
$mail->Host = 'smtp.office365.com';
$mail->Port       = 587;
$mail->SMTPSecure = 'tls';
$mail->SMTPAuth   = true;
$mail->Username = 'mail2022@impro.lv';
$mail->Password = 'lxvllqkqsvzcqqlb';

$mail->SetFrom('mail2022@impro.lv', 'IMPRO');
$mail->addAddress('marismols@gmail.com', 'Māris Mols');
//$mail->SMTPDebug  = 3;
//$mail->Debugoutput = function($str, $level) {echo "debug level $level; message: $str";}; //$mail->Debugoutput = 'echo';
$mail->IsHTML(true);

$mail->Subject = 'Here is the subject';
$mail->Body    = 'This is the HTML message body <b>in bold!</b>';
$mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

if(!$mail->send()) {
    echo 'Message could not be sent.';
    echo 'Mailer Error: ' . $mail->ErrorInfo;
} else {
    echo 'Message has been sent';
}

?>