<?php
    include('../db/config.php');

    $statusCode = 200;

    $foodId = $_POST['food_id'];
    $expFormat = mktime(
        date("H"), date("i"), date("s"), date("m"), date("d")+7, date("Y")
    );

    $expDate = date("Y-m-d H:i:s", $expFormat);

    $query = "UPDATE food SET food_archived = 1, archive_expiry_date = '$expDate' WHERE food_id = $foodId";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
    }

    echo json_encode($statusCode);

    // Close connection
    mysqli_close($connect);    
?>