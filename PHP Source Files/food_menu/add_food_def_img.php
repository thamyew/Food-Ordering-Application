<?php 
    include('../db/config.php');

    // Variable to store status message to be returned
    $statusCode = 200;
    $statusMsg = 'Insert Successful';

    // Variables to store the food information
    $foodName = $_POST["food_name"];
    $foodDesc = $_POST["food_description"];
    $foodPrice = $_POST["food_price"];
    $foodRecommended = $_POST["food_recommend"];

    $query = "INSERT INTO food (food_name, food_description, food_price, food_recommend) VALUES ('$foodName', '$foodDesc', $foodPrice, $foodRecommended)";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
        $statusMsg = 'Insert Failed';
    }
    
    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    // Close connection
    mysqli_close($connect);
?>