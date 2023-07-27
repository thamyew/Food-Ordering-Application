<?php
    function conditionChecking($checkingKey, $checkingValue, $operator) {
        switch($operator) {
            case '>=':
                if ($checkingKey >= $checkingValue) {
                    return true;
                } else {
                    return false;
                }
            case '>':
                if ($checkingKey > $checkingValue) {
                    return true;
                } else {
                    return false;
                }
        }
    }
 
    function checkingAchievement($connection, $username) {
        $achievedQuery = "SELECT achievement_id FROM achievement_record WHERE customer_username = '$username'";
        $achievedResult = mysqli_query($connection, $achievedQuery);
        $achievedCount = mysqli_num_rows($achievedResult);

        if ($achievedCount > 0) {
            $achievedArray = array();

            while($achievedRow = mysqli_fetch_assoc($achievedResult)) {
                $achievedId = $achievedRow['achievement_id'];
                array_push($achievedArray, $achievedId);
            }

            $checkingArray = implode(",", $achievedArray);
            $achievementQuery = "SELECT * FROM achievement WHERE achievement_id NOT IN ($checkingArray)";
            $achievementResult = mysqli_query($connection, $achievementQuery);
        } else {
            $achievementQuery = "SELECT * FROM achievement WHERE achievement_id";
            $achievementResult = mysqli_query($connection, $achievementQuery);
        }   

        while ($achievementRow = mysqli_fetch_assoc($achievementResult)) {
            $achievementId = $achievementRow['achievement_id'];
            $conditionTable = $achievementRow['condition_table'];
            $conditionKey = $achievementRow['condition_key'];
            $conditionOperator = $achievementRow['condition_operator'];
            $conditionValue = $achievementRow['condition_value'];
            $conditionAlternativeKey = $achievementRow['checking_key'];
            $conditionAlternativeOperator = $achievementRow['checking_operator'];
            $conditionAlternativeValue = $achievementRow['checking_value'];

            if (str_contains($conditionAlternativeKey, 'date')) {
                $conditionAlternativeValue = date('Y-m-d');
            }

            if ($conditionAlternativeKey == "") {
                if (str_contains($conditionAlternativeKey, 'date')) {
                    $conditionAlternativeStatement = $conditionAlternativeKey . $conditionAlternativeOperator . "'" . $conditionAlternativeValue . "'";
                } else {
                    $conditionAlternativeStatement = $conditionAlternativeKey . $conditionAlternativeOperator . $conditionAlternativeValue;
                }
                
                $achievementCheckQuery = "SELECT $conditionKey FROM $conditionTable WHERE customer_username = '$username'";
                $achievementCheckResult = mysqli_query($connection, $achievementCheckQuery);
                $achievementCheckCount = mysqli_num_rows($achievementCheckResult);

                if ($achievementCheckCount > 0) {
                    $achievementUnlocked = false;
                    while ($achievementCheckRow = mysqli_fetch_assoc($achievementCheckResult) and !$achievementUnlocked) {
                        if (conditionChecking($achievementCheckRow[$conditionKey], $conditionValue, $conditionOperator)) {
                            $achievementRecordQuery = "INSERT INTO achievement_record VALUES($achievementId, '$username')";
                            $achievementRecordResult = mysqli_query($connection, $achievementRecordQuery);
                            $achievementUnlocked = true;
                        }
                    }
                }
            } else {
                if (str_contains($conditionAlternativeKey, 'date')) {
                    $conditionAlternativeStatement = $conditionAlternativeKey . $conditionAlternativeOperator . "'" . $conditionAlternativeValue . "'";
                } else {
                    $conditionAlternativeStatement = $conditionAlternativeKey . $conditionAlternativeOperator . $conditionAlternativeValue;
                }

                $achievementCheckQuery = "SELECT $conditionKey FROM $conditionTable WHERE $conditionAlternativeStatement AND customer_username = '$username'";
                $achievementCheckResult = mysqli_query($connection, $achievementCheckQuery);
                $achievementCheckCount = mysqli_num_rows($achievementCheckResult);

                if ($achievementCheckCount > 0) {
                    $achievementUnlocked = false;
                    while ($achievementCheckRow = mysqli_fetch_assoc($achievementCheckResult) and !$achievementUnlocked) {
                        if (conditionChecking($achievementCheckRow[$conditionKey], $conditionValue, $conditionOperator)) {
                            $achievementRecordQuery = "INSERT INTO achievement_record VALUES($achievementId, '$username')";
                            $achievementRecordResult = mysqli_query($connection, $achievementRecordQuery);
                            $achievementUnlocked = true;
                        }
                    }
                }
            }
        }
    }
?>