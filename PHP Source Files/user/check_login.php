<?php
    include('../db/config.php');//read up on php includes https://www.w3schools.com/php/php_includes.asp

    // username and password sent from form
    $myusername=$_POST["username"];
    $mypassword=$_POST["password"];
    
    $query = "SELECT * FROM userinfo WHERE (username='$myusername' OR email='$myusername') AND password='$mypassword'";

    $result = mysqli_query($connect, $query);
    // mysqli_num_row is counting table row
    $count = mysqli_num_rows($result);

    $statusCode = 200;

    if ($count == 1) {
        $row = mysqli_fetch_assoc($result);
        $level = $row['level'];
        $username = $row['username'];
        $cartId = -1;

        if ($level == 1) {
            $cartQuery = "SELECT cart_id FROM food_order_cart WHERE cart_customer_username = '$username'";
            $cartResult = mysqli_query($connect, $cartQuery);
            $cartRow = mysqli_fetch_assoc($cartResult);

            $cartId = $cartRow['cart_id'];
        }

        $returnArray[] = array(
            "statusCode" => $statusCode,
            "username" => $username,
            "level" => (int)$level,
            "cart_id" => (int)$cartId,
        );

        echo json_encode($returnArray);
    }
    else {
        $statusCode = 404;
        echo json_encode($statusCode);
    }
        
    mysqli_close($connect);
?>