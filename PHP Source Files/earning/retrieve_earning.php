<?php
    include('../db/config.php');

    $level = $_POST['level'];

    if ($level == 0) {
        $dateQuery = "SELECT * FROM earning";
        
        $dateResult = mysqli_query($connect, $dateQuery);
        $dateCount = mysqli_num_rows($dateResult);

        $returnArray = array();

        if ($dateCount > 0) {
            while($dateRow = mysqli_fetch_assoc($dateResult)) {
                $tempArray = array(
                    'earning_date' => $dateRow['earning_date'],
                    'total' => $dateRow['total'],
                );

                $returnArray[] = $tempArray;
            }

            echo json_encode($returnArray);
        } else {
            echo json_encode(404);
        }
    } else {
        echo json_encode(404);
    }

    mysqli_close($connect);
?>