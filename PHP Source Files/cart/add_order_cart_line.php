<?php
    $statusCode = 200;
    $statusMsg = "Order Added Successfully";

    include ('../db/config.php');

    $cartId = $_POST['cart_id'];
    $foodId = $_POST['food_id'];
    $foodQuantity = $_POST['food_quantity'];

    $checkQuery = "SELECT * FROM food_order_cart_line WHERE cart_id = $cartId AND food_id = $foodId";
    $checkResult = mysqli_query($connect, $checkQuery);
    $checkCount = mysqli_num_rows($checkResult);

    $foodQuery = "SELECT * FROM food WHERE food_id = $foodId";
    $foodResult = mysqli_query($connect, $foodQuery);
    $foodRow = mysqli_fetch_assoc($foodResult);

    $foodPrice = $foodRow['food_price'];

    if ($checkCount > 0) {
        $checkRow = mysqli_fetch_assoc($checkResult);
        $currQuantity = $checkRow['quantity'];
        $newQuantity = $foodQuantity + $currQuantity;
        $cartOrderQuery = "UPDATE food_order_cart_line SET quantity = $newQuantity WHERE food_id = $foodId";
        $cartOrderResult = mysqli_query($connect, $cartOrderQuery);
    } else {
        $cartOrderQuery = "INSERT INTO food_order_cart_line VALUES ('$cartId', '$foodId', $foodQuantity)";
        $cartOrderResult = mysqli_query($connect, $cartOrderQuery);
    }

    if (!$cartOrderResult) {
        $statusCode = 404;
        $statusMsg = "Order Failed to Added";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>