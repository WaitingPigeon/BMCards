<?php

    // function to create a database object and connect to it
    function dbConnect() {
        
        $config = json_decode(file_get_contents("./config.json"), true);
        $db = new PDO("mysql:host=".$config["db_host"].";dbname=".$config["db_name"], $config["db_username"], $config["db_password"]);
        $db -> setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        return($db);
    }

    // check if credentials conform to the given shape
    function checkCredentials($username, $password) {

        if(!preg_match("/^[a-zA-Z0-9_-]{3,16}$/", $username)) {

            requestError(2);
            return(false);
        }

        if(!preg_match("/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*_-]).{8,}$/", $password)) {

            requestError(1);
            return(false);
        }

        return(true);
    }

    function denyRequest($http_code, $message) {

        http_response_code($http_code);
        print json_encode([

            "return_status" => null,
            "cause" => $message
        ]);
    }

    function requestError($error_code) {

        switch($error_code) {

            case 1: $message = "Password doesn't conform"; break;
            case 2: $message = "Username doesn't conform"; break;
            case 3: $message = "Username already exists"; break;
            case 4: $message = "Wrong password"; break;
            case 5: $message = "Username doesn't exists"; break;
            case 6: $message = "User already logged-in"; break;
            case 7: $message = "User already offline"; break;
        }
        
        print json_encode([

            "return_status" => $error_code,
            "cause" => $message
        ]);
    }

    function requestOk($payload) {

        print json_encode([

            "return_status" => 0,
            "payload" => $payload
        ]);
    }

    /*

        custom return codes {

            0: ok
            1: password doesn't conform
            2: username doesn't conform
            3: username already exists
            4: wrong password
            5: username not found
            6: user is already logged-in
            7: user already offline
        }

        if return code != 0, then the payload will be a string with the cause
    */
?>
