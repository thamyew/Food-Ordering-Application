<?php
    include('../db/config.php');

    $statusCode = 200;

    $query = "UPDATE food SET food_archived = 0, archive_expiry_date = NULL WHERE food_archived = 1";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
    }

    echo json_encode($statusCode);

    // Close connection
    mysqli_close($connect);    
?>