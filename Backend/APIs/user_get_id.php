<?php

    include("./common.php");

    // check if the request method is the correct one
    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "GET") {

        denyRequest(400, "Invalid request method, expected GET while got: ".$_SERVER["REQUEST_METHOD"]);
    }

    else {

        $params = json_decode($_GET["username"]);

        if(!empty($params)) {

            // index the DB and fetch the user_id
            $database = dbConnect();
            $query = $database -> prepare("
            
                SELECT user_id
                FROM user
                WHERE username IN(".implode(', ', $params).")"
            );

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