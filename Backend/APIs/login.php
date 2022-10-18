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
                    $query = $database -> prepare("SELECT password FROM users WHERE username = ?");
                    $query -> execute([$params["username"]]);

                    if($query -> rowCount() > 0) {
    
                        $row = $query -> fetch(PDO::FETCH_ASSOC);
                        
                        if(password_verify($params["password"], $row["password"]) == true) {
    
                            $_SESSION["session_username"] = $params["username"];
                            requestOk("Login ok");
                        }
    
                        else {
    
                            requestError(4);
                        }
                    }
    
                    else {
    
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