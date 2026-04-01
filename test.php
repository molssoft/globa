<?php
// Server and instance name
$serverName = "ser-db3\MSSQL2008"; // Update with your server and instance details

// Connection options
$connectionOptions = array(
    "Database" => "globa",  // Database name
    "Uid" => "www",            // Database username
    "PWD" => "www",             // Database password
	"TrustServerCertificate" => "true"
);

// Establishing the connection
$conn = sqlsrv_connect($serverName, $connectionOptions);

// Check if the connection is successful
if ($conn) {
    echo "Connection established to the instance.";
} else {
    echo "Connection could not be established.";
    die(print_r(sqlsrv_errors(), true)); // Printing any connection errors
}

// Close the connection
sqlsrv_close($conn);
?>