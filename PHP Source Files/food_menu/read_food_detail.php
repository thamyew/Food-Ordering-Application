<?php
    include('../db/config.php');

    $statusCode = 200;

    $foodId = $_POST['food_id'];

    $query = "SELECT * FROM food WHERE food_id = $foodId";
    $result = mysqli_query($connect, $query);
    
    if ($result) {
        $row = mysqli_fetch_assoc($result);

        $foodName = $row["food_name"];
        $foodDescription = $row["food_description"];
        $foodPrice = $row["food_price"];
        $foodRecommend = $row["food_recommend"];
        $foodArchive = $row["food_archived"];
        $foodArchivedExpDate = $row["archive_expiry_date"];
        $foodImgId = $row["food_img_id"];

        $query = "SELECT * FROM images WHERE id = $foodImgId";
        $result = mysqli_query($connect, $query);
        $row = mysqli_fetch_assoc($result);

        $foodImgName = $row['file_name'];
        $foodImgPath = $row['path'];
        $foodImgLocation = $foodImgPath . $foodImgName;

        if ($foodArchivedExpDate == null) {
            $foodArchivedExpDate = "";
        }

        require_once('../feedback/retrieve_rating.php');
        retrieveRating($ratingAverage, $ratingCount, $foodId, $connect);

        $returnArray[] = array(
            'food_id' => (int)$foodId,
            'food_name' => $foodName,
            'food_desc' => $foodDescription,
            'food_price' => $foodPrice,
            'food_recommend' => (int)$foodRecommend,
            'food_archived' => (int)$foodArchive,
            'food_archive_expiry_date' => $foodArchivedExpDate,
            'food_img_id' => (int)$foodImgId,
            'img_location' => $foodImgLocation,
            'food_rating' => (float)$ratingAverage,
            'num_of_rating' => (int)$ratingCount,
        );
    
        echo json_encode($returnArray);
    } else {
        $statusCode = 404;
        echo json_encode($statusCode);
    }

    // Close connection
    mysqli_close($connect);    
?>