<?php
    // Include the database config
    include('../db/config.php');

    // Variable to store the current login user's username and re-enter password [TO BE SENT FROM FLUTTER APP]
    $username = $_POST['username'];
    $password = $_POST['password'];

    // SQL Query
    $query = "SELECT * FROM userinfo WHERE username = '$username' AND password = '$password'";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);

    $statusCode = 200;

    // Check if password entered is correct
    if ($count == 0) {
        $statusCode = 404;
    }
        
    echo json_encode($statusCode);

    // Close connection
    mysqli_close($connect);
?>