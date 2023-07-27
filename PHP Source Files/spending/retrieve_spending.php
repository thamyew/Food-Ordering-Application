<?php
    include("../db/config.php");

    $username = $_POST['username'];
    $level = $_POST['level'];

    if ($level == 0) {
        $dateQuery = "SELECT * FROM spending";
    } else {
        $dateQuery = "SELECT * FROM spending WHERE customer_username = '$username'";
    }

    $dateResult = mysqli_query($connect, $dateQuery);
    $dateCount = mysqli_num_rows($dateResult);

    $returnArray = array();

    if ($dateCount > 0) {
        while($dateRow = mysqli_fetch_assoc($dateResult)) {
            $tempArray = array(
                'spending_date' => $dateRow['spending_date'],
                'customer_username' => $dateRow['customer_username'],
                'total' => $dateRow['total'],
            );

            $returnArray[] = $tempArray;
        }

        echo json_encode($returnArray);
    } else {
        echo json_encode(404);
    }

    mysqli_close($connect);
?>