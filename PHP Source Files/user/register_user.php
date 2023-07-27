<?php 
    // Include database config
    include('../db/config.php');

    // Variable to store status message to be returned
    $statusCode = 200;
    $statusMsg = '';

    $access = "YES"; // Check the access granted or not
    $level = 1; // Record the level of the user credential created

    // Check if the current register user session is for administrator or normal user
    if (isset($_POST['level'])) {
        // SQL query
        $query = "SELECT * FROM adminkey";
        $result = mysqli_query($connect, $query);
        $rows = mysqli_fetch_assoc($result);

        // Variable to store the entered admin password used to create new administrator account
        $admin_pass = $_POST['admin_pass'];

        // Check if the entered admin password is equal to the one recorded in the database
        if ($admin_pass == $rows['admin_password'])
            $level = 0; // Change the level of user to administrator if the admin password is correct
        else
            $access = "NO"; // Denied the registration of user as an administrator of the application
    }
    
    // If access is granted
    if ($access == "YES") {

        // Variables to store the user credential and information created
        $username = $_POST['username'];
        $password = $_POST['password'];
        $email = $_POST['email'];
        $name = $_POST['name'];
        $phone_num = $_POST['phone_num'];
        $gender = $_POST['gender'];
        $address = $_POST['address'];

        // Variable to determine whether permission is granted to create a new account
        $permission = "YES";

        // SQL query to check username
        $query = "SELECT * FROM userinfo WHERE username = '$username'";
        $result = mysqli_query($connect, $query);
        $count = mysqli_num_rows($result);

        // Check if username is used before
        if ($count == 1) {
            // Change permission
            $permission = "NO";
            // Change status message
            $statusCode = 404;
            $statusMsg = 'Username entered has been used';
        }
        else {
            // SQL query to check email
            $query = "SELECT * FROM userinfo WHERE email = '$email'";
            $result = mysqli_query($connect, $query);
            $count = mysqli_num_rows($result);
                
            // Check if email is used before
            if ($count == 1) {
                // Change permission
                $permission = "NO";
                // Change status message
                $statusCode = 404;
                $statusMsg = 'Email entered has been used';
            }
            else {
                // SQL query to check phone number is used before
                $query = "SELECT * FROM userinfo WHERE phone_num = '$phone_num'";
                $result = mysqli_query($connect, $query);
                $count = mysqli_num_rows($result);
                    
                // Check if phone number is used before
                if ($count == 1) {
                    // Change permission
                    $permission = "NO";
                    // Change status message
                    $statusCode = 404;
                    $statusMsg = 'Phone number entered has been used';
                }
            }
        }

        // Check if permission is granted
        if ($permission == "YES") {
            // Initialize gender to female
            $gender_code = 1;

            // Check if value passed is "male"
            if ($gender == "male")
                $gender_code = 0;   // Change gender to male

            // SQL query to insert new user
            $query = "INSERT INTO userinfo VALUES ('$username', '$password', '$email', '$level', '$name', $gender_code, '$address', '$phone_num', 1)";
            $result = mysqli_query($connect, $query);

            if ($level == 1) {
                include ('../cart/add_order_cart.php');
                addCart($connect, $username);
            }

            // Check if query is success
            if ($result)
                $statusMsg = "Register User Success";
            else
                $statusMsg = "Register User Unsuccessful";
        }
    }
    else {
        $statusMsg = 'Registration failed because the administrator password is wrong.';
        $statusCode = 404;
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    // Close connection
    mysqli_close($connect);
?>