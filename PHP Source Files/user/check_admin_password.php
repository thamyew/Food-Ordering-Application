<?php
    // Include the database config
    include('../db/config.php');

    // Variable to store the re-enter admin password [TO BE SENT FROM FLUTTER APP]
    $admin_password = mysqli_real_escape_string($connect, $_POST['admin_password']);

    // SQL Query
    $query = "SELECT * FROM adminkey WHERE id = 1";
    $result = mysqli_query($connect, $query);
    $row = mysqli_fetch_assoc($result);

    $statusCode = 200;

    // Check if password entered is correct
    if ($admin_password != $row['admin_password']) 
        $statusCode = 404;
        
    echo json_encode($statusCode);

    // Close connection
    mysqli_close($connect);
?>