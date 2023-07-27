<?php
    include('../db/config.php');

    $username = $_POST['username'];
    $fcmToken = $_POST['fcm_token'];
    $level = $_POST['level'];

    $query = "INSERT INTO fcm_token VALUES('$username', '$fcmToken', $level)";
    $result = mysqli_query($connect, $query);

    if ($result) {
        echo json_encode(200);
    } else {
        echo json_encode(404);
    }

    mysqli_close($connect);
?>