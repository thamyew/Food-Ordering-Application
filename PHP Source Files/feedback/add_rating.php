<?php
    include('../db/config.php');

    $statusCode = 200;
    $statusMsg = "Add rating successfully";

    $username = $_POST['username'];
    $foodId = $_POST['food_id'];
    $rating = $_POST['rating'];

    $query = "INSERT INTO food_rating VALUES ($foodId, '$username', $rating)";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
        $statusMsg = "Add rating failed";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg,
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>