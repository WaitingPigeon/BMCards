extends Node

const DEFAULT_PORT = 10001
var SERVER_IP = ''

signal connection_success
signal connection_fail
signal existing_username
signal registration_successful
signal non_existing_username
signal already_online
signal wrong_password
signal update_online_players
signal login_success
signal disconnected_opponent
signal new_line_chat

var username = ''
var opponent = ''
var opponent_user = ''
var letter = ''
var last_chat_line = ''
var chat_text = ''
var players_online = {}
var playing_players = {}

func revert_dict(dict):
	var new_dict = {}
	for key in dict:
		new_dict[dict[key]] = key
	return new_dict
func _ready():
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	get_tree().connect('server_disconnected', self, 'return_to_home')
	get_tree().connect('connection_failed', self, '_connected_fail')
func return_to_lobby():
	get_tree().change_scene('res://Lobby.tscn')
func return_to_home():
	get_tree().change_scene('res://Login.tscn')
func connect_to_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	yield(get_tree().create_timer(5.0), "timeout")
	if peer.get_connection_status() == 1 or peer.get_connection_status() == 0:
		get_tree().set_network_peer(null)
		emit_signal('connection_fail')
func _connected_to_server():
	emit_signal('connection_success')
func server_access(state, username, password):
	if state == 'register':
		rpc_id(1, 'register_account', username, password)
	elif state == 'login':
		rpc_id(1, 'login_account', username, password)
remote func existing_username():
	emit_signal("existing_username")
remote func registration_successful():
	emit_signal("registration_successful")
remote func non_existing_username():
	emit_signal("non_existing_username")
remote func already_online():
	emit_signal("already_online")
remote func wrong_password():
	emit_signal("wrong_password")
remote func login_success():
	emit_signal("login_success")
remote func update_online_players(dict1, dict2):
	players_online = dict1
	playing_players = dict2
	
	emit_signal("update_online_players")
remote func disconnected_player(id):
	if str(id) == str(opponent):
		emit_signal("disconnected_opponent")
remote func start_game(id, let):
	letter = let
	opponent = id
	if opponent in players_online:
		opponent_user = players_online[opponent]
	else:
		opponent_user = playing_players[opponent]
	get_tree().change_scene("res://Game_Client.tscn")
func join_queue():
	rpc_id(1, "join_queue")
func leave_queue():
	rpc_id(1, "leave_queue")
func won_game():
	rpc_id(1, "won_game", opponent, opponent_user, get_tree().get_network_unique_id(), username)

func send_chat_line(string):
	var msg = "\n\n" + Network.username + " : " + string
	rpc_id(1, "add_chat_line", msg)

remote func add_chat_line(string):
	last_chat_line = string
	chat_text = chat_text + string
	emit_signal("new_line_chat")
