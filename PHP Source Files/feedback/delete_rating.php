<?php
    function deleteRatingUsername($username, $connect) {
        $deleteRatingQuery = "DELETE FROM food_rating WHERE customer_username = '$username'";
        $deleteRatingResult = mysqli_query($connect, $deleteRatingQuery);
    }

    function deleteRatingFood($foodId, $connect) {
        $deleteRatingQuery = "DELETE FROM food_rating WHERE food_id = '$foodId'";
        $deleteRatingResult = mysqli_query($connect, $deleteRatingQuery);
    }
?>