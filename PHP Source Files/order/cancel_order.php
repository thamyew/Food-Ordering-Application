<?php
    include('../db/config.php');

    $statusCode = 404;
    $statusMsg = "Order failed to cancel";

    $orderId = $_POST['order_id'];

    $query = "SELECT * FROM food_order WHERE order_id = $orderId";
    $result = mysqli_query($connect, $query);
    $row = mysqli_fetch_assoc($result);

    if ($row['order_status'] == 0) {
        $expFormat = mktime(
            date("H"),
            date("i"),
            date("s"),
            date("m"), date("d") + 180,
            date("Y")
        );

        $expDate = date("Y-m-d H:i:s", $expFormat);

        $archiveQuery = "UPDATE food_order SET order_status = 4, order_archived = 1, order_archived_expiry_date = '$expDate' WHERE order_id = $orderId";
        $archiveResult = mysqli_query($connect, $archiveQuery);

        $orderUser = $row['customer_username'];

        include('../achievement/achievement_checking.php');
        checkingAchievement($connect, $orderUser);

        $statusCode = 200;
        $statusMsg = "Order successfully cancelled";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>