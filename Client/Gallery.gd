extends "res://Cards_list_client.gd"


var cards_num = get_card_list_size() - 2
var current_card
var sound_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	sound_volume = 0.2
	change_card(1)

func change_card(id):
	$Card_sprite/Card_number.text = "%d/%d" % [id , cards_num]
	var texture = load("res://Resources/%d.png" % id)
	$Card_sprite.set_texture(texture)
	current_card=id

func _process(delta):
	if Input.is_action_just_released("ui_right"):
		_on_Next_button_pressed()
		
	if Input.is_action_just_released("ui_left"):
		_on_Previous_button_pressed()

remote func play_sound(sound, volume = null):
	var player = AudioStreamPlayer.new()
	player.volume_db = sound_volume
	player.stream = load("res://Resources/" + String(sound) +".wav")
	self.add_child(player)
	player.play()
	yield(player, "finished")
	self.remove_child(player)


func _on_Previous_button_pressed():
	if current_card == 1:
		change_card(cards_num)
	else:
		change_card(current_card-1)


func _on_Next_button_pressed():
	if current_card == cards_num:
		change_card(1)
	else:
		change_card(current_card+1)


func _on_Exit_pressed():
	get_tree().change_scene("res://Lobby.tscn")



func _on_HSlider_value_changed(value):
	sound_volume = linear2db(value)



func _on_Audio_player_pressed():
	play_sound(current_card)


func _on_Search_confirm_pressed():
	var searched_card = $Search_bar.text.to_lower()
	var list = []
	for card in card_list_dict:
		if searched_card in card_list_dict[card]["nome"].to_lower() and card>0:
			list.append(card)
	if list.size():
		for card in list:
			$Search_bar/PopupMenu2.add_item(card_list_dict[card]["nome"])
		$Search_bar/PopupMenu2.popup(Rect2($Search_bar/PopupMenu2.rect_position, $Search_bar/PopupMenu2.rect_size))



func _on_PopupMenu2_popup_hide():
	$Search_bar/PopupMenu2.clear()


func _on_PopupMenu2_index_pressed(index):
	var name = $Search_bar/PopupMenu2.get_item_text(index)
	for card in card_list_dict:
		if name == card_list_dict[card]["nome"]:
			change_card(card)

