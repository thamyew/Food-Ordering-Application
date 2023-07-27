<?php
    // Include the database config
    include('../db/config.php');

    $statusCode = 200;
    $statusMsg;

    // Variable to store the current login user's username and updated phone number [TO BE SENT FROM FLUTTER APP]
    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $updated_phone_num = mysqli_real_escape_string($connect, $_POST['phoneNum']);

    // SQL Query
    $query = "SELECT * FROM userinfo WHERE phone_num = '$updated_phone_num'";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);
    
    // Check if updated phone number exists in database
    if ($count == 0) {
        // SQL query to update phone number
        $query = "UPDATE userinfo SET phone_num = '$updated_phone_num' WHERE username = '$username'";
        $result = mysqli_query($connect, $query);
        
        // Check if query success
        if (!$result) {
            $statusCode = 404;
            $statusMsg = "No User Found";
        } else {
            $statusMsg = "Successful Update Phone Number";
        }
    }
    else {
        $row = mysqli_fetch_assoc($result);
        $current_phone_num = $row['phone_num'];

        if ($updated_phone_num == "$current_phone_num") {
            $statusMsg = "Phone Number Not Changed";
        }
        else {
            $statusMsg = "There is some problem";
            $statusCode = 404;
        }
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    // Close connection
    mysqli_close($connect);
?>