<?php
    // Include the database config
    include('../db/config.php');

    $statusCode = 200;
    $statusMsg;

    // Variable to store the current login user's username and updated email [TO BE SENT FROM FLUTTER APP]
    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $updated_email = mysqli_real_escape_string($connect, $_POST['email']);

    // SQL Query
    $query = "SELECT * FROM userinfo WHERE email = '$updated_email'";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);
    
    // Check if updated email exists in database
    if ($count == 0) {
        // SQL query to update email
        $query = "UPDATE userinfo SET email = '$updated_email' WHERE username = '$username'";
        $result = mysqli_query($connect, $query);
        
        // Check if query success
        if (!$result) {
            $statusCode = 404;
            $statusMsg = "No User Found";
        } else {
            $statusMsg = "Email Updated Successfully";
        }
    }
    else {
        $row = mysqli_fetch_assoc($result);
        $current_email = $row['email'];

        if ($updated_email == $current_email) {
            $statusMsg = "Email Not Changed";
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