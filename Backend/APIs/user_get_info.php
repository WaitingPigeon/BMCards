<?php

    include("./common.php");

    // check if the request method is the correct one
    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "GET") {

        denyRequest(400, "Invalid request method, expected GET while got: " . $_SERVER["REQUEST_METHOD"]);
    }

    else {

        if(!empty($_GET["user_id"]) && !empty($_GET["what_to_get"])) {

            $database = dbConnect();

            switch($_GET["what_to_get"]) {

                case 1: $str = "SELECT username, privilege, creation_date, avatar, status, last_logout_date FROM users WHERE user_id = ?"; break;
                case 2: $str = "SELECT username FROM users WHERE user_id = ?"; break;
                case 3: $str = "SELECT privilege FROM users WHERE user_id = ?"; break;
                case 4: $str = "SELECT creation_date FROM users WHERE user_id = ?"; break;
                case 5: $str = "SELECT avatar FROM users WHERE user_id = ?"; break;
                case 6: $str = "SELECT status FROM users WHERE user_id = ?"; break;
                case 7: $str = "SELECT last_logout_date FROM users WHERE user_id = ?"; break;

                default: $str = "SELECT user_id FROM users WHERE user_id = ?"; break;
            }

            $query = $database -> prepare($str);
            $query -> execute([$_GET["user_id"]]);

            if($query -> rowCount() > 0) {
    
                $row = $query -> fetch(PDO::FETCH_ASSOC);
                requestOk($row);
            }

            else {

                requestError(5);
            }
        }

        else {

            denyRequest(400, "Invalid, null or empty arguments.");
        }
    }
?>