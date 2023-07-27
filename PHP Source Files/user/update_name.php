<?php
    // Include the database config
    include('../db/config.php');

    // Variable to store the current login user's username and updated name [TO BE SENT FROM FLUTTER APP]
    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $updated_name = mysqli_real_escape_string($connect, $_POST['name']);

    // SQL Query
    $query = "UPDATE userinfo SET name = '$updated_name' WHERE username = '$username'";
    $result = mysqli_query($connect, $query);
    
    $statusCode = 200;
    
    // Check if query success
    if (!$result) {
        $statusCode = 404;
    }

    echo json_encode($statusCode);

    // Close connection
    mysqli_close($connect);
?>