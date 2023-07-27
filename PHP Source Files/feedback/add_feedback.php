<?php
    include('../db/config.php');

    $statusCode = 200;
    $statusMsg = "Successfully submitting feedback";

    $orderId = $_POST['order_id'];
    $content = mysqli_real_escape_string($connect, $_POST['content']);

    $query = "INSERT INTO feedback(order_id, content) VALUES ($orderId, '$content')";
    $result = mysqli_query($connect, $query);

    if (!$result) {
        $statusCode = 404;
        $statusMsg = "Error when submitting feedback";
    }

    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg,
    );

    echo json_encode($returnArray);

    mysqli_close($connect);
?>