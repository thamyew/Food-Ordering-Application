<?php
    include('../db/config.php');

    $username = $_POST['username'];
    $fcmToken = $_POST['fcm_token'];

    $query = "UPDATE fcm_token SET token = '$fcmToken' WHERE username = '$username'";
    $result = mysqli_query($connect, $query);

    if ($result) {
        echo json_encode(200);
    } else {
        echo json_encode(404);
    }

    mysqli_close($connect);
?>