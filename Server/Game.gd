extends Node

#--------------------------------------------Game object-------------------------------------------

var cards_samples = Network.cards_samples #Dictionary with a copy of each card
var objectives_samples = Network.objective_samples #Dictionary with a copy of each objective
var player1 = null
var player2 = null

var stats = {player1:{'blue':0, 'green':0, 'red':0}, player2:{'blue':0, 'green':0, 'red':0}}
var energy = {player1:{'heros':0, 'spells':0}, player2:{'heros':0, 'spells':0}}
var deck = []
var hand = {player1:[], player2:[]}
var board = {
	player1:{
		'heros':{
			'blue':{
				"left":null,
				"center":null,
				"right":null
			},
			'green':{
				"left":null,
				"center":null,
				"right":null
			},
			'red':{
				"left":null,
				"center":null,
				"right":null
			}
		},
		'spells':{
			'blue':{
				"left":null,
				"center":null,
				"right":null
			},
			'green':{
				"left":null,
				"center":null,
				"right":null
			},
			'red':{
				"left":null,
				"center":null,
				"right":null
			}
		}
	},
	player2:{
		'heros':{
			'blue':{
				"left":null,
				"center":null,
				"right":null
			},
			'green':{
				"left":null,
				"center":null,
				"right":null
			},
			'red':{
				"left":null,
				"center":null,
				"right":null
			}
		},
		'spells':{
			'blue':{
				"left":null,
				"center":null,
				"right":null
			},
			'green':{
				"left":null,
				"center":null,
				"right":null
			},
			'red':{
				"left":null,
				"center":null,
				"right":null
			}
		}
	}
}
var grave = {player1:[], player2:[]}
var objectives = {'blue': null, 'green': null, 'red': null}

var turn_player = player1

var effect_chain = [] #It will contain flags (true, false) that indicates if current effect has been neutralized (e.g. if attack has been cancelled)

var token = 0 #A unique token given to every card instance (increased by one every time one is created)

#------------------------------Signals-------------------------------
signal drawing_card(player, card, source, chain_id)
signal drawn_card(player, card, source)

signal discarding_card(player, card, source, chain_id)
signal discarded_card(player, card, source)

signal adding_player_stats(player, color, value, source, chain_id)
signal added_player_stats(player, color, value, source)

signal removing_player_stats(player, color, value, source, chain_id)
signal removed_player_stats(player, color, value, source)

signal adding_player_energy(player, type, value, source, chain_id)
signal added_player_energy(player, type, value, source)

signal removing_player_energy(player, type, value, source, chain_id)
signal removed_player_energy(player, type, value, source)

signal playing_hero(target_card, player, board_color, board_pos, source, chain_id)
signal played_hero(target_card, player, board_color, board_pos, source)

signal summoning_hero(target_card, player, board_color, board_pos, source, chain_id)
signal summoned_hero(target_card, player, board_color, board_pos, source)

signal playing_spell(target_card, player, board_color, board_pos, source, chain_id)
signal played_spell(target_card, player, board_color, board_pos, source)

signal summoning_spell(target_card, player, board_color, board_pos, source, chain_id)
signal summoned_spell(target_card, player, board_color, board_pos, source)

signal playing_event(target_card, player, board_color, board_pos, source, chain_id)
signal played_event(target_card, player, board_color, board_pos, source)

signal summoning_event(target_card, player, board_color, board_pos, source, chain_id)
signal summoned_event(target_card, player, board_color, board_pos, source)

signal healing_hero(target_card, amount, source, chain_id)
signal healed_hero(target_card, amount, source)

signal healing_spell(target_card, amount, source, chain_id)
signal healed_spell(target_card, amount, source)

signal damaging_hero(target_card, amount, source, chain_id)
signal damaged_hero(target_card, amount, source)

signal damaging_spell(target_card, amount, source, chain_id)
signal damaged_spell(target_card, amount, source)

signal killing_hero(target_card, source, chain_id)
signal killed_hero(target_card, source)

signal killing_spell(target_card, source, chain_id)
signal killed_spell(target_card, source)

signal hero_attacking(target_card, source, chain_id)
signal hero_attacked(target_card, source)

signal hero_teasing(target_card, source, chain_id)
signal hero_teased(target_card, source)

signal adding_condition(target_card, condition, source, metadata, chain_id)
signal added_condition(target_card, condition, source, metadata)

signal removing_condition(target_card, condition, source, chain_id)
signal removed_condition(target_card, condition, source)

signal completing_objective(target_objective, player, chain_id)
signal completed_objective(target_objective, player)

signal beginning_turn(player)
signal ending_turn(player)

#------------------------------Game core-----------------------#
func _init(ply1, ply2):
	randomize()
	player1 = ply1
	player2 = ply2
	
	#Create deck
	for card in cards_samples:
		for _i in range(card.quantity):
			deck.append(new_card(card.id, {"place":"deck"}))
	shuffle_deck()
	
	#Create objectives
	for color in ["blue", "green", "red"]:
		var obj_color_list = objectives_samples[color]
		var selected_obj = obj_color_list[randi() % obj_color_list.size()]
		var obj_instance = new_objective(selected_obj.id)
		objectives[color] = obj_instance
	
	#Make players draw
	for _i in range(5):
		make_draw(player1)
		make_draw(player2)

