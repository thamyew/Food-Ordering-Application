<?php
    include('../db/config.php');

    $statusCode = 200;

    $foodId = $_POST['food_id'];

    $query = "SELECT * FROM food WHERE food_id = $foodId";
    $result = mysqli_query($connect, $query);
    $row = mysqli_fetch_assoc($result);

    $imgId = $row['food_img_id'];

    include_once('../feedback/delete_rating.php');
    include_once('../cart/delete_order_cart_line_food.php');

    deleteRatingFood($foodId, $connect);
    deleteOrderLineWithFood($foodId, $connect);

    $query = "DELETE FROM food WHERE food_id = $foodId";
    $result = mysqli_query($connect, $query);

    if ($imgId != 2) {
        $imgId = $row['food_img_id'];

        $imgQuery = "SELECT path, file_name FROM images WHERE id = $imgId";
        $imgResult = mysqli_query($connect, $imgQuery);
        $imgRow = mysqli_fetch_assoc($imgResult);

        $fileName = "../" . $imgRow['path'] . $imgRow['file_name'];
        unlink($fileName);

        $imgQuery = "DELETE FROM images WHERE id = $imgId";
        $imgResult = mysqli_query($connect, $imgQuery);
    }

    if (!$result) {
        $statusCode = 404;
    }

    echo json_encode($statusCode);

    // Close connection
    mysqli_close($connect);    
?>