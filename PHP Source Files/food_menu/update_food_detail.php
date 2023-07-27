<?php 
    include('../db/config.php');

    // Variable to store status message to be returned
    $statusCode = 200;
    $statusMsg = 'Update Successful';

    // Variables to store the food information
    $foodId = $_POST['food_id'];
    $foodName = $_POST["food_name"];
    $foodDesc = $_POST["food_description"];
    $foodPrice = $_POST["food_price"];

    $query = "UPDATE food SET food_name = '$foodName', food_description = '$foodDesc', food_price = $foodPrice WHERE food_id = $foodId";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
        $statusMsg = "There exists some problems in changing the food details";
    }
    
    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    // Close connection
    mysqli_close($connect);
?>