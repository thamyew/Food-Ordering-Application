<?php
    include('../db/config.php');

    $statusCode = 200;
    $statusMsg;

    if (isset($_POST["passKey"]) && isset($_POST["email"])) {
        $passKey = $_POST["passKey"];
        $email = $_POST["email"];
    
    // if (isset($_GET["passKey"]) && isset($_GET["email"])) {
    //     $passKey = $_GET["passKey"];
    //     $email = $_GET["email"];

        $curDate = date("Y-m-d H:i:s");
        $query = "SELECT * FROM password_reset_temp WHERE passKey = '$passKey' AND email = '$email'";
        $result = mysqli_query($connect, $query);
        $count = mysqli_num_rows($result);

        if ($count == 0) {
            $statusCode = 404;
            $statusMsg = "The temporary key entered is wrong";
        } else {
            $row = mysqli_fetch_assoc($result);
            $expDate = $row['expDate'];

            if ($expDate >= $curDate){
                $statusMsg = "The temporary key entered correct";
            } else {
                $statusCode = 404;
                $statusMsg = "The temporary key entered is expired, please request recovery again";
                $query = "DELETE FROM password_reset_temp WHERE passKey = '.$passKey.' AND email= '.$email.'";
                $result = mysqli_query($connect, $query);
            }
        }
        
        $returnArray[] = array(
            "statusCode" => $statusCode,
            "statusMsg" => $statusMsg
        );

        echo json_encode($returnArray);
    }
?>