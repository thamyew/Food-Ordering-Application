<?php
    include("../db/config.php");

    $foodId = $_POST["food_id"];
    $username = $_POST["username"];

    $query = "SELECT * FROM food_rating WHERE food_id = $foodId AND customer_username = '$username'";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);

    if ($count > 0) {
        $row = mysqli_fetch_assoc($result);
        echo json_encode((int)$row['rating']);
    } else {
        echo json_encode(-1);
    }

    mysqli_close($connect);
?>