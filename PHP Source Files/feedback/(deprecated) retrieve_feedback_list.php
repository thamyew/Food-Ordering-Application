<?php
    include('../db/config.php');

    $dateFormat = mktime(
        date("H"),
        date("i"),
        date("s"),
        date("m"), 
        date("d"),
        date("Y") - 1
    );

    $checkDate = date("Y-m-d", $dateFormat);

    $query = "DELETE FROM feedback WHERE date < '$checkDate'";
    $result = mysqli_query($connect, $query);

    $query = "SELECT * FROM feedback ORDER BY date DESC";
    $result = mysqli_query($connect, $query);
    $count = mysqli_num_rows($result);

    if ($count > 0) {
        while($row = mysqli_fetch_assoc($result)) {
            $id = $row['id'];
            $content = $row['content'];
            $date = $row['date'];

            $returnArray[] = array(
                'feedback_id' => (int)$id,
                'content' => $content,
                'date' => $date,
            );
        }

        echo json_encode($returnArray);
    } else {
        echo json_encode(404);
    }

    mysqli_close($connect);
?>