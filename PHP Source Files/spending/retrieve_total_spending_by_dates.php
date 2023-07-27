<?php
    include("../db/config.php");
    $level = $_POST['level'];
    $startDate = $_POST['start_date'];
    $endDate = $_POST['end_date'];

    if ($level == 0) {
        $dateQuery = "SELECT SUM(total) as total_spending, customer_username FROM spending WHERE spending_date >= '$startDate' AND spending_date <= '$endDate' GROUP BY customer_username ORDER BY SUM(total) DESC";
    }

    $dateResult = mysqli_query($connect, $dateQuery);
    $dateCount = mysqli_num_rows($dateResult);

    $returnArray = array();

    if ($dateCount > 0) {
        while($dateRow = mysqli_fetch_assoc($dateResult)) {
            $tempArray = array(
                'total_spending' => $dateRow['total_spending'],
                'customer_username' => $dateRow['customer_username'],
            );

            $returnArray[] = $tempArray;
        }

        echo json_encode($returnArray);
    } else {
        echo json_encode(404);
    }

    mysqli_close($connect);
?>