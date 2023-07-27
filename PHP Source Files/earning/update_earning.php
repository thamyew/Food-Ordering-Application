<?php
    function updateEarning($connection, $total) {
        $today = date('Y-m-d');
        $currQuery = "SELECT * FROM earning WHERE earning_date = '$today'";
        $currResult = mysqli_query($connection, $currQuery);
        $newValue = $total;
        
        if (mysqli_num_rows($currResult) > 0) {
            $currRow = mysqli_fetch_assoc($currResult);
            $currValue = $currRow['total'];
            $newValue = $currValue + $total;
        }

        $updateQuery = "INSERT INTO earning VALUES('$today', $newValue) ON DUPLICATE KEY UPDATE total = $newValue";
        $updateResult = mysqli_query($connection, $updateQuery);

        if ($updateResult) {
            return 200;
        }

        return 404;
    }
?>