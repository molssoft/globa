<?
//session_save_path('tmp/') ;
session_save_path('c:\temp') ;

session_start();
//echo session_save_path() ;
require_once("m_user_tracking.php");
$u_track = new UserTracking();
$text = "<b>Iziet no sistçmas</b>";
$u_track->Save($text);

$session_id = session_id();

$profile_id = $_SESSION['profili_id'];
unset($_SESSION['profili_id'],$_SESSION['username'],$_SESSION['password'],$_SESSION['reservation'],$_SESSION['pirkt']);
header('Location: c_login.php');
require_once("m_init.php");
$db = new Db();
$query = "EXEC online_rez_nepab_atgadinat @profile_id=?, @session_id=?";
$params = array($profile_id,$session_id);
//echo $query;
//var_dump($params);
$db->Query($query,$params);

if (isset($_COOKIE['impro-online'])) {
    unset($_COOKIE['impro-online']);
    setcookie('impro-online', '', time() - 3600, '/'); // empty value and old timestamp
}


?>