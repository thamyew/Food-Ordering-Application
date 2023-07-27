<?php
    include('../db/config.php');

    $action = $_POST['action'];
    $orderID = $_POST['order_id'];

    $orderQuery = "SELECT * FROM food_order WHERE order_id = $orderID";
    $orderResult = mysqli_query($connect, $orderQuery);
    $orderRow = mysqli_fetch_assoc($orderResult);

    $orderUsername = $orderRow['customer_username'];

    $userQuery = "SELECT * FROM fcm_token WHERE username = '$orderUsername'";
    $userResult = mysqli_query($connect, $userQuery);
    $userCount = mysqli_num_rows($userResult);

    $userDeviceToken;

    if ($userCount > 0) {
        $userRow = mysqli_fetch_assoc($userResult);
        $userDeviceToken = $userRow['token'];

        $url = "https://fcm.googleapis.com/fcm/send";
        $token = $userDeviceToken;
        $serverKey = 'AAAAwLZInF4:APA91bFZ5C1Xete3N8aK4vCmj4--8JqJlXYZOUrp-P5vsFqFXn7hwOFFDSPa7CrTI1b2_9pNrzQBRGhcwvsbSAKlwFxvMm7XWayyyqKBB89DROQ2JIYhteKNk-9vnN1Z_BMe86G0VQvM';

        if ($action == "Accept") {
            $title = "Order Accepted!";
            $body = "Your order with order's ID: $orderID has been accepted!";
        } else if ($action == "Reject") {
            $title = "Order Rejected!";
            $body = "Your order with order's ID: $orderID has been rejected!";
        } else if ($action == "Ready") {
            $title = "Order Ready to Pickup!";
            $body = "Your order with order's ID: $orderID is ready to pick up!";
        } else if ($action == "Complete") {
            $title = "Order Marked as Completed!";
            $body = "Your order with order's ID: $orderID has been collected and marked as completed!";
        }

        $notification = array('title' => $title , 'body' => $body, 'sound' => 'default', 'badge' => '1');
        $arrayToSend = array('to' => $token, 'notification' => $notification,'priority'=>'high');
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
    }

    mysqli_close($connect);
?>