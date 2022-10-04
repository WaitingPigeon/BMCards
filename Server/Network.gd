extends Node

const DEFAULT_PORT = 7777
const MAX_PLAYERS = 500
const SERVER_VERSION = "alpha_2.0"

var offline_players = []
var lobby_players = []
var playing_players = []

var current_games = []

const data_file = "user://savegame.save"
var queue = []

#We create a dictionary (id: Card) with a copy of each card
var cards_samples = {}
var objectives_samples = {"blue":[], "green":[], "red":[]}

func _ready():
	randomize()
	#We load each card from Cards_scripts folder
	var card_dir = Directory.new()
	card_dir.open("res://Cards_scripts/")
	card_dir.list_dir_begin()
	var file_name = card_dir.get_next()
	while (file_name != ""):
		if not card_dir.current_is_dir():
			var card = load("res://Cards_scripts/" + file_name).new()
			cards_samples[card.id] = card
		file_name = card_dir.get_next()
		
	var obj_dir = Directory.new()
	obj_dir.open("res://Objs_scripts/")
	obj_dir.list_dir_begin()
	file_name = obj_dir.get_next()
	while (file_name != ""):
		if not obj_dir.current_is_dir():
			var obj = load("res://Objs_scripts/" + file_name).new()
			objectives_samples[obj.color].append(obj)
		file_name = obj_dir.get_next()
	
	var file_handler = File.new()
	if not file_handler.file_exists(data_file):
		var file_handler2 = File.new()
		file_handler2.open(data_file, File.WRITE)
		file_handler2.store_line(to_json([]))
		file_handler2.close()
	file_handler.open(data_file, File.READ)
	var registered_players = parse_json(file_handler.get_line())
	file_handler.close()
	
	for dictionary in registered_players:
		var nw_player = load("res://Player.gd").new()
		nw_player.username = dictionary["username"]
		nw_player.password = dictionary["password"]
		nw_player.achievements = dictionary["achievements"]
		add_child(nw_player)
		offline_players.append(nw_player)
		
	create_server()

func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	get_tree().connect('network_peer_disconnected', self, 'peer_disconnected')
	get_tree().connect('network_peer_connected', self, 'peer_connected')

func peer_disconnected(id):
	for player in lobby_players:
		if id == player.id:
			lobby_players.erase(player)
			offline_players.append(player)
			player.status = "offline"
			player.id = -1
			
	for player in playing_players:
		if id == player.id:
			player.game.player_disconnected(player)
			lobby_players.erase(player)
			offline_players.append(player)
			player.status = "offline"
			player.id = -1

func peer_connected(id):
	pass

remote func register_account(username, password, version):
	var id = get_tree().get_rpc_sender_id()
	if not version == SERVER_VERSION:
		rset_id(id, "SERVER_VERSION", SERVER_VERSION)
		rpc_id(id, "different_version")
		return
	for player in (offline_players + lobby_players + playing_players):
		if player.username == username:
			rpc_id(id, "existing_username")
			return
	
	var nw_player = load("res://Player.gd").new()
	nw_player.username = username
	nw_player.password = password
	nw_player.achievements = []
	add_child(nw_player)
	offline_players.append(nw_player)
	save_to_file()
	rpc_id(id, "registration_successful")

remote func login_account(username, password, version):
	var id = get_tree().get_rpc_sender_id()
	if not version == SERVER_VERSION:
		rset_id(id, "SERVER_VERSION", SERVER_VERSION)
		rpc_id(id, "different_version")
		return
	for player in (lobby_players + playing_players):
		if username == player.username:
			rpc_id(id, "already_online")
			return
	for player in offline_players:
		if username == player.username:
			if password == player.password:
				offline_players.erase(player)
				lobby_players.append(player)
				player.id = id
				player.status = "lobby"
				rpc_id(id, "login_success")
				return
			else:
				rpc_id(id, "wrong_password")
				return
	rpc_id(id, "non_existing_username")
	return

remote func add_chat_line(string):
	rpc("add_chat_line", string)
	print(string)

func save_to_file():
	var registered_players = []
	for player in (offline_players + lobby_players + playing_players):
		var dictionary = {}
		dictionary["username"] = player.username
		dictionary["password"] = player.password
		dictionary["achievements"] = player.achievements
		registered_players.append(player)
		
	var file_handler = File.new()
	file_handler.open(data_file, File.WRITE)
	file_handler.store_line(to_json(registered_players))
	file_handler.close()
	
