<?php

    include("./common.php");

    // check if the request method is the correct one
    if($_SERVER["REQUEST_METHOD"] !== "DELETE") {

        http_response_code(400); // "bad request"
    }

    else {

        // decode the JSON in the body of the request
        $params = json_decode(file_get_contents("php://input"), true);

        // check if the credentials are valid
        if(validateParam($params["username"]) == true) {

            try {

                // index the DB and fetch the status and ID of the target user
                $database = dbConnect();
                $query = $database -> prepare("
                    
                    SELECT user_id, status
                    FROM user
                    WHERE username = ?
                ");

                $query -> bindParam(1, $params["username"], PDO::PARAM_STR);
                $query -> execute();

                // check if it exists
                if($query -> rowCount() > 0) {

                    $row = $query -> fetch(PDO::FETCH_ASSOC);
                    
                    // check if it's already offline
                    if($row["status"] == 0) {

                        http_response_code(403); // "forbidden"
                    }

                    else {

                        // change the user status in the DB and set the logout datetime
                        $query = $database -> prepare("
                        
                            UPDATE user
                            SET status = 0, last_logout_date = ?
                            WHERE user_id = ?
                        ");

                        $query -> bindParam(1, date("Y/m/d H:i:s"), PDO::PARAM_STR);
                        $query -> bindParam(2, $row["user_id"], PDO::PARAM_INT);
                        $query -> execute();
                        
                        // check if the query was successful
                        if($query == true) {

                            http_response_code(200); // "OK"
                        }

                        else {

                            http_response_code(500); // "internal server error"
                        }
                    }
                }

                else {

                    // target user doesn't exist
                    http_response_code(401); // "unauthorized"
                }
            }

            catch(PDOException $exc) {
    
                // server error
                http_response_code(500); // "internal server error"
            }
        }

        else {

            // parameter is malformed
            http_response_code(400); // "bad request"
        }
    }
?>