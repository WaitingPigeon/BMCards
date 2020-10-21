extends "res://Game_Client.gd"

onready var area_dict = {"hand1":$Player_1/Hand_area/Cards,"blue_heros1":$Player_1/Blue_heros/Cards, "red_heros1":$Player_1/Red_heros/Cards,"green_heros1":$Player_1/Green_heros/Cards,"blue_spells1":$Player_1/Blue_spells/Cards, "red_spells1":$Player_1/Red_spells/Cards,"green_spells1":$Player_1/Green_spells/Cards,"hand2":$Player_2/Hand_area/Cards,"blue_heros2":$Player_2/Blue_heros/Cards, "red_heros2":$Player_2/Red_heros/Cards,"green_heros2":$Player_2/Green_heros/Cards,"blue_spells2":$Player_2/Blue_spells/Cards, "red_spells2":$Player_2/Red_spells/Cards,"green_spells2":$Player_2/Green_spells/Cards,"null":null}
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
	if is_beta_busy:
		return
	if (event is InputEventMouseButton):
		if (event.is_action_pressed("mouse_leftbtn")):
			get_active_slot()
			if (activeItemSlot >= 0):
				if (area_dict[activeItemArea].is_item_selectable(activeItemSlot)):
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
func move_item():
	if (draggedItemSlot < 0):
		return
	if (activeItemSlot < 0):
		update_hand_cards()
		return
	if ((activeItemSlot == draggedItemSlot and activeItemArea == "hand1") or (activeItemArea in ["hand2","red_heros2","blue_heros2","green_heros2","red_spells2","blue_spells2","green_spells2"])):
		update_hand_cards()
		return
	if activeItemArea == "hand1":
		swap_hand_cards(draggedItemSlot, activeItemSlot)
	else:
		var temp_dict = {"red_heros1":"red","blue_heros1":"blue","green_heros1":"green","red_spells1":"red","blue_spells1":"blue","green_spells1":"green"}
		if activeItemArea in ["red_heros1","blue_heros1","green_heros1"]:
			play_hero(draggedItemSlot, temp_dict[activeItemArea], activeItemSlot)
		else:
			play_spell(draggedItemSlot, temp_dict[activeItemArea], activeItemSlot)

func _on_Objective_Panel_mouse_entered():
	print("1")
	if objective_numbers.size() > 0:
		$Board_Stuff/Card_Container/Selected_card.texture = $Board_Stuff/Objective_Panel_1/Objective_1.texture


func _on_HSlider_value_changed(value):
	$Board_Stuff/Background_music.volume_db = linear2db(value)

func _on_HSlider2_value_changed(value):
	sound_volume = linear2db(value)

func _on_Objective_Panel_2_mouse_entered():
	if objective_numbers.size() > 0:
		$Board_Stuff/Card_Container/Selected_card.texture = $Board_Stuff/Objective_Panel_2/Objective_2.texture


func _on_Objective_Panel_3_mouse_entered():
	print("3")
	if objective_numbers.size() > 0:
		$Board_Stuff/Card_Container/Selected_card.texture = $Board_Stuff/Objective_Panel_3/Objective_3.texture




func _on_Resa_pressed():
	rpc_id(Network.opponent,"win_game")


func _on_Button2_pressed():
	$Settings.visible = false

func _on_Set_Button_pressed():
	$Settings.visible = true
