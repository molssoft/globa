<?
$dont_init_header = 1;
header('Content-Type: text/html; charset=UTF-8');
?>
<html>
<head>
<meta charset="UTF-8">
<head>
<body>

<?php

session_start();
$_SESSION['path_to_files'] = 'online2/';
require_once("online2/m_init.php");

$db = New Db();
$res = $db->QueryArray("select m.nosaukums, m.apraksts 
from 
	grupa gg
	join portal.dbo.Grupas g on gg.kods = g.gr_kods
	join portal.dbo.Marsruti m on g.marsruts = m.ID
where 
	gg.beigu_dat > getdate() 
	and gg.internets = 1 
	and gg.seo_status is null");
	

$nosaukums = iconv("Windows-1257", "UTF-8//IGNORE", $res[0]['nosaukums']);
$apraksts =  strip_tags(iconv("Windows-1257", "UTF-8//IGNORE", $res[0]['apraksts']));



$apiKey = trim(file_get_contents('gpt_key.txt'));
// Replace with your actual API key

$apiUrl = 'https://api.openai.com/v1/chat/completions';

$data = [
    'model' => 'gpt-4', // or 'gpt-3.5-turbo'f
    'messages' => [
        ['role' => 'system', 'content' => 'Tev ir jāuzģenerē meta dati priekš weblapas. Atbildi nolasīs programmatūra.'],
        ['role' => 'user', 'content' => 'Can you generate latvian SEO optimal meta description, meta title and slug for URL for a website that sells trips. 
		consider proper length of the generated data according to SEO standarts. do not include flight information. keep the length of the description close to 100 characters.
Please write output by separating three pieces of information using | caracter.
Output will be used by a software.  
The name of the trip: 
STARP DEBESĪM UN ZEMI. Description: '.$apraksts]

    ],
    'temperature' => 0.5
];


$headers = [
    'Content-Type: application/json',
    'Authorization: Bearer ' . $apiKey
];



$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $apiUrl);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

$response = curl_exec($ch);



if (curl_errno($ch)) {
    echo 'Error: ' . curl_error($ch);
} else {
    $result = json_decode($response, true);
    echo $result['choices'][0]['message']['content'];
}

curl_close($ch);
