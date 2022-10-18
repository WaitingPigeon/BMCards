<?php

    include("./common.php");

    // check if the request method is the correct one
    if(empty($_SERVER["REQUEST_METHOD"]) || $_SERVER["REQUEST_METHOD"] != "DELETE") {

        denyRequest(400, "Invalid request method, expected DELETE while got: " . $_SERVER["REQUEST_METHOD"]);
    }

    else {

        $params = json_decode(file_get_contents("php://input"), true);

        if(!empty($params["username"])) {

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
                    
                    if($row["status"] == 0) {

                        requestError(8);
                    }

                    else {

                        // change the user status in the DB
                        $query = $database -> prepare("
                        
                            UPDATE users
                            SET status = 0, last_logout_date = ?
                            WHERE user_id = ?
                        ");

                        $query -> execute([date("Y/m/d H:i:s"), $row["user_id"]]);
                        requestOk("Logout ok");
                    }
                }

                else {

                    requestError(7);
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