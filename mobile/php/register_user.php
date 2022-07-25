<?php 
    if(!isset($_POST)){
        echo "failed";
    }

    include_once("dbconnect.php");
    $email          = $_POST['email'];
    $name           = $_POST['name'];
    $phNumber       = $_POST['phNumber'];
    $password       = sha1($_POST['password']);
    $address        = $_POST['address'];
    $sqlregister    = "INSERT INTO `tbl_user`(`user_email`, `user_name`, `user_phnumber`, `user_pass`, `user_address`) 
                       VALUES ('$email','$name','$phNumber','$password','$address')";
    
    if ($conn->query($sqlregister)) {
        echo "success";
    }else{
        echo "failure";
    }

    function sendJsonResponse($sentArray){
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
?>