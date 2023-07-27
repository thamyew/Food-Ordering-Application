<?php
    function retrieveRating(&$ratingAverage, &$ratingCount, $foodId, $connect) {
        $ratingQuery = "SELECT AVG(rating) AS average, COUNT(rating) AS count FROM food_rating WHERE food_id = $foodId";
        $ratingResult = mysqli_query($connect, $ratingQuery);
        $ratingRow = mysqli_fetch_assoc($ratingResult);
        $ratingAverage = $ratingRow['average'];

        if ($ratingAverage == null) {
            $ratingAverage = 0;
        }

        $ratingCount = $ratingRow['count'];
    }
?>