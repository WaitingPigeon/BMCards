<?php

    /*
        parameters & return values (all in JSON)

        REQUEST BODY:

            {
                "username": String,
                "password": String
            }

        RESPONSE BODY:

            if HTTP != 200:

                {
                    "return_status": null,
                    "cause": String
                }

            else:

                if request was successful:

                    {
                        "return_status": 0,
                        "payload": {

                            "user_id": Int,
                            "message": String
                        }
                    }

                else:

                    {
                        "return_status": Int,
                        "cause": String
                    }
    */

    include("./common.php");

    // check if the request method is the correct one
    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "POST") {

        denyRequest(400, "Invalid request method, expected POST while got: ".$_SERVER["REQUEST_METHOD"]);
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

                    // index the DB and fetch the user_id, password and status
                    $database = dbConnect();
                    $query = $database -> prepare("
                    
                        SELECT user_id, password, status
                        FROM user
                        WHERE username = ?
                    ");

                    $query -> execute([$params["username"]]);

                    // check if the query found the target user
                    if($query -> rowCount() > 0) {
    
                        $row = $query -> fetch(PDO::FETCH_ASSOC);

                        // check if the user is already logged-in
                        if($row["status"] != 0) {

                            requestError(6);
                        }

                        else {

                            // verify the passwords
                            if(password_verify($params["password"], $row["password"]) == true) {
    
                                // change the user status in the DB
                                $query = $database -> prepare("
                        
                                    UPDATE user
                                    SET status = 1
                                    WHERE user_id = ?
                                ");
    
                                $query -> execute([$row["user_id"]]);
                                requestOk(array("user_id" => $row["user_id"], "message" => "Login was successful"));
                            }
        
                            else {
        
                                // wrong password
                                requestError(4);
                            }
                        }
                    }
    
                    else {
    
                        // user doesn't exist
                        requestError(5);
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