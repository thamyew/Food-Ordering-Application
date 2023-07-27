<?php
    function updateSpending($connection, $username, $totalPrice) {
        $today = date("Y-m-d");
        $prevQuery = "SELECT * FROM spending WHERE customer_username = '$username' AND spending_date = '$today'";
        $prevResult = mysqli_query($connection, $prevQuery);
        $newValue = $totalPrice;
        
        if (mysqli_num_rows($prevResult) > 0) {
            $prevRow = mysqli_fetch_assoc($prevResult);
            $currValue = $prevRow['total'];
            $newValue = $currValue + $totalPrice;
        }

        $query = "INSERT INTO spending (customer_username, total) VALUES ('$username', $newValue) ON DUPLICATE KEY UPDATE total = $newValue";
        $result = mysqli_query($connection, $query);

        if (!$result) {
            return 404;
        }

        return 200;
    }
?>