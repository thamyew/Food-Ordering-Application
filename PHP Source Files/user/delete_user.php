<?php 
    // Include database config
    include('../db/config.php');

    // Variable to store the current login user's username [TO BE SENT FROM FLUTTER APP]
    $username = mysqli_real_escape_string($connect, $_POST['username']);

    // SQL query to get profile picture id
    $query = "SELECT * FROM userinfo WHERE username = '$username'";
    $result = mysqli_query($connect, $query);
    $row = mysqli_fetch_assoc($result);

    // Variable to store profile picture ID
    $img_id = $row['profile_pic_id'];
    $level = $row['level'];

    if ($level == 1) {
        include('../cart/delete_order_cart.php');
        include('../fcm/delete_fcm_token_func.php');
        include('../feedback/delete_rating.php');
        include('../spending/delete_spending.php');
        include('../achievement/delete_achievement_records.php');

        deleteCart($username, $connect);
        deleteFCM($connect, $username);
        deleteRatingUsername($username, $connect);
        deleteSpendingRecord($connect, $username);
        deleteArhievementRecords($connect, $username);

        // $orderQuery = "SELECT * FROM food_order WHERE order_customer_username = '$username' AND order_status < 3";
        // $orderResult = mysqli_query($connect, $orderQuery);
        // $orderCount = mysqli_num_rows($orderResult);

        // if ($orderCount > 0) {
        //     while($orderRow = mysqli_fetch_assoc($orderResult)) {
        //         $orderId = $orderRow['order_id'];
        //         $deleteOrderLineQuery = "DELETE FROM food_order_line WHERE order_id = $orderId";
        //         $deleteOrderLineResult = mysqli_query($connect, $deleteOrderLineQuery);
        //     }

        //     $deleteOrderQuery = "DELETE FROM food_order WHERE order_customer_username = '$username'";
        //     $deleteOrderResult = mysqli_query($connect, $deleteOrderQuery);
        // }
    }

    // SQL query to delete user
    $query = "DELETE FROM userinfo WHERE username = '$username'";
    $result = mysqli_query($connect, $query);

    // Check if the user using default avatar
    if ($img_id != 1) {
        $query = "SELECT * FROM images WHERE id = $img_id";
        $result = mysqli_query($connect, $query);
        $row = mysqli_fetch_assoc($result);

        $fileName = "../" . $row['path'] . $row['file_name'];
        unlink($fileName);

        // SQL query to delete user profile picture if default avatar is not used
        $query = "DELETE FROM images WHERE id = $img_id";
        $result = mysqli_query($connect, $query);
    }

    $statusCode = 200;
    
    // Check if query success
    if (!$result) {
        $statusCode = 404;
    }

    echo json_encode($statusCode);
    
    // Close connection
    mysqli_close($connect);
?>