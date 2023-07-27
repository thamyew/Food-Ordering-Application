<?php
    include('../db/config.php');

    $statusCode = 200;
    $statesMsg;

    if (isset($_POST["email"]) && isset($_POST["reset_password"])) {
        $email = $_POST["email"];
        $resetPassword = $_POST["reset_password"];
    
    // if(isset($_GET["email"]) && isset($_GET["reset_password"])) {
    //     $email = $_GET["email"];
    //     $resetPassword = $_GET["reset_password"];

        $query = "UPDATE userinfo SET password = '$resetPassword' WHERE email = '$email'";
        $result = mysqli_query($connect, $query);

        if (!$result) {
            $statusCode = 404;
            $statusMsg = "There exist some problems";
        }

        $query = "DELETE FROM password_reset_temp WHERE email = '".$email."'";
        $result = mysqli_query($connect, $query);

        if (!$result) {
            $statusCode = 404;
            $statusMsg = "There exist some problems";
        }

        $statusMsg = "Password changed success";
        $returnArray[] = array(
            "statusCode" => $statusCode,
            "statusMsg" => $statusMsg
        );

        echo json_encode($returnArray);
    }		
?>