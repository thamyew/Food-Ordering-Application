<?php
    function deleteSpendingRecord($connection, $username) {
        $deleteSpendingQuery = "DELETE FROM spending WHERE customer_username = '$username'";
        $deleteSpendingResult = mysqli_query($connection, $deleteSpendingQuery);

        if ($deleteSpendingResult) {
            return 200;
        }
        
        return 404;
    }
?>