<?php
    include('../db/config.php');

    $username = $_POST['username'];

    $query = "SELECT * FROM fcm_token WHERE username = '$username'";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);

    if ($count == 1) {
        echo json_encode(1);
    } else {
        echo json_encode(0);
    }

    mysqli_close($connect);
?>