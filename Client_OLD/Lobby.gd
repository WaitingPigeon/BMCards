extends Node

const data_file = "user://savegame_music_settings.save"

func _ready():
	randomize()
	Network.connect("update_online_players", self, "update_online_players")
	Network.connect("new_line_chat", self, "new_line_chat")
	$Match_history.append_bbcode(Network.chat_text)
	var file_handler = File.new()
	file_handler.open(data_file, File.WRITE)
	file_handler.store_line(to_json(db2linear(Network.sound_volume)))
	file_handler.store_line(to_json(db2linear(Network.music_volume)))
	file_handler.close()
func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_ENTER:
		var string = $LineEdit.text
		if string == "":
			return
		$LineEdit.clear()
		Network.send_chat_line(string)

func update_online_players():
	$Players_list.clear()
	var counter = 0
	var player_dict = Network.players_online
	for key in player_dict:
		$Players_list.add_item(player_dict[key], null, false)
		$Players_list.set_item_custom_fg_color (counter, Color( 0.49, 0.99, 0, 1 ))
		counter += 1
	for key in Network.playing_players:
		$Players_list.add_item(Network.playing_players[key], null, false)
		$Players_list.set_item_custom_fg_color (counter, Color( 1, 0.27, 0, 1 ))
		counter += 1

func new_line_chat():
	var string = Network.last_chat_line
	$Match_history.append_bbcode(string)

func _on_Gioca_pressed():
	Network.join_queue()
	$Gioca.text = "In coda"
	$Gioca.disabled = true
	$Annulla.disabled = false
	
func _on_Annulla_pressed():
	Network.leave_queue()
	$Gioca.text = "Gioca"
	$Gioca.disabled = false
	$Annulla.disabled = true

func _on_Button_pressed():
	var string = $LineEdit.text
	if string == "":
		return
	$LineEdit.clear()
	Network.send_chat_line(string)

func _on_Button2_pressed():
	get_tree().quit()

func _on_Button3_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Galleria_pressed():
	Network.leave_queue()
	get_tree().change_scene("res://Gallery.tscn")
