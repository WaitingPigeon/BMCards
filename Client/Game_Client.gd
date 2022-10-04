extends Node


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



