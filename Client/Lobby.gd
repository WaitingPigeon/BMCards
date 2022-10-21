extends Node

var response

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Accendo la lobby")
	$HTTPRequest.connect("request_completed", self, "_http_request_completed")
	
func _http_request_completed(result, response_code, headers, body):
	response = parse_json(body.get_string_from_utf8())
	print(response)
	
	if(response["return_status"] == 0):
	
		print("LOGIN OK")
		#change scene

func _on_Login_button_pressed():
	#Password123!
	
	print("post request")
	var url = "http://localhost/My_Projects/BMCards_php/login.php"
	var body = JSON.print({"username":$LineEdit.text, "password":$LineEdit2.text})
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, true, HTTPClient.METHOD_POST, body)
