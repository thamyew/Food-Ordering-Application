<?php
    include('../db/config.php');

    $statusCode = 200;

    $curDate = date("Y-m-d H:i:s");

    $query = "SELECT food_id, food_name, food_price, food_recommend, food_img_id FROM food WHERE food_archived = 0";
    $result = mysqli_query($connect, $query);

    $returnArray = array();
    
    if ($result) {
        while($row = mysqli_fetch_assoc($result)) {

            $foodId = $row['food_id'];
            $tempFoodImgId = $row['food_img_id'];
            $query = "SELECT CONCAT(path, file_name) AS img_location FROM images WHERE id = $tempFoodImgId";
            $imgResult = mysqli_query($connect, $query);
            $imgRow = mysqli_fetch_assoc($imgResult);
            
            require_once('../feedback/retrieve_rating.php');
            retrieveRating($ratingAverage, $ratingCount, $foodId, $connect);

            $tempArray = array(
                'food_id' => (int)$row['food_id'],
                'food_name' => $row['food_name'],
                'food_price' => $row['food_price'],
                'food_recommend' => (int)$row['food_recommend'],
                'img_location' => $imgRow['img_location'],
                'food_rating' => (float)$ratingAverage,
                'num_of_rating' => (int)$ratingCount,
            );

            $returnArray[] = $tempArray;
        }

        echo json_encode($returnArray);
    } else {
        echo json_encode($statusCode);
    }

    // Close connection
    mysqli_close($connect);    
?>