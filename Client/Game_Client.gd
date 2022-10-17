extends Node

const Card_scene = preload("res://BMCard.tscn")

var active_card = null
var active_spot = null

var token_timer = null

func get_free_handspot():
	for i in range(1, 11):
		if get_node("player/hand/card{num}_spot".format({"num":i})).get_child_count() == 0: #If there isn't a card present
			return(i)
	return(-1)

func change_active_card(card=null):
	if not card == null:
		#yield(get_tree().create_timer(0.1), "timeout")
		while not $zoom_timer.is_stopped():
			yield(get_tree().create_timer(0.01), "timeout")
		active_card = card
		$zoom_timer.start()

	else:
		$zoom_timer.stop()
		$left_zoom.hide()
		$center_zoom.hide()
		$right_zoom.hide()

func _on_zoom_timer_timeout():
	if active_card == null:
		return
	if active_card.place == "hand" or active_card.board_color == "blue" or active_card.board_color == "red":
		$center_zoom.id = active_card.id
		$center_zoom.card_name =  active_card.card_name
		$center_zoom.families = active_card.families
		$center_zoom.type = active_card.type
		$center_zoom.max_attack = active_card.max_attack
		$center_zoom.attack = active_card.attack
		$center_zoom.max_health = active_card.max_health
		$center_zoom.health = active_card.health
		$center_zoom.cost = active_card.cost
		$center_zoom.quantity = active_card.quantity
		$center_zoom.playable_colors = active_card.playable_colors
		$center_zoom.card_text = active_card.card_text
		$center_zoom.token = active_card.token
		$center_zoom.place = active_card.place
		$center_zoom.player = active_card.player
		$center_zoom.board_type = active_card.board_type
		$center_zoom.board_color = active_card.board_color
		$center_zoom.board_pos = active_card.board_pos
		$center_zoom.update_image()
		$center_zoom.show()
		
func create_new_card(id, card_name, families, type, max_attack, attack, max_health, health, cost, quantity, playable_colors, card_text, token, loc): 
	var new_card = Card_scene.instance()
	new_card.id = id
	new_card.card_name = card_name
	new_card.families = families
	new_card.type = type
	new_card.max_attack = max_attack
	new_card.attack = attack
	new_card.max_health = max_health 
	new_card.health = health
	new_card.cost = cost
	new_card.quantity = quantity
	new_card.playable_colors = playable_colors
	new_card.card_text = card_text
	new_card.token = token
	new_card.set_loc(loc)
	
	new_card.update_image()
	
	if new_card.place == 'board':
		#print("{player}/{color}_board/{type}_{pos}_spot".format({"player":player, "color":board_color, "type":board_type, "pos":board_pos}))
		get_node("{player}/{color}_board/{type}_{pos}_spot".format({"player":new_card.player, "color":new_card.board_color, "type":new_card.board_type, "pos":new_card.board_pos})).add_child(new_card)
	elif new_card.place == 'hand':
		get_node("{player}/hand/card{number}_spot".format({"player":new_card.player, "number":get_free_handspot()})).add_child(new_card)
	#new_card.position = Vector2(-5000,-5000)
	new_card.z_index = 3
	new_card.scale = Vector2(2.1, 2.1)
	new_card.rotation_degrees = -90
	new_card.get_node("Card_shape").connect("mouse_entered", new_card, "change_active_card") #bad coding to overcome Godot limits
	new_card.get_node("Card_shape").connect("mouse_exited", self, "change_active_card")
	return(new_card)

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	var card1 = create_new_card(1, "ciao", [], "hero", 1, 1, 1, 1, 1, 1, ["red"], "ciao", -1, {"place":"board","player":"player", "board_type":"hero", "board_color":"blue", "board_pos":"left"})
	yield(get_tree().create_timer(1.0), "timeout")
	var card2 = create_new_card(1, "ciao", [], "hero", 1, 1, 1, 1, 1, 1, ["red"], "ciao", -1, {"place":"board","player":"player", "board_type":"hero", "board_color":"blue", "board_pos":"right"})
	for i in range(5):
		yield(get_tree().create_timer(1.0), "timeout")
		create_new_card(1, "ciao", [], "hero", 1, 1, 1, 1, 1, 1, ["red"], "ciao", -1, {"place":"hand","player":"player"})

	


"""
onready var isDraggingItem:bool = false
onready var mouseButtonReleased:bool = true
onready var draggedItemSlot:int = -1
onready var initial_mousePos:Vector2 = Vector2()
onready var activeItemSlot = -1
onready var activeItemArea = "null"


func get_active_slot():
	for area in ["hand1","red_heros1","blue_heros1","green_heros1","red_spells1","blue_spells1","green_spells1","hand2","red_heros2","blue_heros2","green_heros2","red_spells2","blue_spells2","green_spells2"]:
		var mouse_pos = area_dict[area].get_local_mouse_position()
		if Rect2(Vector2(0,0), area_dict[area].get_size()).has_point(mouse_pos):
			activeItemSlot =  area_dict[area].get_item_at_position(mouse_pos,true)
			activeItemArea = area
			return
		activeItemArea = "null"
		activeItemSlot = -1
func _process(delta):
	if (isDraggingItem):
		$Board_Stuff/Puppet_sprite.global_position = get_viewport().get_mouse_position()
func _input(event):
	if (event is InputEventMouseButton):
		if (event.is_action_pressed("mouse_leftbtn")):
			get_active_slot()
			if (activeItemSlot >= 0):
				if (area_dict[activeItemArea].is_item_selectable(activeItemSlot)):
					if not is_beta_busy:
						$Board_Stuff/Card_Container/Selected_card.texture = area_dict[activeItemArea].get_item_icon(activeItemSlot)
					mouseButtonReleased = false
					initial_mousePos = get_viewport().get_mouse_position()
			
		if (event.is_action_released("mouse_leftbtn")):
			move_item()
			end_drag_item()
			
	if (event is InputEventMouseMotion):
		get_active_slot()
		if (activeItemSlot >= 0):
			area_dict[activeItemArea].select(activeItemSlot, true)
			if (isDraggingItem):
				return
			if (!area_dict[activeItemArea].is_item_selectable(activeItemSlot)):
				end_drag_item()
				return
			if not is_beta_busy:
				$Board_Stuff/Card_Container/Selected_card.texture = area_dict[activeItemArea].get_item_icon(activeItemSlot)
			if (initial_mousePos.distance_to(get_viewport().get_mouse_position()) > 0.0) and !mouseButtonReleased and activeItemArea == "hand1":
				begin_drag_item(activeItemSlot)
		else:
			activeItemSlot = -1
func begin_drag_item(index:int):
	if (isDraggingItem):
		return
	if (index < 0):
		return
	set_process(true)
	$Board_Stuff/Puppet_sprite.texture = $Player_1/Hand_area/Cards.get_item_icon(index)
	#set_sprite_size($Board_Stuff/Puppet_sprite,$Player_1/Hand_area/Cards.fixed_icon_size)
	$Board_Stuff/Puppet_sprite.show()
	$Player_1/Hand_area/Cards.set_item_icon(index, load("res://Resources/0.png"))
	draggedItemSlot = index
	isDraggingItem = true
	mouseButtonReleased = false
	$Board_Stuff/Puppet_sprite.global_translate(get_viewport().get_mouse_position())
func end_drag_item():
	set_process(false)
	draggedItemSlot = -1
	$Board_Stuff/Puppet_sprite.hide()
	mouseButtonReleased = true
	isDraggingItem = false
	activeItemSlot = -1
	update_hand_cards()



"""
