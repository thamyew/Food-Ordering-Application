<?php
    include('../db/config.php');

    $username = $_POST['username'];
    $level = $_POST['level'];

    $archivedQuery = "SELECT * FROM food_order WHERE order_archived = 1 AND order_archived_expiry_date < NOW()";
    $archivedResult = mysqli_query($connect, $archivedQuery);
    $archivedCount = mysqli_num_rows($archivedResult);

    if ($archivedCount > 0) {
        while ($archivedRow = mysqli_fetch_assoc($archivedResult)) {
            $tempOrderId = $archivedRow['order_id'];
            $deleteLineQuery = "DELETE FROM food_order_line WHERE order_id = $tempOrderId";
            $deleteLineResult = mysqli_query($connect, $deleteLineQuery);

            $deleteFeedbackQuery = "DELETE FROM feedback WHERE order_id = $tempOrderId";
            $deleteFeedbackResult = mysqli_query($connect, $deleteFeedbackQuery);

            $deleteOrderQuery = "DELETE FROM food_order WHERE order_id = $tempOrderId";
            $deleteOrderResult = mysqli_query($connect, $deleteOrderQuery);
        }
    }

    if ($level == 0) {
        $archivedQuery = "SELECT * FROM food_order WHERE order_archived = 1";
    } else {
        $archivedQuery = "SELECT * FROM food_order WHERE customer_username = '$username' AND order_archived = 1";
    }

    $archivedResult = mysqli_query($connect, $archivedQuery);
    $archivedCount = mysqli_num_rows($archivedResult);

    if ($archivedCount > 0) {
        while ($archivedRow = mysqli_fetch_assoc($archivedResult)) {
            $tempOrderId = $archivedRow['order_id'];

            $foodQuery = "SELECT * FROM food_order_line WHERE order_id = $tempOrderId";
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

            $orderDateTime = $archivedRow['order_date_time'];
            $orderRemark = $archivedRow['order_remark'];
            $orderStatus = $archivedRow['order_status'];
            $orderTotal = $archivedRow['total_price'];
            $orderCustomerUsername = $archivedRow['customer_username'];

            $foodOrderArray[] = array(
                'order_id' => (int)$tempOrderId,
                'order_date_time' => $orderDateTime,
                'order_status' => (int)$orderStatus,
                'order_total' => $orderTotal,
                'customer_username' => $orderCustomerUsername,
                'order_remark' => $orderRemark,
                'order_lines' => $order,
            );
        }

        echo json_encode($foodOrderArray);
    } else {
        echo json_encode(404);
    }

    mysqli_close($connect);
?>