<?php
    function deleteFCM($connection, $username) {
        $query = "DELETE FROM fcm_token WHERE username = '$username'";
        $result = mysqli_query($connection, $query);

        if ($result) {
            return 200;
        }
        return 404;
    }
?>