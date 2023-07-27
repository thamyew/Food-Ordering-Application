<?php
    // Include the database config
    include('../db/config.php');
    
    // Variable to store the current login user's username and updated address [TO BE SENT FROM FLUTTER APP]
    $username = $_POST['username'];

    // SQL query to get profile picture id
    $query = "SELECT * FROM userinfo WHERE username = '$username'";
    $result = mysqli_query($connect, $query);
    $row = mysqli_fetch_assoc($result);

    // Variable to store profile picture ID
    $img_id = $row['profile_pic_id'];
    
    if ($img_id != 1) {
        // SQL query to obtain image information
        $query = "SELECT * FROM images WHERE id = $img_id";
        $result = mysqli_query($connect, $query);
        $row = mysqli_fetch_assoc($result);

        // Variable to store the current profile picture name and id
        $img_name = $row['file_name'];
        $img_path = $row['path'];

        $img_file = "../" . $img_path . $img_name;
        unlink($img_file);

        // SQL query to update profile image
        $query = "UPDATE userinfo SET profile_pic_id = 1 WHERE username = '$username'";
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