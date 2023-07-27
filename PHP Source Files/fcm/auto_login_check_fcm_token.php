<?php
    include('../db/config.php');

    $username = $_POST['username'];
    $fcmToken = $_POST['fcm_token'];

    $query = "SELECT * FROM fcm_token WHERE username = '$username' AND token = '$fcmToken'";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);

    if ($count > 0) {
        echo json_encode(1);
    } else {
        echo json_encode(0);
    }

    mysqli_close($connect);
?>