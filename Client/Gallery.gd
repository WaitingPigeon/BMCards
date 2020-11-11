extends "res://Cards_list_client.gd"


var cards_num = get_card_list_size()-2
var current_card
var sound_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	sound_volume=5
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


func _on_Button_pressed():
	play_sound(current_card)
