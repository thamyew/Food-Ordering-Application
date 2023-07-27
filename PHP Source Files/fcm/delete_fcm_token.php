<?php
    include('../db/config.php');
    include('delete_fcm_token_func.php');

    $username = $_POST['username'];

    $result = deleteFCM($connect, $username);

    if ($result == 200) {
        echo json_encode(200);
    } else {
        echo json_encode(404);
    }

    mysqli_close($connect);
?>