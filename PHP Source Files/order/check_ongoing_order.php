<?php
    include('../db/config.php');

    $username = $_POST['username'];

    $query = "SELECT * FROM food_order WHERE customer_username = '$username' AND order_status < 3";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);
    
    if ($count > 0) {
        echo json_encode(404);
    } else {
        echo json_encode(200);
    }

    mysqli_close($connect);
?>