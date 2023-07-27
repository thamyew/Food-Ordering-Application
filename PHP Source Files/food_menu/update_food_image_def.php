<?php
    // Include the database config
    include('../db/config.php');

    $foodId = $_POST['food_id'];

    // SQL query to get food picture id
    $query = "SELECT * FROM food WHERE food_id = $foodId";
    $result = mysqli_query($connect, $query);
    $row = mysqli_fetch_assoc($result);

    // Variable to store food picture ID
    $img_id = $row['food_img_id'];
    
    if ($img_id != 2) {
        // SQL query to obtain image information
        $query = "SELECT * FROM images WHERE id = $img_id";
        $result = mysqli_query($connect, $query);
        $row = mysqli_fetch_assoc($result);

        // Variable to store the current food picture name and id
        $img_name = $row['file_name'];
        $img_path = $row['path'];

        $img_file = "../" . $img_path . $img_name;
        unlink($img_file);

        // SQL query to update food image
        $query = "UPDATE food SET food_img_id = 2 WHERE food_id = $foodId";
        $result = mysqli_query($connect, $query);

        // SQL query to delete image information
        $query = "DELETE FROM images WHERE id = $img_id";
        $result = mysqli_query($connect, $query);
    }

    $returnArray[] = array(
        'statusCode' => 200,
        'statusMsg' => "Update Successful"
    );

    echo json_encode($returnArray);

    // Close connection
    mysqli_close($connect);
?>