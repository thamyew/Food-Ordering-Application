<?php
    include('../db/config.php');

    $statusCode = 200;
    $statusMsg = "Orders successfully deleted";

    $orderQuery = "SELECT * FROM food_order WHERE order_archived = 1";
    $orderResult = mysqli_query($connect, $orderQuery);
    $orderCount = mysqli_num_rows($orderResult);
    
    if ($orderCount > 0) {
        while($orderRow = mysqli_fetch_assoc($orderResult)) {
            $orderId = $orderRow['order_id'];
            $deleteLineQuery = "DELETE FROM food_order_line WHERE order_id = $orderId";
            $deleteLineResult = mysqli_query($connect, $deleteLineQuery);
        }

        $query = "DELETE FROM food_order WHERE order_archived = 1";
        $result = mysqli_query($connect, $query);

        if (!$result) {
            $statusCode = 404;
            $statusMsg = "Orders failed to delete";
        }
    }    

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>