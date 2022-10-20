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
    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "DELETE") {

        denyRequest(400, "Invalid request method, expected DELETE while got: ".$_SERVER["REQUEST_METHOD"]);
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

                // index the DB and fetch the user_id, password and status
                $database = dbConnect();
                $query = $database -> prepare("
                
                    SELECT user_id, password
                    FROM user
                    WHERE username = ?
                ");

                $query -> execute([$params["username"]]);
                
                // check if the query found the target user
                if($query -> rowCount() > 0) {
    
                    $row = $query -> fetch(PDO::FETCH_ASSOC);

                    // verify the passwords
                    if(password_verify($params["password"], $row["password"]) == true) {

                        // delete the user from the DB
                        /* REMEMBER TO DEREFERENCE THE POTENTIAL FOREIGN KEYS */
                        $query = $database -> prepare("
                
                            DELETE FROM user
                            WHERE user_id = ?
                        ");

                        $query -> execute([$row["user_id"]]);
                        requestOk(array("message" => "Unregistration ok"));
                    }

                    else {

                        requestError(4);
                    }
                }

                else {

                    requestError(5);
                }
            }
        }

        else {

            denyRequest(400, "Invalid, null or empty arguments.");
        }
    }
?>