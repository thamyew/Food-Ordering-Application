<?php
    include("../db/config.php");

    $username = $_POST["username"];
    $statusCode = 200;

    $query = "INSERT INTO spending (customer_username) VALUES ('$username')";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
    }

    echo json_encode($statusCode);

    mysqli_close($connect);
?>