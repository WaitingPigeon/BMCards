<?php

    include("./common.php");

    // check if the request method is the correct one
    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "GET") {

        denyRequest(400, "Invalid request method, expected GET while got: " . $_SERVER["REQUEST_METHOD"]);
    }

    else {

        if(!empty($_GET["username"])) {

            // index the DB and fetch the user_id
            $database = dbConnect();
            $query = $database -> prepare("
            
                SELECT user_id
                FROM users
                WHERE username = ?
            ");

            $query -> execute([$_GET["username"]]);

            if($query -> rowCount() > 0) {
    
                $row = $query -> fetch(PDO::FETCH_ASSOC);
                requestOk($row["user_id"]);
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