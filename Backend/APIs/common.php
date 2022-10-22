<?php

    // function to create a database object and connect to it
    function dbConnect() {

        $config = json_decode(file_get_contents("./config.json"), true);
        $db = new PDO("mysql:host=".$config["db_host"].";dbname=".$config["db_name"], $config["db_username"], $config["db_password"]);
        $db -> setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        return($db);
    }

    function validateParam($param) {

        return($param !== null && $param !== "");
    }

    /*
        custom return codes {

            0: ok
            1: password doesn't conform
            2: username doesn't conform
            3: username already exists
            4: wrong password
            5: username not found
            6: user is already logged-in
            7: user already offline
        }
    */
?>
