<?php

    /*
        parameters & return values (all in JSON)

        REQUEST BODY:

            {
                "username": String
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
        if(!empty($params["username"])) {

            try {

                // index the DB and fetch the status and ID of the target user
                $database = dbConnect();
                $query = $database -> prepare("
                    
                    SELECT user_id, status
                    FROM user
                    WHERE username = ?
                ");

                $query -> execute([$params["username"]]);

                // check if it exists
                if($query -> rowCount() > 0) {

                    $row = $query -> fetch(PDO::FETCH_ASSOC);
                    
                    // check if it's already offline
                    if($row["status"] == 0) {

                        requestError(7);
                    }

                    else {

                        // change the user status in the DB and set the logout datetime
                        $query = $database -> prepare("
                        
                            UPDATE user
                            SET status = 0, last_logout_date = ?
                            WHERE user_id = ?
                        ");

                        $query -> execute([date("Y/m/d H:i:s"), $row["user_id"]]);
                        requestOk(array("message" => "Logout ok"));
                    }
                }

                else {

                    // target user doesn't exist
                    requestError(5);
                }
            }

            catch(PDOException $exc) {
    
                denyRequest(500, $exc -> getMessage());
            }
        }

        else {

            denyRequest(400, "Invalid, null or empty arguments.");
        }
    }
?>