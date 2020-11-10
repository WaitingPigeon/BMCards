extends "res://Cards_list_client.gd"


var cards_num = get_card_list_size()-2
var current_card

# Called when the node enters the scene tree for the first time.
func _ready():
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
