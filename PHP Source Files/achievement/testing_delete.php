<?php
include("../db/config.php");
include("delete_achievement_records.php");

deleteArhievementRecords($connect, 'ahmad');

mysqli_close($connect);
?>