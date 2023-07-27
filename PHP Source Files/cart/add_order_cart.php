<?php
    function addCart($connection, $username) {
        $query = "INSERT INTO food_order_cart (cart_customer_username) VALUES ('$username')";
        $result = mysqli_query($connection, $query);

        if ($result) {
            return 200;
        }
        
        return 404;
    }
?>