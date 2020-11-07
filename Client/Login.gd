extends Node
var state = ''
const data_file =  "user://savegame_client.save"
var Server_IP = ""

func _ready():
	Network.connect("connection_success", self, "on_connection_success")
	Network.connect("connection_fail", self, "on_connection_failure")
	Network.connect("different_version", self, "different_version")
	Network.connect("existing_username", self, "existing_username")
	Network.connect("registration_successful",self, "registration_successful")
	Network.connect("non_existing_username", self, "non_existing_username")
	Network.connect("already_online", self, "already_online")
	Network.connect("wrong_password", self, "wrong_password")
	Network.connect("login_success",self, "login_success")
	var file_handler = File.new()
	if not file_handler.file_exists(data_file):
		var file_handler2 = File.new()
		file_handler2.open(data_file, File.WRITE)
		file_handler2.store_line(to_json(""))
		file_handler2.close()
	file_handler.open(data_file, File.READ)
	Network.SERVER_IP = str(parse_json(file_handler.get_line()))
	file_handler.close()
	$Server_IP.text = Network.SERVER_IP
	var file_handler3 = File.new()
	if not file_handler3.file_exists("user://savegame_music_settings.save"):
		var file_handler4 = File.new()
		file_handler4.open("user://savegame_music_settings.save", File.WRITE)
		file_handler4.store_line(to_json(0.1))
		file_handler4.store_line(to_json(0.1))
		file_handler4.close()
	file_handler3.open("user://savegame_music_settings.save", File.READ)
	Network.sound_volume = linear2db(parse_json(file_handler3.get_line()))
	Network.music_volume = linear2db(parse_json(file_handler3.get_line()))
	file_handler3.close()

func _on_Login_Button_pressed():
	if $Username.text.strip_edges(true, true) == '' or $Password.text.strip_edges(true, true) == '':
		$Status.text = "I campi non devono essere lasciati vuoti"
		return
	$Login_Button.disabled = true
	$Register_Button.disabled = true
	$Server_IP.readonly = true
	$Username.readonly = true
	$Password.readonly = true
	state = 'login'
	$Status.text = "Connessione al server"
	Network.SERVER_IP = str($Server_IP.text).strip_edges(true, true)
	var file_handler = File.new()
	file_handler.open(data_file, File.WRITE)
	file_handler.store_line(to_json(Network.SERVER_IP))
	file_handler.close()
	Network.connect_to_server()

func _on_Register_Button_pressed():
	if $Username.text.strip_edges(true, true) == '' or $Password.text.strip_edges(true, true) == '':
		$Status.text = "I campi non devono essere lasciati vuoti"
		return
	$Login_Button.disabled = true
	$Register_Button.disabled = true
	$Server_IP.readonly = true
	$Username.readonly = true
	$Password.readonly = true
	state = 'register'
	$Status.text = "Connessione al server"
	Network.SERVER_IP = str($Server_IP.text).strip_edges(true, true)
	var file_handler = File.new()
	file_handler.open(data_file, File.WRITE)
	file_handler.store_line(to_json(Network.SERVER_IP))
	file_handler.close()
	Network.connect_to_server()

func on_connection_success():
	Network.server_access(state, $Username.text.strip_edges(true, true), $Password.text.strip_edges(true, true))

func reactivate():
	$Login_Button.disabled = false
	$Register_Button.disabled = false
	$Username.readonly = false
	$Password.readonly = false
	$Server_IP.readonly = false

func on_connection_failure():
	reactivate()
	$Status.text = "Connessione fallita. Controlla la connessione ad internet"

func existing_username():
	reactivate()
	$Status.text = "L'username è già in uso"

func different_version():
	reactivate()
	$Status.text = "Il server sta usando una versione diversa del gioco. (Server: " + Network.SERVER_VERSION + ", Tu: " + Network.CLIENT_VERSION + ")"

func registration_successful():
	reactivate()
	$Status.text = "Profilo registrato correttamente"
	
func non_existing_username():
	reactivate()
	$Status.text = "Username non registrato"
	
func already_online():
	reactivate()
	$Status.text = "Il profilo selezionato è già online"

func wrong_password():
	reactivate()
	$Status.text = "Password errata"

func login_success():
	Network.username = $Username.text.strip_edges(true, true)
	get_tree().change_scene("res://Lobby.tscn")


func _on_Button_pressed():
	get_tree().quit()
