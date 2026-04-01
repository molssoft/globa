<?php
session_start();
require_once("../../m_init.php");
$db = new Db();

require('includes/config.php');
require('includes/connect.php');
require("includes/Merchant.php");
$ecomm_url = $domain.':8443/ecomm/MerchantHandler';

if((isset($_GET['action']))){
	$i=$_GET['action'];
}else{
	$i='form_sms';
}

switch ($i) {
	//CASE FORM DMS
	case 'form_dms':
		print ('
		<b>DMS</b> | <a href="?action=form_sms">SMS</a> | <a href="?action=select">Transaction list</a><br>
		<br>
		<br>
		<form action="?action=startdmsauth" method="post">
		<table>
		        <tr>
		            <th align="right">Description: </th>
		            <td align="left"><input type="text" name="description"></td>
		        </tr>
		        <tr>
		            <th align="right">Amount: </th>
		            <td align="left"><input type="text" name="amount"></td>
		        </tr>
		        <tr>
		            <td></td>
		            <td align="right"><input type="Reset"> <input type="submit" value="Submit"></td>
		        </tr>
		    </table>

		</form>');
	break;
	//CASE FORM SMS
	case 'form_sms':
		print ('
		<a href="?action=form_dms">DMS</a> | <b>SMS</b>  | <a href="?action=select">Transaction list</a><br>
		<br>
		<br>
		<form action="?action=startsmstrans" method="post">
		<table>
		        <tr>
		            <th align="right">Description: </th>
		            <td align="left"><input type="text" name="description"></td>
		        </tr>
		        <tr>
		            <th align="right">Amount: </th>
		            <td align="left"><input type="text" name="amount"></td>
		        </tr>
		        <tr>
		            <td></td>
		            <td align="right"><input type="Reset"> <input type="submit" value="Submit"></td>
		        </tr>
		    </table>

		</form>');
	break;

	//CASE STARTDMSAUTH
	case 'startdmsauth':

		$amount = $_POST['amount'];
		$ip = $_SERVER['REMOTE_ADDR'];
		$description = $_POST['description'];

		$merchant = new Merchant($ecomm_url, $cert_url, $cert_pass, 1);

		$resp = $merchant -> startDMSAuth($amount, $currency, $ip, $description, $language);

		if (substr($resp,0,14)=="TRANSACTION_ID") {
			$trans_id=urlencode(substr($resp,16,28));
		    $url = $domain."/ecomm/ClientHandler?trans_id=$trans_id";
		    header("Location: $url");
		    $trans_id = substr($resp,16,28);
			$qry  = "INSERT INTO $db_table VALUES ('', '$trans_id', '$amount', '$currency', '$ip', '$description', '$language', 'NO', 'NO', '???', now())";
			  //  $result = @mssql_query();
			  $result  = $db->Query($qry);
		    if (!$result) {
	    		die('*** Invalid query');
		    }
		}else{
			echo "$resp \n";
		}
	break;
	//CASE STARTSMSTRANS
	case 'startsmstrans':
	      $amount = $_POST['amount'];
	      $ip = $_SERVER['REMOTE_ADDR'];
	      $description = $_POST['description'];




	      $merchant = new Merchant($ecomm_url, $cert_url, $cert_pass, 1);

	      $resp = $merchant -> startSMSTrans($amount, $currency, $ip, $description, $language);

	              if (substr($resp,0,14)=="TRANSACTION_ID") {
	                      $trans_id=urlencode(substr($resp,16,28));
	                      $url = $domain."/ecomm/ClientHandler?trans_id=$trans_id";
	                      header("Location: $url");

	                      $trans_id=substr($resp,16,28);
						  $qry = "INSERT INTO $db_table VALUES ('', '$trans_id', '$amount', '$currency', '$ip', '$description', '$language', '---', 'NO', '???', NOW())
	                        ";
						$result = $db->Query($qry);
	                     //  $result = @mssql_query();

	                        if (!$result) {
	                            die('*** Invalid query');
	                        }

	              }
	              else{
	                      echo "$resp \n";
	              }
	break;




	//CASE SELECT
	case 'select':
	echo '<a href="?action=form_dms">DMS</a> | <a href="?action=form_sms">SMS</a>';
	         $qry = "SELECT * FROM $db_table ORDER by `id` ASC";
			 
			 $result = $db->Query($qry); 
			 //  $result = @mssql_query();

	      if (!$result) {

	         die('Invalid query: ');
	      }

	      echo "<table width='100%'>
	      <tr bgcolor=\"#c8c8c8\">
	            <td>id</td>
	            <td>date</td>
	            <td>trans_id</td>
	            <td>amount</td>
	            <td>currency</td>
	            <td>ip</td>
	            <td>description</td>
	            <td>language</td>
	            <td>RESULT CODE</td>


	            <td>DMS</td>
	            <td>Reverse</td>
	      </tr>";

		while($row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC)){
	      //while ($row = @mssql_fetch_row($result)) {

	      if($row[9] == '000'){
	      $color = "bgcolor=\"#b0f0b0\"";
	      }elseif($row[9] == '???'){
	      $color = "bgcolor=\"#f3f3f3\"";
	      }else{
	      $color = "bgcolor=\"#ffbaba\"";
	      }


	       if($row[7] == 'YES' AND $row[8] == 'YES'){
	      $makedmstrans = '            <td style="color: gray;">DMS done</td>';

	      }elseif($row[7]=='---' || $row[9] != '000' || $row[8] == 'YES'){
	        $makedmstrans = '            <td>---</td>';

	      }elseif($row[7] == 'YES'){
	      $makedmstrans = '            <td style="color: gray;">DMS done</td>';

	      }else{
	        $makedmstrans = "            <td><a href='?action=makedmstrans&id=".$row[0]."'>makeDMStrans</a></td>";
	      }








	      if($row[8]=='YES'){
	      $reverse = '  <td style="color: gray;">Reversed</td>';

	      }elseif($row[9] != '000'){
	      $reverse = '  <td style="color: gray;">---</td>';

	      }else{
	      $reverse = " <td><a href='?action=confirm_reverse&id=".$row[0]."'>REVERSE</a></td>";
	      }

	                      printf("
	      <tr bgcolor=\"#f3f3f3\">
	            <td>%s</td>
	            <td>%s</td>
	            <td>%s</td>
	            <td>%s</td>
	            <td>%s</td>
	            <td>%s</td>
	            <td>%s</td>
	            <td>%s</td>
	            <td %s>%s</td>


	             %s
	              %s

	      </tr>
	                   ",
	                      $row[0], $row[10], $row[1], $row[2], $row[3], $row[4], $row[5], $row[6], $color, $row[9], $makedmstrans, $reverse);
	                  }


	      echo "</table><br><br><br>To close business day, press this link -->>  <a href='?action=close'>Close BD</a><br>";


	      //mssql_close($link);
	break;

	//CASE DELETE
	case 'delete':
	          $id = $_GET['id'];
			  $qry = "DELETE FROM $db_table WHERE id='$id'";
			  $result = $db->Query($qry);
	        //  $result = @mssql_query();

	          if (!$result) {
	              die('*** Invalid query');
	          }else{

	          echo "id=".$id." deleted!";
	          echo '<META HTTP-EQUIV="Refresh" CONTENT="1;URL=?action=select">';

	          }
	          //@mssql_close($link);

	break;


	//CASE CLOSE BUSINESS DAY
	case 'close':
	        $merchant = new Merchant($ecomm_url, $cert_url, $cert_pass, 1);

	        $resp = $merchant -> closeDay();
	        echo $resp;


	        echo '<br><br><a href="?action=select">Back to Transaction list</a><br>';


	break;




	//CASE MAKE DMS TRANS
	case 'makedmstrans':
		$id = $_GET['id']; //for getting MySQL data

		$merchant = new Merchant($ecomm_url, $cert_url, $cert_pass, 1);
				$qry = "SELECT * FROM $db_table WHERE `id`='$id'";
				$result  = $db->Query($qry);
		     // $result = @mssql_query();
		      if (!$result) {
		          die('*** Invalid query');
		      }
						$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		              //$row = @mssql_fetch_row($result);
		              $auth_id = urlencode($row[1]);
		              $amount = urlencode($row[2]);
		              $currency = urlencode($row[3]);
		              $ip = urlencode($row[4]);
		              $desc = urlencode($row[5]);
		              $language = urlencode($row[6]);


		$resp = $merchant -> makeDMSTrans($auth_id, $amount, $currency, $ip, $desc, $language);
		if (substr($resp,8,2)=="OK") {
			$trans_id = $row[1];
			$qry = "UPDATE $db_table SET `dms_ok` = 'YES' WHERE `trans_id` = '$trans_id'";
			$result = $db->Query($qry);
			//$result = @mssql_query();

			if (!$result) {
				die('*** Invalid query');
			}else{
				echo "DMS OK!";
			}
		}else{
		    echo "ERROR:<br><br> $resp \n";
		}
		echo '<META HTTP-EQUIV="Refresh" CONTENT="2;URL=?action=select">';
	//	@mssql_close($link);
	break;

	//CASE REVERSE
	case 'confirm_reverse':
		$id = $_GET['id']; //for getting MySQL data
		$qry = "SELECT * FROM $db_table WHERE `id`='$id'";
		$result = $db->Query($qry);
		//$result = @mssql_query();
		if (!$result) {
			die('*** Invalid query');
		}
			$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
		//$row = @mssql_fetch_row($result);
		$trans_id = urlencode($row[1]);
		$amount = urlencode($row[2]);

		echo '<form action="?action=reverse&id='.$id.'" method="POST">
		      Reverse amount: <input type="text" name="amount" value="'.$amount.'" /><br>
		      <input type="submit" Value="Reverse" />
		      </form>';
	break;

	//CASE REVERSE
	case 'reverse':
		$id = $_GET['id']; //for getting MySQL data
		$qry = "SELECT * FROM $db_table WHERE `id`='$id'";
		$result = $db->Query($qry);
		//$result = @mssql_query();

		if (!$result) {
		    die('*** Invalid query');
		}
			$row = sqlsrv_fetch_array( $result, SQLSRV_FETCH_ASSOC);
	//	$row = @mssql_fetch_row($result);
		$trans_id = urlencode($row[1]);
		$amount = $_POST['amount'];

		$merchant = new Merchant($ecomm_url, $cert_url, $cert_pass, 1);
		$resp = $merchant -> reverse($trans_id, $amount);
	    if (substr($resp,8,2)=="OK") {
			$trans_id = $row[1];
			$qry = "UPDATE $db_table SET `reverse` = 'YES' WHERE `trans_id` = '$trans_id'";
			$result = $db->Query($qry);
			//$result = @mssql_query();
		 
		    if (!$result) {
    			die('*** Invalid query');
		    }else{
    			echo "Reversed!<br> $resp";
		    }

	    }else{
    		echo "ERROR:<br><br> $resp \n";
	    }
		echo '<br><br><a href="?action=select">Back to Transaction list</a><br>';
	//	@mssql_close($link);
	break;


	//CASE DEFAULT
	default:
		echo '<META HTTP-EQUIV="Refresh" CONTENT="0;URL=?action=form_sms">';
	break;

}
?>