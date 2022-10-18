<?php

    include("./common.php");
    
    if(!isset($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "POST") {

        header("HTTP/1.1 400 invalid request");
        deny_request("server was expecting a POST request.");
    }

    else {

        session_start();
        $var = json_decode(file_get_contents('php://input'), true);

        if($var != null) {

            if(isset($_SESSION["uname"]) == $var["username"]) {

                // user is already logged-in
                request_error(-6, "you are already logged-in");
            }
    
            else {
    
                try {

                    $database = dbConnect("root", "");
                    $query = $database -> prepare("SELECT password, username FROM users WHERE username = ?");
                    $query -> execute([$var["username"]]);

                    if($query -> rowCount() > 0) {
    
                        $row = $query -> fetch(PDO::FETCH_ASSOC);
                        
                        if(password_verify($var["password"], $row["password"]) == true) {
    
                            // login success, the payload holds the username
                            $_SESSION["uname"] = $row["username"];
                            request_ok($query -> rowCount(), $_SESSION["uname"]);
                        }
    
                        else {
    
                            // login failure
                            request_error(-4, "wrong password");
                        }
                    }
    
                    else {
    
                        // login failure
                        request_error(-5, "username not found");
                    }
                }
    
                catch(PDOException $exc) {
    
                    deny_request($exc -> getMessage());
                }
            }
        }

        else {

            header("HTTP/1.1 400 invalid request");
            deny_request("invalid or null arguments.");
        }
    }
?>