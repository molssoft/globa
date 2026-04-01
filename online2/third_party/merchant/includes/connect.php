<?PHP
/*
//connect to MySQL server
$link = mssql_connect($db_host, $db_user, $db_pass);
if (!$link) {
    die(' ***Could not connect MySQL server: ');
}

//mssql_query("CREATE DATABASE /*!32312 IF NOT EXISTS*/ /*$db_database");


// connect to DB
$db_selected = mssql_select_db($db_database, $link);
if (!$db_selected) {
    die (' ***Could not connect MySQL DB: ');
}

// mssql_query("CREATE TABLE /*!32312 IF NOT EXISTS*/ /*$db_table  (
      // id INT(10) NOT NULL AUTO_INCREMENT,
      // trans_id VARCHAR(50),
      // amount INT(10),
      // currency INT(10),
      // client_ip_addr VARCHAR(50),
      // description TEXT,
      // language VARCHAR(50),
      // dms_ok VARCHAR(50),
      // reverse VARCHAR(50),
      // result VARCHAR(50),
      // t_date VARCHAR(20),
      // PRIMARY KEY (id)
      // )
      // ");
*/
?>