<?php
    header('Content-Type: application/json');
    // Include the database configuration file
    include('../db/config.php');

    $statusMsg = "";
    $statusCode = 200;

    // Variable to store the current login user's username [TO BE SENT FROM FLUTTER APP]
    $username = mysqli_real_escape_string($connect, $_POST['username']);

    // SQL Query
    $query = "SELECT * FROM userinfo WHERE username = '$username'";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);
    
    // Check if the user is found
    if ($count == 1) {
        // Fetching data from database
        $row = mysqli_fetch_assoc($result);

        // Echo back the details of the user stored in the database in JSON format
        $username = $row['username'];
        $email = $row['email'];
        $name = $row['name'];
        $gender = $row['gender'];
        $address = $row['address'];
        $phoneNum = $row['phone_num'];
        $profilePicId = $row['profile_pic_id'];
        $statusMsg = "Success";
        
        $returnArray[] = array(
            "statusCode" => $statusCode,
            "statusMsg" => $statusMsg,
            "username" => $username,
            "email" => $email,
            "name" => $name,
            "gender" => $gender,
            "address" => $address,
            "phone_num" => $phoneNum,
            "profile_pic_id" => $profilePicId
        );

        echo json_encode($returnArray);
    }
    else {
        $statusCode = 404;
        // Echo back error when no user or multiple users found
        echo json_encode($statusCode);
    }

    // Close connection
    mysqli_close($connect);
?>