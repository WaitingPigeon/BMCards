<?php

    // function to connect to the database
    function dbConnect($username, $password) {

        $db = new PDO("mysql:host=localhost;dbname=test", $username, $password);
        $db -> setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        return($db);
    }

    // function to
    function check_params($params) {


    }

    function deny_request($message) {

        print json_encode(

            [

                "return_code" => null,
                "row_count" => 0,
                "error_msg" => $message,
                "payload" => null
            ]
        );
    }

    function request_error($return_code, $error_msg) {

        print json_encode(

            [

                "return_code" => $return_code,                
                "row_count" => 0,
                "error_msg" => $error_msg,
                "payload" => null
            ]
        );
    }

    function request_ok($modified_resources, $payload) {

        print json_encode(

            [

                "return_code" => 0,                
                "row_count" => $modified_resources,
                "error_msg" => null,
                "payload" => $payload
            ]
        );
    }

    /*
        API response object {

            {
                return code,
                payload
            }

            if HTTP == 200, then the object is populated
            if HTTP != 200, the the request itself failed
        }

        custom return codes {

            -6: user is already logged-in
            -5: login username not found
            -4: login wrong password
            -3: register username already exists
            -2: username doesn't conform
            -1: password doesn't conform
             0 : ok
        }
    */
?>
