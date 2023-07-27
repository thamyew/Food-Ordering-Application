<?php
    function deleteOrderLineWithFood($foodId, $connect) {
        $deleteFoodOrderQuery = "DELETE FROM food_order_cart_line WHERE food_id = $foodId";
        $deleteFoodOrderResult = mysqli_query($connect, $deleteFoodOrderQuery);

        if (!$deleteFoodOrderResult) {
            $statusCode = 404;
            $statusMsg = "Order Line Failed to Delete";
        }
    }
?>