<?php
    include('../db/config.php');

    $statusCode = 200;

    $curDate = date("Y-m-d H:i:s");

    $query = "SELECT food_id, food_name, food_price, food_recommend, food_archived, archive_expiry_date, food_img_id FROM food WHERE food_archived = 1";
    $result = mysqli_query($connect, $query);

    $returnArray = array();
    
    if ($result) {
        while($row = mysqli_fetch_assoc($result)) {

            $added = 1;

            if ($row['food_archived'] == 1) {
                
                $expDate = $row['archive_expiry_date'];

                if ($expDate < $curDate) {
                    
                    $added = 0;
                    $deleteFoodId = $row['food_id'];
                    $deletedFoodImgId = $row['food_img_id'];

                    include_once('../feedback/delete_rating.php');
                    include_once('../cart/delete_order_cart_line_food.php');

                    deleteRatingFood($deleteFoodId, $connect);
                    deleteOrderLineWithFood($deleteFoodId, $connect);

                    $deleteFoodQuery = "DELETE FROM food WHERE food_id = $deleteFoodId";
                    $deleteFoodResult = mysqli_query($connect, $deleteFoodQuery);

                    if ($deletedFoodImgId != 2) {
                        $deleteImgQuery = "DELETE FROM images WHERE id = $deletedFoodImgId";
                        $deleteImgResult = mysqli_query($connect, $deleteImgQuery);                        
                    }
                }
            }

            if ($added == 1) {
                $tempFoodImgId = $row['food_img_id'];
                $query = "SELECT CONCAT(path, file_name) AS img_location FROM images WHERE id = $tempFoodImgId";
                $imgResult = mysqli_query($connect, $query);
                $imgRow = mysqli_fetch_assoc($imgResult);

                $tempArray = array(
                    'foodId' => (int)$row['food_id'],
                    'foodName' => $row['food_name'],
                    'foodPrice' => $row['food_price'],
                    'foodRecommend' => (int)$row['food_recommend'],
                    'foodArchiveExpiryDate' => $row['archive_expiry_date'],
                    'foodImgLocation' => $imgRow['img_location']
                );

                $returnArray[] = $tempArray;
            }
        }

        echo json_encode($returnArray);
    } else {
        echo json_encode($statusCode);
    }

    // Close connection
    mysqli_close($connect);    
?>