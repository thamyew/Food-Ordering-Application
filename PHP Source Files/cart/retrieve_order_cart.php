<?php
    $statusCode = 200;
    $statusMsg = "Order Retrieved Successfully";

    include ('../db/config.php');

    $username = $_POST['username'];

    $cartQuery = "SELECT * FROM food_order_cart WHERE cart_customer_username = '$username'";
    $cartResult = mysqli_query($connect, $cartQuery);
    $cartRow = mysqli_fetch_assoc($cartResult);
    $cartId = $cartRow['cart_id'];

    $orderLineQuery = "SELECT * FROM food_order_cart_line WHERE cart_id = $cartId";
    $orderLineResult = mysqli_query($connect, $orderLineQuery);
    $orderLineCount = mysqli_num_rows($orderLineResult);
    
    if ($orderLineCount > 0) {
        while($orderLineRow = mysqli_fetch_assoc($orderLineResult)) {

            $foodId = $orderLineRow['food_id'];
            $foodQuery = "SELECT * FROM food WHERE food_id = $foodId";
            $foodResult = mysqli_query($connect, $foodQuery);
            $foodRow = mysqli_fetch_assoc($foodResult);

            $foodName = $foodRow['food_name'];
            $foodQuantity = $orderLineRow['quantity'];
            $foodPerPrice = $foodRow['food_price'];
            $foodImgId = $foodRow['food_img_id'];

            $foodImgQuery = "SELECT CONCAT(path, file_name) AS img_location FROM images WHERE id = $foodImgId";
            $foodImgResult = mysqli_query($connect, $foodImgQuery);
            $foodImgRow = mysqli_fetch_assoc($foodImgResult);

            $foodImgLocation = $foodImgRow['img_location'];

            $tempArray = array(
                'food_id' => (int)$foodId,
                'food_name' => $foodName,
                'food_quantity' => (int)$foodQuantity,
                'food_per_price' => $foodPerPrice,
                'food_img_location' => $foodImgLocation,
            );

            $order[] = $tempArray;
        }

        $returnArray[] = array(
            'cart_id' => (int)$cartId,
            'orders' => $order,
        );
    } else {
        $returnArray = 404;
    }

    echo json_encode($returnArray);

    mysqli_close($connect);
?>