func begin_turn(player):
	turn_player = player
	emit_signal("beginning_turn", player)
	for type in ["heros", "spells"]:
		add_player_energy(player, type, 1)
	for _i in range(2):
		make_draw(player)

func end_turn(player):
	for board_color in ["blue", "green", "red"]:
		for board_pos in ["left", "center", "right"]:
			var attacking_hero = board[player]["heros"][board_color][board_pos]
			hero_attack(attacking_hero)
	emit_signal("ending_turn", player)
	begin_turn(opponent_letter(player))

func game_won_by(player):
	pass

#------------------------Utility methods----------------------#
func new_card(id, loc=null):    #Create a new istance of a card
	var nw_card = load("res://Cards_scripts/Card_%s.gd" % str(id)).new()
	add_child(nw_card)
	nw_card.set_game()
	nw_card.set_loc(loc)
	nw_card.token = token
	token +=1
	return(nw_card)

func new_objective(id):    #Create a new istance of a card
	var nw_obj = load("res://Objs_scripts/Objective_%s.gd" % str(id)).new()
	add_child(nw_obj)
	nw_obj.set_game()
	return(nw_obj)

func opponent_letter(letter): #Simply returns 'a' if input is 'b' and viceversa
	return({'a':'b', 'b':'a'}[letter])

func shuffle_deck():
	deck.shuffle()
#-------------------Network methods-------------------------#
func player_disconnected(player):
	pass
	
