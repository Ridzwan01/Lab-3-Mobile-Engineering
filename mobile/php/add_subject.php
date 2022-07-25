<?php 
    if(!isset($_POST)){
        echo "failed";
    }

    include_once("dbconnect.php");
    $name           = $_POST['name'];
    $desc           = $_POST['desc'];
    $price          = $_POST['price'];
    $tutor          = $_POST['tutor'];
    $session        = $_POST['session'];
    $rating         = $_POST['rating'];
    $sqladdsubject  = "INSERT INTO `tbl_subjects`(`subject_name`, `subject_description`, `subject_price`, `tutor_id`, `subject_sessions`, `subject_rating`) 
                       VALUES ('$name','$desc','$price','$tutor','$session','$rating')";
    
    if ($conn->query($sqladdsubject)) {
        echo "success";
    }else{
        echo "failure";
    }

    function sendJsonResponse($sentArray){
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>