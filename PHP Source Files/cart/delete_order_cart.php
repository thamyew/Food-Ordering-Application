<?php
    function deleteCart($username, $connect) {
        $query = "SELECT * FROM food_order_cart WHERE cart_customer_username = '$username'";
        $result = mysqli_query($connect, $query);
        $row = mysqli_fetch_assoc($result);

        $cartId = $row['cart_id'];

        $cartOrderQuery = "DELETE FROM food_order_cart_line WHERE cart_id = $cartId";
        $cartOrderResult = mysqli_query($connect, $cartOrderQuery);

        if (!$cartOrderResult) {
            $statusCode = 404;
            $statusMsg = "Orders Failed to Delete";
        }

        $query = "DELETE FROM food_order_cart WHERE cart_id = $cartId";
        $result = mysqli_query($connect, $query);

        if ($result) {
            $statusMsg = "Food cart deleted successfully";
        } else {
            $statusCode = 404;
            $statusMsg = "Food cart deleted failed";
        }
    }
?>