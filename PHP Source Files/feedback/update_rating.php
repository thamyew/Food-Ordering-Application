<?php
    include('../db/config.php');

    $statusCode = 200;
    $statusMsg = "Update rating successfully";

    $username = $_POST['username'];
    $foodId = $_POST['food_id'];
    $rating = $_POST['rating'];

    $query = "UPDATE food_rating SET rating = $rating WHERE food_id = $foodId AND customer_username = '$username'";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
        $statusMsg = "Update rating failed";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg,
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>