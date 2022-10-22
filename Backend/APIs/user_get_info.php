<?php

    // UPDATE  THIS SCRIPT

    include("./common.php");

    // check if the request method is the correct one
    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "GET") {

        denyRequest(400, "Invalid request method, expected GET while got: ".$_SERVER["REQUEST_METHOD"]);
    }

    else {

        $params = json_decode($_GET["user_id"]);

        if(!empty($params) && !empty($_GET["what_to_get"])) {

            $database = dbConnect();

            switch($_GET["what_to_get"]) {

                case 1: $str = "SELECT username, privilege, creation_date, avatar, status, last_logout_date FROM user WHERE user_id IN (".implode(', ', $params).")"; break;
                case 2: $str = "SELECT username FROM user WHERE user_id IN (".implode(', ', $params).")"; break;
                case 3: $str = "SELECT privilege FROM user WHERE user_id IN (".implode(', ', $params).")"; break;
                case 4: $str = "SELECT creation_date FROM user WHERE user_id IN (".implode(', ', $params).")"; break;
                case 5: $str = "SELECT avatar FROM user WHERE user_id IN (".implode(', ', $params).")"; break;
                case 6: $str = "SELECT status FROM user WHERE user_id IN (".implode(', ', $params).")"; break;
                case 7: $str = "SELECT last_logout_date FROM user WHERE user_id IN (".implode(', ', $params).")"; break;

                default: $str = "SELECT user_id FROM user WHERE user_id IN (".implode(', ', $params).")"; break;
            }

            $query = $database -> prepare($str);
            $query -> execute();

            if($query -> rowCount() > 0) {
    
                $row = $query -> fetchAll(PDO::FETCH_CLASS);
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