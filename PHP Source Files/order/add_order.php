<?php
    $statusCode = 200;
    $statusMsg = "Update order status sucessfully";

    include ('../db/config.php');

    $username = $_POST['username'];
    $cartId = $_POST['cart_id'];
    $orderRemark = mysqli_real_escape_string($connect, $_POST['order_remark']);
    $subtotal_price = $_POST['subtotal_price'];
    $total_price = $_POST['total_price'];

    // Create Order
    $orderQuery = "INSERT INTO food_order(order_remark, subtotal_price, total_price, customer_username) VALUES ('$orderRemark', $subtotal_price, $total_price, '$username')";
    $orderResult = mysqli_query($connect, $orderQuery);

    $orderQuery = "SELECT MAX(order_id) AS order_id FROM food_order WHERE customer_username = '$username'";
    $orderResult = mysqli_query($connect, $orderQuery);
    $orderRow = mysqli_fetch_assoc($orderResult);
    $orderId = $orderRow['order_id'];

    // Create Order Item
    $itemQuery= "SELECT * FROM food_order_cart_line WHERE cart_id = $cartId";
    $itemResult = mysqli_query($connect, $itemQuery);
    $itemCount = mysqli_num_rows($itemResult);

    if ($itemCount > 0) {
        while ($itemRow = mysqli_fetch_assoc($itemResult)) {
            $itemId = $itemRow['food_id'];
            $itemQuantity = $itemRow['quantity'];
            
            $foodQuery = "SELECT * FROM food WHERE food_id = $itemId";
            $foodResult = mysqli_query($connect, $foodQuery);
            $foodRow = mysqli_fetch_assoc($foodResult);
            $foodName = $foodRow['food_name'];
            $foodPrice = $foodRow['food_price'];

            $orderItemQuery = "INSERT INTO food_order_line VALUES($orderId, $itemId, '$foodName', $itemQuantity, $foodPrice)";
            $orderItemResult = mysqli_query($connect, $orderItemQuery);
        }
    }

    $deleteOrderCartLineQuery = "DELETE FROM food_order_cart_line WHERE cart_id = $cartId";
    $deleteOrderCartLineResult = mysqli_query($connect, $deleteOrderCartLineQuery);

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>