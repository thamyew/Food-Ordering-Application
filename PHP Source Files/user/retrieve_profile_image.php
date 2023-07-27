<?php
    // Include the database configuration file
    include('../db/config.php');
    
    $statusCode = 200;

    // Variable to store the current login user's profile picture id [TO BE SENT FROM FLUTTER APP]
    $profile_pic_id = mysqli_real_escape_string($connect, $_POST['id']);

    // Get images from the database
    $query = "SELECT * FROM images WHERE id = '$profile_pic_id'";
    $result = mysqli_query($connect, $query);

    // Check if the query is success
    if($result->num_rows > 0) {
        // Get the URL of the image
        $row = mysqli_fetch_assoc($result);

        $returnArray[] = array(
            "statusCode" => $statusCode,
            "profile_pic_id" => (int)$row['id'],
            "filename" => $row['file_name'],
            "path" => $row['path']
        );

        // Echo back the data
        echo json_encode($returnArray);
    } else {
        $statusCode = 404;
        echo json_encode($statusCode);
    }
        
?>
