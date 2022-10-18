<?php

    include("./common.php");

    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "POST") {

        denyRequest(400, "Invalid request method, expected POST while got: " . $_SERVER["REQUEST_METHOD"]);
    }

    else {

        $params = json_decode(file_get_contents("php://input"), true);

        if(!empty($params["username"]) && !empty($params["password"])) {

            if(checkCredentials($params["username"], $params["password"]) == false) {

                die();
            }

            else {

                try {

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

                            requestError(6);
                        }

                        else {

                            requestError(3);
                        }
                    }

                    else {

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

                            denyRequest(500, "Query error");
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