extends Node

const DEFAULT_PORT = 10001
const MAX_PLAYERS = 20
var players_online = {}
var registred_players = {}
var playing_players = {}
const data_file = "user://savegame.save"
var queue = []


func _ready():
	var file_handler = File.new()
	if not file_handler.file_exists(data_file):
		var file_handler2 = File.new()
		file_handler2.open(data_file, File.WRITE)
		file_handler2.store_line(to_json({}))
		file_handler2.close()
	file_handler.open(data_file, File.READ)
	registred_players = parse_json(file_handler.get_line())
	file_handler.close()
	create_server()
	while true:
		yield(get_tree().create_timer(3.0), "timeout")
		check_online()
		rpc("update_online_players", players_online, playing_players)
		
	
func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	get_tree().connect('network_peer_disconnected', self, 'peer_disconnected')
	get_tree().connect('network_peer_connected', self, 'peer_connected')

func peer_disconnected(id):
	if id in players_online:
		players_online.erase(id)
		rpc("update_online_players", players_online)
		rpc("disconnected_player", id)

func peer_connected(id):
	pass

remote func register_account(username, password):
	var id = get_tree().get_rpc_sender_id()
	if username in registred_players:
		rpc_id(id, "existing_username")
		return
	registred_players[username] = password
	var file_handler3 = File.new()
	file_handler3.open(data_file, File.WRITE)
	file_handler3.store_line(to_json(registred_players))
	file_handler3.close()
	rpc_id(id, "registration_successful")

remote func login_account(username, password):
	var id = get_tree().get_rpc_sender_id()
	if not username in registred_players:
		rpc_id(id, "non_existing_username")
		return
	if username in players_online.values() or username in playing_players.values():
		rpc_id(id, "already_online")
		return
	if not registred_players[username] == password:
		rpc_id(id, "wrong_password")
		return
	rpc_id(id, "login_success")
	players_online[id] = username
	yield(get_tree().create_timer(0.5), "timeout")
	rpc("update_online_players", players_online, playing_players)



remote func join_queue():
	var id = get_tree().get_rpc_sender_id()
	queue.append(id)
	if queue.size() > 1:
		var letters = ['a', 'b']
		letters.shuffle()
		rpc_id(queue[0], "start_game", queue[1], letters[0])
		rpc_id(queue[1], "start_game", queue[0], letters[1])
		var id1 = queue[0]
		var id2 = queue[1]
		var user1 = players_online[queue[0]]
		var user2 = players_online[queue[1]]
		queue.pop_front()
		queue.pop_front()
		players_online.erase(id1)
		players_online.erase(id2)
		playing_players[id1] = user1
		playing_players[id2] = user2
		rpc("update_online_players", players_online, playing_players)
	
remote func leave_queue():
	queue.erase(get_tree().get_rpc_sender_id())

remote func won_game(loser, loser_user, winner, winner_user):
	if winner in playing_players:
		playing_players.erase(winner)
		players_online[winner] = winner_user
	if loser in playing_players:
		playing_players.erase(loser)
		players_online[loser] = loser_user
	rpc("update_online_players", players_online, playing_players)
	var msg = "\n\n[tornado radius=5 freq=2][rainbow freq=0.2 sat=10 val=20]" + winner_user + "[/rainbow] ha sconfitto [b][color=red]" + loser_user + "[/color][/b][/tornado]"
	add_chat_line(msg)

remote func add_chat_line(string):
	rpc("add_chat_line", string)
	print(string)

func check_online():
	var list_id = get_tree().multiplayer.get_network_connected_peers()
	for i in players_online:
		if !(i in list_id):
			players_online.erase(i)
			rpc("disconnected_player", i)
	for i in playing_players:
		if !(i in list_id):
			playing_players.erase(i)
			rpc("disconnected_player", i)
	
