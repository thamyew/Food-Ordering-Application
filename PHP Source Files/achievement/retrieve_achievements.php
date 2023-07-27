<?php
    include('../db/config.php');
    include('achievement_checking.php');

    $username = $_POST['username'];

    checkingAchievement($connect, $username);

    $achievementQuery = "SELECT * FROM achievement";
    $achievementResult = mysqli_query($connect, $achievementQuery);

    $achievedQuery = "SELECT * FROM achievement_record WHERE customer_username = '$username'";
    $achievedResult = mysqli_query($connect, $achievedQuery);
    $achievedCount = mysqli_num_rows($achievedResult);

    if ($achievedCount > 0) {
        $achievedArray = array();

        while($achievedRow = mysqli_fetch_assoc($achievedResult)) {
            $achievedId = $achievedRow['achievement_id'];
            array_push($achievedArray, $achievedId);
        }
    } else {
        $achievedArray = null; 
    }

    $returnArray = array();

    while($achievementRow = mysqli_fetch_assoc($achievementResult)) {
        $achievementId = $achievementRow['achievement_id'];
        $achievementName = $achievementRow['achievement_name'];
        $achievementDescription = $achievementRow['achievement_description'];
        $achieved = 0;

        if ($achievedArray != null) {
            if (in_array($achievementId, $achievedArray))
                $achieved = 1;
        }

        $tempArray = array(
            'achievement_id' => (int) $achievementId,
            'achievement_name' => $achievementName,
            'achievement_desc' => $achievementDescription,
            'achieved' => (int)$achieved,
        );

        $returnArray[] = $tempArray;
    }

    echo json_encode($returnArray);

    mysqli_close($connect);
?>