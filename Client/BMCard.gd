extends Node2D

var id = 1
var card_name = 'Eleonoraaaaa'
var families = ['Scemoooo']
var type = 'hero'
var max_attack = 5
var attack = 800
var max_health = 4
var health = 200
var cost = 3
var quantity = 1
var playable_colors = ['blue', 'red']
var card_text = """Hello"""
var token = -1

var place = null  #Can be deck, board, hand or grave
var player = null #Can be 'Player' or 'Opponent'
var board_type = null #Can be 'heros' or 'spells (or null if the card is in the deck, hand or grave)
var board_color = null #Can be 'blue', 'green' or 'red' (or null if the card is in the deck, hand or grave)
var board_pos = null #Can be 'left', 'center' or right (or null if the card is in the deck, hand or grave) 
func update_image():
	$Card/Card_image.texture = load("res://Resources/Card_images/Card_%s.png" % str(id)) 
	$Card/Title_container/Card_name.bbcode_text = "[center]" + card_name
	
	if len(families) == 0:
		$Card/Family_label1.hide()
		$Card/Family_label2.hide()
	elif len(families) == 1:
		$Card/Family_label1/Family1.text = families[0]
		$Card/Family_label1.show()
		$Card/Family_label2.hide()
	elif len(families) == 2:
		$Card/Family_label1/Family1.text = families[0]
		$Card/Family_label2/Family2.text = families[1]
		$Card/Family_label1.show()
		$Card/Family_label2.show()
	
	if type == 'hero':
		$Card/Type_label/Type.text = "Hero"
		$Card/sword/attack.text = str(attack)
		$Card/heart/health.text = str(health)
		if health > max_health:
			$Card/heart/health.add_color_override("font_color", Color("2FFF00"))
		elif health == max_health:
			$Card/heart/health.add_color_override("font_color", Color("FFFFFF"))
		elif health < max_health:
			$Card/heart/health.add_color_override("font_color", Color("FF0000"))
		if attack > max_attack:
			$Card/sword/attack.add_color_override("font_color", Color("2FFF00"))
		elif attack == max_attack:
			$Card/sword/attack.add_color_override("font_color", Color("FFFFFF"))
		elif attack < max_attack:
			$Card/sword/attack.add_color_override("font_color", Color("FF0000"))
		$Card/heart.show()
		$Card/sword.show()
	elif type == 'spell':
		$Card/Type_label/Type.text = "Spell"
		$Card/heart/health.text = str(health)
		if health > max_health:
			$Card/heart/health.add_color_override("font_color", Color("2FFF00"))
		elif health == max_health:
			$Card/heart/health.add_color_override("font_color", Color("FFFFFF"))
		elif health < max_health:
			$Card/heart/health.add_color_override("font_color", Color("FF0000"))
		$Card/heart.show()
		$Card/sword.hide()
	elif type == 'event':
		$Card/Type_label/Type.text = "Event"
		$Card/heart.hide()
		$Card/sword.hide()
		
	for i in range(5):
		if i+1 <= cost:
			get_node("Card/Bolts/bolt" + str(i+1)).show()
		else:
			get_node("Card/Bolts/bolt" + str(i+1)).hide()

	if len(playable_colors) == 1:
		if 'blue' in playable_colors:
			$Card.texture = load("res://Resources/Color_back/blue_back.png")
		elif 'green' in playable_colors:
			$Card.texture = load("res://Resources/Color_back/green_back.png")
		elif 'red' in playable_colors:
			$Card.texture = load("res://Resources/Color_back/red_back.png")
	elif len(playable_colors) == 2:
		if 'blue' in playable_colors and 'green' in playable_colors:
			$Card.texture = load("res://Resources/Color_back/blue_green_back.png")
		elif 'blue' in playable_colors and 'red' in playable_colors:
			$Card.texture = load("res://Resources/Color_back/blue_red_back.png")
		elif 'green' in playable_colors and 'red' in playable_colors:
			$Card.texture = load("res://Resources/Color_back/green_red_back.png")
	elif len(playable_colors) == 3:
		$Card.texture = load("res://Resources/Color_back/all_back.png")
	
	$Card/Effect_text/Container/Effect.bbcode_text = "[center]" + card_text

func _ready():
	update_image()

func set_loc(loc):
	#We change loc variables
	place = loc["place"] if "place" in loc else null
	player = loc["player"] if "player" in loc else null
	board_type = loc["board_type"] if "board_type" in loc else null
	board_color = loc["board_color"] if "board_color" in loc else null
	board_pos = loc["board_pos"] if "board_pos" in loc else null

func change_active_card(): #Tells the game this is the active card
	get_tree().get_current_scene().change_active_card(self)

