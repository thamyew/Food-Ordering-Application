<?php
    // Include the database config
    include('../db/config.php');

    // Variable to store the updated admin password [TO BE SENT FROM FLUTTER APP]
    $updated_admin_password = mysqli_real_escape_string($connect, $_POST['admin_password']);

        // SQL Query
    $query = "UPDATE adminkey SET admin_password = '$updated_admin_password' WHERE id = 1";
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