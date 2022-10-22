<?php

    include("./common.php");

    // check if the request method is the correct one
    if($_SERVER["REQUEST_METHOD"] !== "POST") {

        http_response_code(400); // "bad request"
    }

    else {

        // decode the JSON in the body of the request
        $params = json_decode(file_get_contents("php://input"), true);

        // check if the credentials conform to the regexes (in case the client didn't do it already...)
        if(validateCredentials($params["username"], $params["password"]) == true) {

            try {

                // index the DB and fetch the user_id
                $database = dbConnect();
                $query = $database -> prepare("
                
                    SELECT user_id
                    FROM user
                    WHERE username = ?
                ");

                $query -> bindValue(1, $params["username"], PDO::PARAM_STR);
                $query -> execute();

                
                // check if the query found the target user
                if($query -> rowCount() > 0) {

                    http_response_code(403); // "forbidden"
                }

                else {

                    // create a new DB row and populate it
                    $password_for_db = password_hash($params["password"], PASSWORD_DEFAULT);
                    $query = $database -> prepare("

                        INSERT INTO user (username, password, privilege, creation_date, avatar, status)
                        VALUES (?,?,?,?,?,?)
                    ");

                    $query -> bindValue(1, $params["username"], PDO::PARAM_STR);
                    $query -> bindValue(2, $password_for_db, PDO::PARAM_STR);
                    $query -> bindValue(3, 0, PDO::PARAM_INT);
                    $query -> bindValue(4, date("Y/m/d"), PDO::PARAM_STR);
                    $query -> bindValue(5, 0, PDO::PARAM_INT);
                    $query -> bindValue(6, 0, PDO::PARAM_INT);
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

            catch(PDOException $exc) {

                // server error
                http_response_code(500); // "internal server error"
            }
        }

        else {

            // bad parameters
            http_response_code(400); // "bad request"
        }
    }

 //____________________________________________________________________________________________________________________________

    // check if the credentials conform to the given regexes
    function validateCredentials($username, $password) {

        $expr = preg_match("/^[a-zA-Z0-9_-]{3,16}$/", $username);
        $expr_2 = preg_match("/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*_-]).{8,}$/", $password);

        return($expr && $expr_2);
    }
?>