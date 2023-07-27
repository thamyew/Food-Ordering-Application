<?php
    include('../db/config.php');

    $username = $_POST['username'];
    $level = $_POST['level'];

    if ($level == 0) {
        $orderQuery = "SELECT * FROM food_order WHERE order_archived = 0";
    } else {
        $orderQuery = "SELECT * FROM food_order WHERE customer_username = '$username' AND order_archived = 0";
    }

    $orderResult = mysqli_query($connect, $orderQuery);
    $orderCount = mysqli_num_rows($orderResult);

    if ($orderCount > 0) {
        while($orderRow = mysqli_fetch_assoc($orderResult)) {
            $tempOrderId = $orderRow['order_id'];

            $foodQuery = "SELECT * FROM food_order_line WHERE order_id = $tempOrderId";
            $foodResult = mysqli_query($connect, $foodQuery);

            $order = array();
            
            while($foodRow = mysqli_fetch_assoc($foodResult)) {
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

            $orderDateTime = $orderRow['order_date_time'];
            $orderRemark = $orderRow['order_remark'];
            $orderStatus = $orderRow['order_status'];
            $orderTotal = $orderRow['total_price'];
            $orderCustomerUsername = $orderRow['customer_username'];

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