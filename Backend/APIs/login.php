<?php

    include("./common.php");

    // check if the request method is the correct one
    if($_SERVER["REQUEST_METHOD"] !== "POST") {

        http_response_code(400); // "bad request"
        print json_encode([

            "user_already_loggedin" => null,
            "payload" => array("user_id" => null)
        ]);
    }

    else {

        // decode the JSON in the body of the request
        $params = json_decode(file_get_contents("php://input"), true);

        // check if the credentials are valid
        if(validateParam($params["username"]) == true && validateParam($params["password"]) == true) {

            try {

                // index the DB and fetch the user_id, password and status
                $database = dbConnect();
                $query = $database -> prepare("
                
                    SELECT user_id, password, status
                    FROM user
                    WHERE username = ?
                ");

                $query -> bindValue(1, $params["username"], PDO::PARAM_STR);
                $query -> execute();

                // check if the query found the target user
                if($query -> rowCount() > 0) {

                    $row = $query -> fetch(PDO::FETCH_ASSOC);

                    // check if the user is already logged-in
                    if($row["status"] != 0) {

                        http_response_code(403); // "forbidden"
                        print json_encode([

                            "user_already_loggedin" => true,
                            "payload" => array("user_id" => null)
                        ]);
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

                            $query -> bindValue(1, $row["user_id"], PDO::PARAM_INT);
                            $query -> execute();

                            // check if the query was successful
                            if($query == true) {

                                http_response_code(200); // "OK"
                                print json_encode([

                                    "user_already_loggedin" => null,
                                    "payload" => array("user_id" => $row["user_id"])
                                ]);
                            }

                            else {

                                // server error
                                http_response_code(500); // "internal server error"
                                print json_encode([

                                    "user_already_loggedin" => null,
                                    "payload" => array("user_id" => null)
                                ]);
                            }
                        }
    
                        else {
    
                            // wrong password
                            http_response_code(403); // "forbidden"
                            print json_encode([

                                "user_already_loggedin" => false,
                                "payload" => array("user_id" => null)
                            ]);
                        }
                    }
                }

                else {

                    // no user found
                    http_response_code(401); // "unauthorized"
                    print json_encode([

                        "user_already_loggedin" => null,
                        "payload" => array("user_id" => null)
                    ]);
                }
            }

            catch(PDOException $exc) {

                // server error
                http_response_code(500); // "internal server error"
                print json_encode([

                    "user_already_loggedin" => null,
                    "payload" => array("user_id" => null)
                ]);
            }
        }

        else {

            // bad parameters
            http_response_code(400); // "bad request
            print json_encode([

                "user_already_loggedin" => null,
                "payload" => array("user_id" => null)
            ]);
        }
    }
?>