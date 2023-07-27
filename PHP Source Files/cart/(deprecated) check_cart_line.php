<?php
    include("../db/config.php");

    $foodId = $_POST["food_id"];
    $cartId = $_POST["cart_id"];

    $query = "SELECT * FROM food_order_cart_line WHERE cart_id = $cartId AND food_id = $foodId";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);

    if ($count > 0) {
        echo json_encode(1);
    } else {
        echo json_encode(0);
    }

    mysqli_close($connect);
?>