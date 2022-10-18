<?php

    include("./common.php");

    if(isset($_SERVER["REQUEST_METHOD"]) == false || $_SERVER["REQUEST_METHOD"] != "POST") {

        header("HTTP/1.1 400 invalid request");
        deny_request("server was expecting a POST request.");
    }

    else {

        session_start();
        $var = json_decode(file_get_contents('php://input'), true);

        if($var != null) {

            if(isset($_SESSION["uname"]) == $var["username"]) {

                // user is already logged-in
                request_error(-6, "you are already logged-in");
            }

            else {

                try {

                    // code goes here
                    //...
                }
            }
        }

        else {

            header("HTTP/1.1 400 invalid request");
            deny_request("invalid or null arguments.");
        }
    }

    /*$var = json_decode(file_get_contents('php://input'), true);

    if($var != null) {

        try {

            $database = dbConnect("root", "");
            $query = $database -> prepare("SELECT user_id FROM users WHERE username = ?");
            $query -> execute([$var["username"]]);

            if($query -> rowCount() > 0) {

                // return a 2 in a json file for now...
                print json_encode(["return_status" => 2]);
            }

            else {

                $password_for_db = password_hash(trim($var["password"]), PASSWORD_DEFAULT);
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
                $query -> execute([$user_id, $var["username"], $password_for_db]);

                if($query == true) {

                    // return a 1 in a json file for now...
                    print json_encode(["return_status" => 1, "pass_was" => $var["password"]]);
                }

                else {

                    // return a 0 in a json file for now...
                    print json_encode(["return_status" => 0]);
                }
            }
        }

        catch(PDOException $exc) {

            // return a -1 in a json file for now...
            print json_encode(["return_status" => -1, "passed_username" => $temp]);
            die("Database error: " . $exc -> getMessage());
        }
    }*/
?>