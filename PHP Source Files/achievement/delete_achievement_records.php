<?php
function deleteArhievementRecords($connection, $username) {
    $deleteQuery = "DELETE FROM achievement_record WHERE customer_username = '$username'";
    $deleteResult = mysqli_query($connection, $deleteQuery);

    if ($deleteResult) {
        return 200;
    }
    
    return 404;
}
?>