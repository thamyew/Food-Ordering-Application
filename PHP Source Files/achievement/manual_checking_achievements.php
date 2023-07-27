<?php
    include('../db/config.php');
    include('achievement_checking.php');

    $username = $_POST['username'];

    checkingAchievement($connect, $username);

    mysqli_close($connect);
?>