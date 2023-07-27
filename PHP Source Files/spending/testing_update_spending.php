<?php
include('../db/config.php');
include('update_spending.php');

$data = updateSpending($connect, "ahmad", 20);

echo $data == 200 ? "Success" : "Failed";

mysqli_close($connect);
?>