<?php

    include("./common.php");

    // check if the request method is the correct one
    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "POST") {

        denyRequest(400, "Invalid request method, expected POST while got: " . $_SERVER["REQUEST_METHOD"]);
    }

    else {

        // decode the JSON in the body of the request
        $params = json_decode(file_get_contents("php://input"), true);

        // check if they are not empty
        if(!empty($params["username"]) && !empty($params["password"])) {
            
            // check if the credentials conform to the regexes (in case the client didn't do it already...)
            if(checkCredentials($params["username"], $params["password"]) == false) {

                die();
            }

            else {

                try {

                    // index the DB and see if the target username already exists
                    $database = dbConnect();
                    $query = $database -> prepare("
                    
                        SELECT user_id, status
                        FROM users
                        WHERE username = ?
                    ");

                    $query -> execute([$params["username"]]);

                    if($query -> rowCount() > 0) {

                        $row = $query -> fetch(PDO::FETCH_ASSOC);
                        
                        if($row["status"] != 0) {

                            // target user already exists and is logged-in !
                            requestError(6);
                        }

                        else {

                            // target user already exists
                            requestError(3);
                        }
                    }

                    else {

                        // create a new DB row and populate it
                        $password_for_db = password_hash(trim($params["password"]), PASSWORD_DEFAULT);
                        $query = $database -> prepare("

                            INSERT INTO users (username, password, privilege, creation_date, avatar, status, last_logout_date)
                            VALUES (?,?,?,?,?,?,?)
                        ");

                        $query -> execute([$params["username"], $password_for_db, 0, date("Y/m/d"), 0, 0, NULL]);

                        if($query == true) {

                            requestOk("Register ok");
                        }

                        else {

                            denyRequest(500, "Registration query error");
                        }
                    }
                }

                catch(PDOException $exc) {
    
                    denyRequest(500, $exc -> getMessage());
                }
            }
        }

        else {

            denyRequest(400, "Invalid, null or empty arguments.");
        }
    }
?>