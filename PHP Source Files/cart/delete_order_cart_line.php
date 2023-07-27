<?php
    $statusCode = 200;
    $statusMsg = "Order Deleted Successfully";

    include ('../db/config.php');

    $cartId = $_POST['cart_id'];
    $foodId = $_POST['food_id'];
    
    $cartOrderQuery = "DELETE FROM food_order_cart_line WHERE cart_id = $cartId AND food_id = $foodId";
    $cartOrderResult = mysqli_query($connect, $cartOrderQuery);

    if (!$cartOrderResult) {
        $statusCode = 404;
        $statusMsg = "Order Failed to Delete";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>