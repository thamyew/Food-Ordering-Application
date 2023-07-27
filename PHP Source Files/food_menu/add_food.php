<?php 
    include('../db/config.php');

    function compressImage($source, $destination, $quality) { 
        // Get image info 
        $imgInfo = getimagesize($source); 
        $mime = $imgInfo['mime']; 
        
        // Create a new image from file 
        switch($mime){ 
            case 'image/jpeg': 
                $image = imagecreatefromjpeg($source); 
                break; 
            case 'image/png': 
                $image = imagecreatefrompng($source); 
                break; 
            case 'image/gif': 
                $image = imagecreatefromgif($source); 
                break; 
            default: 
                $image = imagecreatefromjpeg($source); 
        }
        
        // Save image 
        imagejpeg($image, $destination, $quality); 
        
        // Return compressed image 
        return $destination; 
    }

    function convert_filesize($bytes, $decimals = 2) { 
        $size = array('B','KB','MB','GB','TB','PB','EB','ZB','YB'); 
        $factor = floor((strlen($bytes) - 1) / 3); 
        return sprintf("%.{$decimals}f", $bytes / pow(1024, $factor)) . @$size[$factor]; 
    }

    // Variable to store status message to be returned
    $statusCode = 200;
    $statusMsg = '';

    // Variables to store the food information
    $foodName = $_POST["food_name"];
    $foodDesc = $_POST["food_description"];
    $foodPrice = $_POST["food_price"];
    $foodRecommended = $_POST["food_recommend"];
    $foodImg = $_FILES["file"]["name"];

    $query = "INSERT INTO food (food_name, food_description, food_price, food_recommend) VALUES ('$foodName', '$foodDesc', $foodPrice, $foodRecommended)";
    $result = mysqli_query($connect, $query);

    $query = "SELECT MAX(food_id) as max_id FROM food";
    $result = mysqli_query($connect, $query);

    $row = mysqli_fetch_assoc($result);

    $foodId = $row['max_id'];

    // Check if the file is set
    if (isset($_FILES["file"]["name"])) {
        // File upload path
        $targetDir = "images/food_pic/";
        // File name
        $fileName = basename($_FILES["file"]["name"]);
        // File extension
        $fileType = pathinfo($fileName, PATHINFO_EXTENSION);

        // Check if file is not empty
        if(!empty($_FILES["file"]["name"])){
            // Allow certain file formats
            $allowTypes = array('jpg','png','jpeg','gif+','pdf');
            // Check if the file type is allowed
            if(in_array($fileType, $allowTypes)){
                $fileType = "jpg";
                
                // Insert image file name into database
                $query = "INSERT INTO images(file_name, uploaded_on, path) VALUES ('', NOW(), '$targetDir')";
                $result = mysqli_query($connect, $query);

                $query = "SELECT MAX(id) as maxID FROM images";
                $result = mysqli_query($connect, $query);
                $row = mysqli_fetch_assoc($result);
                $img_id = (int)$row['maxID'];

                $newFileName = "food_pic_" . $img_id . "." . $fileType;
                $query = "UPDATE images SET file_name= '$newFileName' WHERE id = $img_id";
                $result = mysqli_query($connect, $query);
            }

            // Finalize the file upload path
            $targetFilePath = "../" . $targetDir . $newFileName;

            $imageTemp = $_FILES["file"]["tmp_name"];
            $imageSize = convert_filesize($_FILES["file"]["size"]);

            $compressedImage = compressImage($imageTemp, $targetFilePath, 20);

            // Upload file to server
            if($compressedImage) {

                // SQL query to retrieve the id assigned for the picture uploaded
                $query = "SELECT * FROM images WHERE file_name = '$newFileName'";
                $result = mysqli_query($connect, $query);
                $row =mysqli_fetch_assoc($result);

                // Variable to store the id assigned for the picture
                $picId = $row['id'];

                // SQL query to update the id assigned for the picture uploaded in userinfo
                $query = "UPDATE food SET food_img_id = $picId WHERE food_id = $foodId";
                $result = mysqli_query($connect, $query);

                // Check if query success
                if($result){
                    $statusMsg = "The file ".$newFileName. " has been uploaded successfully.";
                }else{
                    $statusCode = 404;
                    $statusMsg = "File upload failed, please try again.";
                } 

            } else {
                $statusCode = 404;
                $statusMsg = "Sorry, there was an error uploading your file.";
            }
        } else {
            $statusCode = 404;
            $statusMsg = 'Sorry, only JPG, JPEG, PNG, GIF, & PDF files are allowed to upload.';
        }
    }
    
    $returnArray[] = array(
        'statusCode' => $statusCode,
        'statusMsg' => $statusMsg
    );

    echo json_encode($returnArray);

    // Close connection
    mysqli_close($connect);
?>