<?php
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\SMTP;
    use PHPMailer\PHPMailer\Exception;
    require '../mail/Exception.php';
    require '../mail/PHPMailer.php';
    require '../mail/SMTP.php';

    include('../db/config.php');

    $access = "YES";
    $statusCode = 200;
    $statusMsg;
    $email;
    $verification;

    if (isset($_POST['verification']) && (!empty($_POST['verification']))) {
        $verification = $_POST['verification'];

    // if (isset($_GET['verification']) && (!empty($_GET['verification']))) {
    //     $verification = $_GET['verification'];

        $query = "SELECT * FROM userinfo WHERE username = '$verification'";
        $result = mysqli_query($connect, $query);
        $count = mysqli_num_rows($result);

        if ($count != 1) {

            $statusMsg = "Invalid username";

            $email = $verification;
            $email = filter_var($email, FILTER_SANITIZE_EMAIL);
            $email = filter_var($email, FILTER_VALIDATE_EMAIL);

            if (!$email) {
                $statusCode = 404;
                $statusMsg = $statusMsg . " or invalid email format entered";
                $access = "NO";
            } else {
                $query = "SELECT * FROM userinfo WHERE email = '$email'";
                $result = mysqli_query($connect, $query);
                $count = mysqli_num_rows($result);

                if ($count == 0) {
                    $statusCode = 404;
                    $statusMsg = $statusMsg . " or invalid email entered";
                    $access = "NO";
                }
            }
        } else {
            $row = mysqli_fetch_assoc($result);
            $email = $row['email'];
        }
    }

    if ($access == "YES") {
        $query = "SELECT * FROM password_reset_temp WHERE email = '$email'";
        $result = mysqli_query($connect, $query);
        $count = mysqli_num_rows($result);

        if ($count == 1) {
            $query = "DELETE FROM password_reset_temp WHERE email = '$email'";
            $result = mysqli_query($connect, $query);
        }

        $expFormat = mktime(
            date("H"), date("i"), date("s"), date("m"), date("d")+1, date("Y")
        );
    
        $expDate = date("Y-m-d H:i:s", $expFormat);
        $passKey = mt_rand(100000, 999999);

        $query = "INSERT INTO password_reset_temp (email, passKey, expDate) VALUES ('".$email."', '".$passKey."', '".$expDate."')";
        $result = mysqli_query($connect, $query);

        $output='<p>Dear user,</p>';
        $output.='<p>Please enter the following code to reset your password.</p>';
        $output.='<p>-------------------------------------------------------------</p>';
        $output.='<h1>Your Code: '.$passKey.'</h1>';
        $output.='<p>-------------------------------------------------------------</p>';
        $output.='<p>The code will expire after 1 day for security reason.</p>';
        $output.='<p>If you did not request this forgotten password email, no action 
        is needed, your password will not be reset. However, you may want to log into 
        your account and change your security password as someone may have guessed it.</p>';   	
        $output.='<p>Thanks</p>';
        $body = $output; 
        $subject = "Password Recovery - Food Ordering Application";

        $email_to = $email;
        // $fromserver = "noreply@yourwebsite.com"; 
        $mail = new PHPMailer(true);
        $mail->IsSMTP();
        $mail->Host = "smtp.gmail.com"; // Enter your host here
        $mail->SMTPAuth = true;
        $mail->Username = "grouprenegades145@gmail.com"; // Enter your email here
        $mail->Password = "ygyzgrifgrjkxxfn"; //Enter your app password here
        $mail->Port = 587;
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->IsHTML(true);
        $mail->setFrom("grouprenegades145@gmail.com", "Group Renegades");
        $mail->AddAddress($email_to);
        $mail->Subject = $subject;
        $mail->Body = $body;

        $returnArray = array();
        
        if(!$mail->Send()) {
            $statusCode = 404;
            $statusMsg = "Password Recovery Failed";
            $email = "";

            $returnArray[] = array(
                "statusCode" => $statusCode,
                "statusMsg" => $statusMsg,
                "email" => $email
            );
        } else {
            $statusCode = 200;
            $statusMsg = "Password Recovery Email Has Been Sent";
            $returnArray[] = array(
                "statusCode" => $statusCode,
                "statusMsg" => $statusMsg,
                "email" => $email
            );
        }
    }
    else {
        $returnArray[] = array(
            "statusCode" => $statusCode,
            "statusMsg" => $statusMsg,
            "email" => ""
        );
    }

    echo json_encode($returnArray);
?>