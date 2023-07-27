<?php
    $statusCode = 200;
    $statusMsg = "Order Quantity Changed Successfully";

    include ('../db/config.php');

    $cartId = $_POST['cart_id'];
    $foodId = $_POST['food_id'];
    $increment = $_POST['increment'];
    
    $cartOrderQuery = "SELECT * FROM food_order_cart_line WHERE cart_id = $cartId AND food_id = $foodId";
    $cartOrderResult = mysqli_query($connect, $cartOrderQuery);
    $cartOrderRow = mysqli_fetch_assoc($cartOrderResult);
    $currQuantity = $cartOrderRow['quantity'];

    $updatedQuantity = $currQuantity + $increment;

    $cartOrderQuery = "UPDATE food_order_cart_line SET quantity = $updatedQuantity WHERE cart_id = $cartId AND food_id = $foodId";
    $cartOrderResult = mysqli_query($connect, $cartOrderQuery);

    if (!$cartOrderResult) {
        $statusCode = 404;
        $statusMsg = "Order Quantity Failed to Change";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>