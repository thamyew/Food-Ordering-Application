<?php
    include('../db/config.php');

    $username = $_GET['username'];
    $action = $_GET['action'];
    $orderID = $_GET['order_id'];

    if ($action == "Add") {
        $orderQuery = "SELECT MAX(order_id) as newOrderId FROM food_order WHERE order_customer_username = '$username' AND order_archived = 0";
        $orderResult = mysqli_query($connect, $orderQuery);
        $orderRow = mysqli_fetch_assoc($orderResult);
        $orderID = $orderRow['newOrderId'];
    }

    $adminQuery = "SELECT * FROM fcm_token WHERE token_level = 0";
    $adminResult = mysqli_query($connect, $adminQuery);
    $adminCount = mysqli_num_rows($adminResult);

    $adminDeviceToken = array();

    if ($adminCount > 0) {
        while($adminRow = mysqli_fetch_assoc($adminResult)) {
            $tempToken = $adminRow['token'];
            $adminDeviceToken[] = $tempToken;
        }
    }

    $url = "https://fcm.googleapis.com/fcm/send";
    $token = $adminDeviceToken;
    $serverKey = 'AAAAwLZInF4:APA91bFZ5C1Xete3N8aK4vCmj4--8JqJlXYZOUrp-P5vsFqFXn7hwOFFDSPa7CrTI1b2_9pNrzQBRGhcwvsbSAKlwFxvMm7XWayyyqKBB89DROQ2JIYhteKNk-9vnN1Z_BMe86G0VQvM';
    
    if ($action == "Add") {
        $title = "New Order!";
        $body = "You have new order pending for your action!\nThe new order's ID: $orderID";
    } else if ($action = "Cancel") {
        $title = "Order Cancelled!";
        $body = "The order with order ID: $orderID is cancelled.";
    }

    $notification = array('title' => $title , 'body' => $body, 'sound' => 'default', 'badge' => '1');
    $arrayToSend = array('registration_ids' => $token, 'notification' => $notification,'priority'=>'high');
    $json = json_encode($arrayToSend);
    $headers = array();
    $headers[] = 'Content-Type: application/json';
    $headers[] = 'Authorization: key='. $serverKey;
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST,"POST");
    curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
    curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
    //Send the request
    $response = curl_exec($ch);
    //Close request
    if ($response === FALSE) {
        die('FCM Send Error: ' . curl_error($ch));
    }
    curl_close($ch);
    mysqli_close($connect);
?>