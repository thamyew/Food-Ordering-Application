<?php
    $statusCode = 200;
    $statusMsg = "Update order status sucessfully";

    include ('../db/config.php');

    $orderId = $_POST['order_id'];

    $query = "UPDATE food_order SET order_status = 2 WHERE order_id = $orderId";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 200;
        $statusMsg = "Update order status failed";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>