<?php
    // Include the database config
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

    // Variable to store the current login user's username and updated address [TO BE SENT FROM FLUTTER APP]
    $username = $_POST['username'];

    // SQL query to get profile picture id
    $query = "SELECT * FROM userinfo WHERE username = '$username'";
    $result = mysqli_query($connect, $query);
    $row = mysqli_fetch_assoc($result);

    // Variable to store profile picture ID
    $img_id = $row['profile_pic_id'];
    
    // SQL query to obtain image information
    $query = "SELECT * FROM images WHERE id = $img_id";
    $result = mysqli_query($connect, $query);
    $row = mysqli_fetch_assoc($result);

    // Variable to store the current profile picture name and id
    $img_name = $row['file_name'];

    // Check if the file is set
    if (isset($_FILES["file"]["name"])) {
        // Variable to store status message
        $statusCode = 200;
        $statusMsg = '';

        // File upload path
        $targetDir = "images/profile_pic/";
        // File name
        $fileName = basename($_FILES["file"]["name"]);
        
        // File extension
        $fileType = pathinfo($fileName, PATHINFO_EXTENSION);
        // Variable to store the name of the file and be used to alter file name if needed
        $newFileName = $fileName;

        // Check if file is not empty
        if(!empty($_FILES["file"]["name"])){
            // Allow certain file formats
            $allowTypes = array('jpg','png','jpeg','gif+','pdf');
            // Check if the file type is allowed
            if(in_array($fileType, $allowTypes)){
                $fileType = "jpg";
                if ($img_id != 1) {
                    $newFileName = "profile_pic_" . $img_id . "." . $fileType;
                    // Alter image file name into database
                    $query = "UPDATE images SET file_name= '$newFileName', uploaded_on = NOW() WHERE id = $img_id";
                    $result = mysqli_query($connect, $query);
                } else {
                    // Insert image file name into database
                    $query = "INSERT INTO images(file_name, uploaded_on, path) VALUES ('', NOW(), 'images/profile_pic/')";
                    $result = mysqli_query($connect, $query);

                    $query = "SELECT MAX(id) as maxID FROM images";
                    $result = mysqli_query($connect, $query);
                    $row = mysqli_fetch_assoc($result);
                    $img_id = (int)$row['maxID'];

                    $newFileName = "profile_pic_" . $img_id . "." . $fileType;
                    $query = "UPDATE images SET file_name= '$newFileName' WHERE id = $img_id";
                    $result = mysqli_query($connect, $query);
                }

                // Finalize the file upload path
                $targetFilePath = "../" . $targetDir . $newFileName;

                $imageTemp = $_FILES["file"]["tmp_name"];
                $imageSize = convert_filesize($_FILES["file"]["size"]);

                $compressedImage = compressImage($imageTemp, $targetFilePath, 15);

                // Upload file to server
                if($compressedImage) {

                    // SQL query to retrieve the id assigned for the picture uploaded
                    $query = "SELECT * FROM images WHERE file_name = '$newFileName'";
                    $result = mysqli_query($connect, $query);
                    $row =mysqli_fetch_assoc($result);

                    // Variable to store the id assigned for the picture
                    $pic_id = $row['id'];

                    // SQL query to update the id assigned for the picture uploaded in userinfo
                    $query = "UPDATE userinfo SET profile_pic_id = $pic_id WHERE username = '$username'";
                    $result = mysqli_query($connect, $query);

                    // Check if query success
                    if($result){
                        $statusMsg = "The file ".$newFileName. " has been uploaded successfully.";
                    }else{
                        $statusCode = 404;
                        $statusMsg = "File upload failed, please try again.";
                    } 
                }else{
                    $statusCode = 404;
                    $statusMsg = "Sorry, there was an error uploading your file.";
                }
            }else{
                $statusCode = 404;
                $statusMsg = 'Sorry, only JPG, JPEG, PNG, GIF, & PDF files are allowed to upload.';
            }
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