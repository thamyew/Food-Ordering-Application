<?php
    // Include the database config
    include('../db/config.php');

    // Variable to store the current login user's username and updated gender [TO BE SENT FROM FLUTTER APP]
    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $updated_gender = mysqli_real_escape_string($connect, $_POST['gender']);

    $gender_code = 1;

    if ($updated_gender == "male")
        $gender_code = 0;

    // SQL Query
    $query = "UPDATE userinfo SET gender = '$gender_code' WHERE username = '$username'";
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