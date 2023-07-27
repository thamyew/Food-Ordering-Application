<?php
    include('../db/config.php');

    $statusCode = 404;
    $statusMsg = "Order failed to completed";

    $orderId = $_POST['order_id'];

    $orderQuery = "SELECT * FROM food_order WHERE order_id = $orderId";
    $orderResult = mysqli_query($connect, $orderQuery);
    $orderRow = mysqli_fetch_assoc($orderResult);
    $orderStatus = $orderRow['order_status'];

    if ($orderStatus == 2) {
        $expFormat = mktime(
            date("H"),
            date("i"),
            date("s"),
            date("m"), date("d") + 180,
            date("Y")
        );
    
        $expDate = date("Y-m-d H:i:s", $expFormat);
    
        $archiveQuery = "UPDATE food_order SET order_status = 3, order_archived = 1, order_archived_expiry_date = '$expDate' WHERE order_id = $orderId";
        $archiveResult = mysqli_query($connect, $archiveQuery);
        
        $statusCode = 200;
        $statusMsg = "Order completed successfully";

        $username = $orderRow['customer_username'];
        $orderPrice = $orderRow['total_price'];

        include("../spending/update_spending.php");
        include("../earning/update_earning.php");
        include('../achievement/achievement_checking.php');

        $result = updateSpending($connect, $username, $orderPrice);

        if ($result == 404) {
            $statusCode = 404;
            $statusMsg = "Update Spending Failed";
        }

        $result = updateEarning($connect, $orderPrice);

        if ($result == 404) {
            $statusCode = 404;
            $statusMsg = "Update Earning Failed";
        }

        checkingAchievement($connect, $username);
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>