<?php
    include('../db/config.php');

    $statusCode = 404;
    $statusMsg = "Order failed to accept";

    $orderId = $_POST['order_id'];

    $query = "SELECT * FROM food_order WHERE order_id = $orderId";
    $result = mysqli_query($connect, $query);
    $row = mysqli_fetch_assoc($result);

    if ($row['order_status'] == 0) {
        $orderQuery = "UPDATE food_order SET order_status = 1 WHERE order_id = $orderId";
        $orderResult = mysqli_query($connect, $orderQuery);

        $statusCode = 200;
        $statusMsg = "Order accepted";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>