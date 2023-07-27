<?php
    include('../db/config.php');

    $statusCode = 200;
    $statusMsg = "Order successfully deleted";

    $orderId = $_POST['order_id'];

    $query = "DELETE FROM food_order_line WHERE order_id = $orderId";
    $result = mysqli_query($connect, $query);

    $query = "DELETE FROM food_order WHERE order_id = $orderId";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
        $statusMsg = "Order failed to delete";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>