#------------------Signal-emitting methods----------------#
func make_draw(player, drawn_card=null, source=null):
	if len(hand[player]) >= 10: #Max hand size
		return
	if drawn_card == null:
		drawn_card = deck[0]
	#That's how we handle possible chain effects
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("drawing_card", player, drawn_card, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	deck.remove(drawn_card)
	hand[player].append(drawn_card)
	drawn_card.set_loc({"place": "hand", "player": player})
	emit_signal("drawn_card", player, drawn_card, source)

func make_discard(player, discarded_card=null, source=null):
	if len(hand[player]) == 0: #Max hand size
		return
		
	if discarded_card == null:
		discarded_card = hand[player][randi() % hand[player].size()]
	#That's how we handle possible chain effects
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("discarding_card", player, discarded_card, source, chain_id)
	if effect_chain.pop_front() == false:
		return
		
	hand[player].erase(discarded_card)
	discarded_card.set_loc({"place":"grave", "player":discarded_card.player})
	emit_signal("discarded_card", player, discarded_card, source)
	 
func add_player_stats(player, color, value, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("adding_player_stats", player, color, value, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	stats[player][color] += value
	emit_signal("added_player_stats", player, color, value, source)

func remove_player_stats(player, color, value, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("removing_player_stats", player, color, value, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	stats[player][color] -= value
	emit_signal("removed_player_stats", player, color, value, source)

func add_player_energy(player, type, value, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("adding_player_energy", player, type, value, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	energy[player][type] += value
	emit_signal("added_player_energy", player, type, value, source)

func remove_player_energy(player, type, value, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("removing_player_energy", player, type, value, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	energy[player][type] -= value
	emit_signal("removed_player_energy", player, type, value, source)

func play_hero(target_card, player, board_color, board_pos, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("playing_hero", target_card, player, board_color, board_pos, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	board[player]["heros"][board_color][board_pos] = target_card
	hand[player].erase(target_card)
	target_card.set_loc({"place":"board", "player":player, "board_type":"heros", "board_color":board_color, "board_pos":board_pos})
	remove_player_energy(player, "heros", target_card.cost)
	emit_signal("played_hero", target_card, player, board_color, board_pos, source)

func summon_hero(target_card, player, board_color, board_pos, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("summoning_hero", target_card, player, board_color, board_pos, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	board[player]["heros"][board_color][board_pos] = target_card
	target_card.set_loc({"place":"board", "player":player, "board_type":"heros", "board_color":board_color, "board_pos":board_pos})
	emit_signal("summoned_hero", target_card, player, board_color, board_pos, source)

func play_spell(target_card, player, board_color, board_pos, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("playing_spell", target_card, player, board_color, board_pos, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	board[player]["spells"][board_color][board_pos] = target_card
	hand[player].erase(target_card)
	target_card.set_loc({"place":"board", "player":player, "board_type":"spells", "board_color":board_color, "board_pos":board_pos})
	remove_player_energy(player, "spells", target_card.cost)
	emit_signal("played_spell", target_card, player, board_color, board_pos, source)

func summon_spell(target_card, player, board_color, board_pos, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("summoning_spell", target_card, player, board_color, board_pos, source, chain_id)
	if effect_chain.pop_front() == false:
		return 
	board[player]["spells"][board_color][board_pos] = target_card
	target_card.set_loc({"place":"board", "player":player, "board_type":"spells", "board_color":board_color, "board_pos":board_pos})
	emit_signal("summoned_hero", target_card, player, board_color, board_pos, source)

func play_event(target_card, player, board_color, board_pos, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("playing_event", target_card, player, board_color, board_pos, source, chain_id)
	if effect_chain.pop_front() == false:
		return
		
	board[player]["spells"][board_color][board_pos] = target_card
	hand[player].erase(target_card)
	target_card.set_loc({"place":"board", "player":player, "board_type":"spells", "board_color":board_color, "board_pos":board_pos})
	remove_player_energy(player, "spells", target_card.cost)
	emit_signal("played_event", target_card, player, board_color, board_pos, source)
	
	board[player]["spells"][board_color][board_pos] = null
	target_card.set_loc({"place":"grave", "player":player})
	grave[target_card.player].append(target_card)

func summon_event(target_card, player, board_color, board_pos, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("summoning_event", target_card, player, board_color, board_pos, source, chain_id)
	if effect_chain.pop_front() == false:
		return
		
	board[player]["spells"][board_color][board_pos] = target_card
	target_card.set_loc({"place":"board", "player":player, "board_type":"spells", "board_color":board_color, "board_pos":board_pos})
	emit_signal("summoned_event", target_card, player, board_color, board_pos, source)
	
	board[player]["spells"][board_color][board_pos] = null
	target_card.set_loc({"place":"grave", "player":player})
	grave[target_card.player].append(target_card)

func heal_hero(target_card, amount, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("healing_hero", target_card, amount, source, chain_id)
	if effect_chain.pop_front() == false:
		return
		
	target_card.health += amount
	emit_signal("healed_hero", target_card, amount, source)

func heal_spell(target_card, amount, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("healing_spell", target_card, amount, source, chain_id)
	if effect_chain.pop_front() == false:
		return
		
	target_card.health += amount
	emit_signal("healed_spell", target_card, amount, source)

func damage_hero(target_card, amount, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("damaging_hero", target_card, amount, source, chain_id)
	if effect_chain.pop_front() == false:
		return
		
	target_card.health -= amount
	emit_signal("damaged_hero", target_card, amount, source)
	
	if target_card.health <= 0:
		kill_hero(target_card, source)

func damage_spell(target_card, amount, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("damaging_spell", target_card, amount, source, chain_id)
	if effect_chain.pop_front() == false:
		return
		
	target_card.health -= amount
	emit_signal("damaged_spell", target_card, amount, source)
	
	if target_card.health <= 0:
		kill_spell(target_card, source)

func kill_hero(target_card, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("killing_hero", target_card, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	
	board[target_card.player]["heros"][target_card.board_color][target_card.board_pos] = null
	target_card.set_loc({"place":"grave", "player":target_card.player})
	grave[target_card.player].append(target_card)
	emit_signal("killed_hero", target_card, source)

func kill_spell(target_card, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("killing_spell", target_card, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	
	board[target_card.player]["heros"][target_card.board_color][target_card.board_pos] = null
	target_card.set_loc({"place":"grave", "player":target_card.player})
	grave[target_card.player].append(target_card)
	emit_signal("killed_spell", target_card, source)

func hero_attack(target_card, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("hero_attacking", target_card, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	var enemy_hero = board[opponent_letter(target_card.player)]["heros"][target_card.board_color][target_card.board] 
	if enemy_hero == null:
		hero_tease(target_card)
	else:
		damage_hero(enemy_hero, target_card.attack, target_card)
	emit_signal("hero_attacked", target_card, source)

func hero_tease(target_card, source=null):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("hero_teasing", target_card, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	target_card.tease()
	emit_signal("hero_teased", target_card, source)

func add_condition(target_card, condition, source=null): #e.g. we add {"name": "frozen","turns_left":4, "perma":false} | source=null means added by the game itself
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("adding_condition", target_card, condition, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	
	target_card.conditions.append(condition)
	emit_signal("added_condition", target_card, condition, source)

func remove_condition(target_card, condition, source=null): #source=null means added by the game itself
	if not condition in target_card.conditions:
		return
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("removing_condition", target_card, condition, source, chain_id)
	if effect_chain.pop_front() == false:
		return
	target_card.conditions.erase(condition)
	emit_signal("removed_condition", target_card, condition, source)

func complete_objective(target_objective, player):
	var chain_id = len(effect_chain)
	effect_chain.append(true)
	emit_signal("completing_objective", target_objective, player, chain_id)
	if effect_chain.pop_front() == false:
		return
		
	target_objective.completed_by = player
	target_objective.disconnect_all_signals()
	
	#We check if they player has won (if he completed another objective)
	var counter = 0
	for color in objectives:
		var obj = objectives[color]
		if obj.completed_by == player:
			counter += 1
	if counter > 1:
		game_won_by(player)
		return
		
	emit_signal("completed_objective", target_objective, player)
