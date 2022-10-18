<?php

    include("./common.php");

    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "POST") {

        denyRequest(400, "Invalid request method, expected POST while got: " . $_SERVER["REQUEST_METHOD"]);
    }

    else {

        session_start();
        $params = json_decode(file_get_contents("php://input"), true);

        if(!empty($params["username"]) && !empty($params["password"])) {

            if(checkCredentials($params["username"], $params["password"]) == false) {

                die();
            }

            if(isset($_SESSION["session_username"]) && $_SESSION["session_username"] == $params["username"]) {

                requestError(6);
            }

            else {

                try {

                    $database = dbConnect();
                    $query = $database -> prepare("SELECT user_id FROM users WHERE username = ?");
                    $query -> execute([$params["username"]]);

                    if($query -> rowCount() > 0) {

                        requestError(3);
                    }

                    else {

                        $password_for_db = password_hash(trim($params["password"]), PASSWORD_DEFAULT);
                        $query = $database -> prepare("SELECT user_id FROM users ORDER BY user_id DESC");
                        $query -> execute();
                        $biggest_id = $query -> fetch(PDO::FETCH_ASSOC);

                        if($biggest_id == false) {

                            $user_id = 0;
                        }

                        else {

                            $user_id = $biggest_id["user_id"] + 1;
                        }

                        $query = $database -> prepare("INSERT INTO users (user_id, username, password) VALUES (?,?,?)");
                        $query -> execute([$user_id, $params["username"], $password_for_db]);

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