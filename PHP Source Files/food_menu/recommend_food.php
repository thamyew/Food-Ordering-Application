<?php
    include('../db/config.php');

    $statusCode = 200;

    $foodId = $_POST['food_id'];
    $foodRecommend = $_POST['food_recommend'];

    $query = "UPDATE food SET food_recommend = $foodRecommend WHERE food_id = $foodId";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
    }

    echo json_encode($statusCode);

    // Close connection
    mysqli_close($connect);    
?>