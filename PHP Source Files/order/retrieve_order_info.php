<?php
    include('../db/config.php');

    $statusCode = 200;

    $orderId = $_POST['order_id'];

    $query = "SELECT * FROM food_order WHERE order_id = $orderId";
    $result = mysqli_query($connect, $query);

    if ($result) {
        $row = mysqli_fetch_assoc($result);

        $foodQuery = "SELECT * FROM food_order_line WHERE order_id = $orderId";
        $foodResult = mysqli_query($connect, $foodQuery);

        $order = array();

        while ($foodRow = mysqli_fetch_assoc($foodResult)) {
            $foodId = $foodRow['food_id'];
            $foodName = $foodRow['food_name'];
            $foodQuantity = $foodRow['quantity'];
            $foodPerPrice = $foodRow['per_price'];

            $tempArray = array(
                'food_id' => (int)$foodId,
                'food_name' => $foodName,
                'food_quantity' => (int)$foodQuantity,
                'food_per_price' => $foodPerPrice,
            );

            $order[] = $tempArray;
        }

        $feedbackQuery = "SELECT * FROM feedback WHERE order_id = $orderId";
        $feedbackResult = mysqli_query($connect, $feedbackQuery);
        $feedbackCount = mysqli_num_rows($feedbackResult);

        if ($feedbackCount > 0) {
            $feedbackRow = mysqli_fetch_assoc($feedbackResult);
            $feedback = $feedbackRow['content'];
        } else {
            $feedback = "-1";
        }

        $orderDateTime = $row['order_date_time'];
        $orderRemark = $row['order_remark'];
        $orderStatus = $row['order_status'];
        $orderSubtotal = $row['subtotal_price'];
        $orderTotal = $row['total_price'];
        $orderCustomerUsername = $row['customer_username'];
        $orderArchived = $row['order_archived'];
        $orderArchivedExpiryDate = $row['order_archived_expiry_date'];

        if ($orderArchivedExpiryDate == null) {
            $orderArchivedExpiryDate = "";
        }

        $returnArray[] = array(
            'order_id' => (int)$orderId,
            'order_date_time' => $orderDateTime,
            'order_status' => (int)$orderStatus,
            'order_subtotal' => $orderSubtotal,
            'order_total' => $orderTotal,
            'customer_username' => $orderCustomerUsername,
            'order_remark' => $orderRemark,
            'order_archived' => (int)$orderArchived,
            'archived_expiry_date' => $orderArchivedExpiryDate,
            'order_lines' => $order,
            'order_feedback' => $feedback,
        );

        echo json_encode($returnArray);
    } else {
        $statusCode = 404;
        echo json_encode($statusCode);
    }

    // Close connection
    mysqli_close($connect);
?>