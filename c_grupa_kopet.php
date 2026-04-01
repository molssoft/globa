<?
require_once("online2/m_tiesibas.php");
require_once("online2/m_marsruts.php");
require_once("online2/m_grupa.php");
require_once("i_functions.php");

//standarts visaam lapaam
Docstart ("Grupas kopçðana","y1.jpg");
DefJavaSubmit();

$gid = $_GET['gid'];

$grupa = new Grupa();
$g = $grupa->getId($gid);

$marsruts = new Marsruts();
$m = $marsruts->getId($g['mID']);

if ($_POST['submit']=='1'){
	// veidojam jaunu marðrutu
	unset($m['ID']);
	$m['v'] = $_POST['v'];
	$m['v2'] = $_POST['v'];
	$mid = $marsruts->insert($m);
	
	unset($g['ID']);
	unset($g['v']);
	$g['mID'] = $mid;
	$g['kods'] = $_POST['kods'];
	$grupa->insert($g);
	
	?><a href="grupa_edit2.asp?gid=<?=$gid?>">nokopçts</a><?
	die();
}

?>

<b>Grupas kopçðana</b>
<form method=POST>
<table>
	<input type=hidden value=1 name=submit>
	<tr>
		<td>Vecais grupas ID</td>
		<td><input type=text name=gid value="<?=$gid;?>"></td>
	</tr>
	<tr>
		<td>Jaunais nosaukums</td>
		<td><input type=text name=v value="<?=$m['v']?>"></td>
	</tr>
	<tr>
		<td>Jaunais kods</td>
		<td><input type=text name=kods value="<?=$g['kods']?>"></td>
	</tr>
	<tr>
		<td></td>
		<td><input type=submit value="Kopçt"></td>
	</tr>
</table>
</form>

