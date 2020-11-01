extends Node


const DEFAULT_WAIT_TIME = 0.5

var sound_volume = 0.1

var this_player = ''
#--------------------------------Variabili condivise--------------------------------------------
remotesync var alpha_blue_points = 0
remotesync var alpha_red_points = 0
remotesync var alpha_green_points = 0
remotesync var beta_blue_points = 0
remotesync var beta_red_points = 0
remotesync var beta_green_points = 0
remotesync var alpha_hand_cards = [0,0,0,0,0,0,0,0,0,0]
remotesync var beta_hand_cards = [0,0,0,0,0,0,0,0,0,0]
remotesync var alpha_blue_heros_cards = [0,0,0]
remotesync var alpha_blue_heros_life = [0,0,0]
remotesync var alpha_red_heros_cards = [0,0,0]
remotesync var alpha_red_heros_life = [0,0,0]
remotesync var alpha_green_heros_cards = [0,0,0]
remotesync var alpha_green_heros_life = [0,0,0]
remotesync var beta_blue_heros_cards = [0,0,0]
remotesync var beta_blue_heros_life = [0,0,0]
remotesync var beta_red_heros_cards = [0,0,0]
remotesync var beta_red_heros_life = [0,0,0]
remotesync var beta_green_heros_cards = [0,0,0]
remotesync var beta_green_heros_life = [0,0,0]
remotesync var alpha_blue_spells_cards = [0,0,0]
remotesync var alpha_blue_spells_life = [0,0,0]
remotesync var alpha_red_spells_cards = [0,0,0]
remotesync var alpha_red_spells_life = [0,0,0]
remotesync var alpha_green_spells_cards = [0,0,0]
remotesync var alpha_green_spells_life = [0,0,0]
remotesync var beta_blue_spells_cards = [0,0,0]
remotesync var beta_blue_spells_life = [0,0,0]
remotesync var beta_red_spells_cards = [0,0,0]
remotesync var beta_red_spells_life = [0,0,0]
remotesync var beta_green_spells_cards = [0,0,0]
remotesync var beta_green_spells_life = [0,0,0]

var mana_left = 1
var maximum_mana = 1
var kills_this_turn = 0
var turns_passed = 1

remotesync var unique_id = 1
remotesync var active_switches = []
remotesync var cards_deck = []
remotesync var objective_numbers = {"blue" : null, "green": null, "red" : null}
remotesync var completed_objectives = {}
remotesync var is_beta_turn = false
remotesync var is_beta_busy = false
remotesync var damage_hero_confirmation_flag = true
remotesync var heal_player_confirmation_flag = true
remotesync var kill_confirmation_flag = true
remotesync var attacking_confirmation_flag = true
remotesync var polenta_flag = true
remotesync var attacking_value = 0
remote var cards_effects = {"frozen_hero":[], "frozen_pos":[], "charge":[]}

func meta_rset_id(id, variab, value):
	set(variab, value)
	rset_id(id, variab, value)
#--------------------------------Funzioni di interrogazione fondamentali----------------------------
func get_beta_points():
	return {"blue":beta_blue_points,"red":beta_red_points,"green":beta_green_points}
func get_alpha_points():
	return {"blue":alpha_blue_points,"red":alpha_red_points,"green":alpha_green_points}
func get_beta_hand_cards():
	return beta_hand_cards
func get_alpha_hand_cards():
	return alpha_hand_cards
func get_beta_heros_cards():
	return {"blue":beta_blue_heros_cards,"red":beta_red_heros_cards,"green":beta_green_heros_cards}
func get_beta_spells_cards():
	return {"blue":beta_blue_spells_cards,"red":beta_red_spells_cards,"green":beta_green_spells_cards}
func get_alpha_heros_cards():
	return {"blue":alpha_blue_heros_cards,"red":alpha_red_heros_cards,"green":alpha_green_heros_cards}
func get_alpha_spells_cards():
	return {"blue":alpha_blue_spells_cards,"red":alpha_red_spells_cards,"green":alpha_green_spells_cards}
func get_beta_heros_life():
	return {"blue":beta_blue_heros_life,"red":beta_red_heros_life,"green":beta_green_heros_life}
func get_beta_spells_life():
	return {"blue":beta_blue_spells_life,"red":beta_red_spells_life,"green":beta_green_spells_life}
func get_alpha_heros_life():
	return {"blue":alpha_blue_heros_life,"red":alpha_red_heros_life,"green":alpha_green_heros_life}
func get_alpha_spells_life():
	return {"blue":alpha_blue_spells_life,"red":alpha_red_spells_life,"green":alpha_green_spells_life}
func is_beta_turn():
	return is_beta_turn
func is_alpha_turn():
	return !is_beta_turn

#Funzioni di modifica fondamentali
func change_beta_points(color, operation, value):
	if operation == "+":
		if color == "blue":
			meta_rset_id(Network.opponent, "beta_blue_points", beta_blue_points + value)
		elif color == "red":
			meta_rset_id(Network.opponent, "beta_red_points", beta_red_points + value)
			
		elif color == "green":
			meta_rset_id(Network.opponent, "beta_green_points", beta_green_points + value)
	elif operation == "-":
		
		if color == "blue":
			meta_rset_id(Network.opponent, "beta_blue_points", beta_blue_points - value)
			
		elif color == "red":
			meta_rset_id(Network.opponent, "beta_red_points", beta_red_points - value)
			
		elif color == "green":
			meta_rset_id(Network.opponent, "beta_green_points", beta_green_points - value)
			
	elif operation == "*":
		
		if color == "blue":
			meta_rset_id(Network.opponent, "beta_blue_points", beta_blue_points * value)
			
		elif color == "red":
			meta_rset_id(Network.opponent, "beta_red_points", beta_red_points * value)
			
		elif color == "green":
			meta_rset_id(Network.opponent, "beta_green_points", beta_green_points * value)
			
	elif operation == "/":
		
		if color == "blue":
			meta_rset_id(Network.opponent, "beta_blue_points", round(beta_blue_points / value))
			
		elif color == "red":
			meta_rset_id(Network.opponent, "beta_red_points", round(beta_red_points / value))
			
		elif color == "green":
			meta_rset_id(Network.opponent, "beta_green_points", round(beta_green_points / value))
			
	elif operation == "=":
		
		if color == "blue":
			meta_rset_id(Network.opponent, "beta_blue_points", value)
			
		elif color == "red":
			meta_rset_id(Network.opponent, "beta_red_points", value)
			
		elif color == "green":
			meta_rset_id(Network.opponent, "beta_green_points", value)
func change_alpha_points(color, operation, value):
	if operation == "+":
		
		if color == "blue":
			meta_rset_id(Network.opponent, "alpha_blue_points", alpha_blue_points + value)
			
		elif color == "red":
			meta_rset_id(Network.opponent, "alpha_red_points", alpha_red_points + value)
			
		elif color == "green":
			meta_rset_id(Network.opponent, "alpha_green_points", alpha_green_points + value)
			
	elif operation == "-":
		
		if color == "blue":
			meta_rset_id(Network.opponent, "alpha_blue_points", alpha_blue_points - value)
			
		elif color == "red":
			meta_rset_id(Network.opponent, "alpha_red_points", alpha_red_points - value)
			
		elif color == "green":
			meta_rset_id(Network.opponent, "alpha_green_points", alpha_green_points - value)
			
	elif operation == "*":
		
		if color == "blue":
			meta_rset_id(Network.opponent, "alpha_blue_points", alpha_blue_points * value)
			
		elif color == "red":
			meta_rset_id(Network.opponent, "alpha_red_points", alpha_red_points * value)
			
		elif color == "green":
			meta_rset_id(Network.opponent, "alpha_green_points", alpha_green_points * value)
			
	elif operation == "/":
		
		if color == "blue":
			meta_rset_id(Network.opponent, "alpha_blue_points", round(alpha_blue_points / value))
			
		elif color == "red":
			meta_rset_id(Network.opponent, "alpha_red_points", round(alpha_red_points / value))
			
		elif color == "green":
			meta_rset_id(Network.opponent, "alpha_green_points", round(alpha_green_points / value))
			
	elif operation == "=":
		
		if color == "blue":
			meta_rset_id(Network.opponent, "alpha_blue_points", value)
			
		elif color == "red":
			meta_rset_id(Network.opponent, "alpha_red_points", value)
			
		elif color == "green":
			meta_rset_id(Network.opponent, "alpha_green_points", value)
func change_beta_hand_card(index,id):
	var temp_hand = beta_hand_cards
	temp_hand[index] = id
	meta_rset_id(Network.opponent, "beta_hand_cards", temp_hand)
func change_alpha_hand_card(index,id):
	var temp_hand = alpha_hand_cards
	temp_hand[index] = id
	meta_rset_id(Network.opponent, "alpha_hand_cards", temp_hand)
func change_beta_heros_card(color, index, id):
	
	if color == "blue":
		var temp_heros = beta_blue_heros_cards
		temp_heros[index] = id
		meta_rset_id(Network.opponent, "beta_blue_heros_cards", temp_heros)
		
	elif color == "red":
		var temp_heros = beta_red_heros_cards
		temp_heros[index] = id
		meta_rset_id(Network.opponent, "beta_red_heros_cards", temp_heros)
		
	elif color == "green":
		var temp_heros = beta_green_heros_cards
		temp_heros[index] = id
		meta_rset_id(Network.opponent, "beta_green_heros_cards", temp_heros)
func change_alpha_heros_card(color, index, id):
	
	if color == "blue":
		var temp_heros = alpha_blue_heros_cards
		temp_heros[index] = id
		meta_rset_id(Network.opponent, "alpha_blue_heros_cards", temp_heros)
		
	elif color == "red":
		var temp_heros = alpha_red_heros_cards
		temp_heros[index] = id
		meta_rset_id(Network.opponent, "alpha_red_heros_cards", temp_heros)
		
	elif color == "green":
		var temp_heros = alpha_green_heros_cards
		temp_heros[index] = id
		meta_rset_id(Network.opponent, "alpha_green_heros_cards", temp_heros)
func change_beta_heros_life(color, index, operation, value):
	var temp_life = {"blue":beta_blue_heros_life,"red":beta_red_heros_life,"green":beta_green_heros_life}[color]
	if operation == "+":
		
		if color == "blue":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "beta_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "beta_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "beta_green_heros_life", temp_life)
			
	elif operation == "-":
		
		if color == "blue":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "beta_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "beta_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "beta_green_heros_life", temp_life)
			
	elif operation == "*":
		
		if color == "blue":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "beta_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "beta_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "beta_green_heros_life", temp_life)
			
	elif operation == "/":
		
		if color == "blue":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "beta_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "beta_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "beta_green_heros_life", temp_life)
			
	elif operation == "=":
		
		if color == "blue":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "beta_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "beta_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "beta_green_heros_life", temp_life)
func change_alpha_heros_life(color, index, operation, value):
	var temp_life = {"blue":alpha_blue_heros_life,"red":alpha_red_heros_life,"green":alpha_green_heros_life}[color]
	if operation == "+":
		
		if color == "blue":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "alpha_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "alpha_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "alpha_green_heros_life", temp_life)
			
	elif operation == "-":
		
		if color == "blue":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "alpha_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "alpha_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "alpha_green_heros_life", temp_life)
			
	elif operation == "*":
		
		if color == "blue":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "alpha_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "alpha_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "alpha_green_heros_life", temp_life)
			
	elif operation == "/":
		
		if color == "blue":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "alpha_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "alpha_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "alpha_green_heros_life", temp_life)
			
	elif operation == "=":
		
		if color == "blue":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "alpha_blue_heros_life", temp_life)
			
		elif color == "red":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "alpha_red_heros_life", temp_life)
			
		elif color == "green":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "alpha_green_heros_life", temp_life)
func change_beta_spells_card(color, index, id):
	
	if color == "blue":
		var temp_spells = beta_blue_spells_cards
		temp_spells[index] = id
		meta_rset_id(Network.opponent, "beta_blue_spells_cards", temp_spells)
		
	elif color == "red":
		var temp_spells = beta_red_spells_cards
		temp_spells[index] = id
		meta_rset_id(Network.opponent, "beta_red_spells_cards", temp_spells)
		
	elif color == "green":
		var temp_spells = beta_green_spells_cards
		temp_spells[index] = id
		meta_rset_id(Network.opponent, "beta_green_spells_cards", temp_spells)
func change_alpha_spells_card(color, index, id):
	
	if color == "blue":
		var temp_spells = alpha_blue_spells_cards
		temp_spells[index] = id
		meta_rset_id(Network.opponent, "alpha_blue_spells_cards", temp_spells)
		
	elif color == "red":
		var temp_spells = alpha_red_spells_cards
		temp_spells[index] = id
		meta_rset_id(Network.opponent, "alpha_red_spells_cards", temp_spells)
		
	elif color == "green":
		var temp_spells = alpha_green_spells_cards
		temp_spells[index] = id
		meta_rset_id(Network.opponent, "alpha_green_spells_cards", temp_spells)
func change_beta_spells_life(color, index, operation, value):
	var temp_life = {"blue":beta_blue_spells_life,"red":beta_red_spells_life,"green":beta_green_spells_life}[color]
	if operation == "+":
		
		if color == "blue":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "beta_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "beta_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "beta_green_spells_life", temp_life)
			
	elif operation == "-":
		
		if color == "blue":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "beta_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "beta_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "beta_green_spells_life", temp_life)
			
	elif operation == "*":
		
		if color == "blue":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "beta_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "beta_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "beta_green_spells_life", temp_life)
			
	elif operation == "/":
		
		if color == "blue":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "beta_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "beta_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "beta_green_spells_life", temp_life)
			
	elif operation == "=":
		
		if color == "blue":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "beta_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "beta_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "beta_green_spells_life", temp_life)
func change_alpha_spells_life(color, index, operation, value):
	var temp_life = {"blue":alpha_blue_spells_life,"red":alpha_red_spells_life,"green":alpha_green_spells_life}[color]
	if operation == "+":
		
		if color == "blue":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "alpha_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "alpha_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] += value
			meta_rset_id(Network.opponent, "alpha_green_spells_life", temp_life)
			
	elif operation == "-":
		
		if color == "blue":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "alpha_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "alpha_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] -= value
			meta_rset_id(Network.opponent, "alpha_green_spells_life", temp_life)
			
	elif operation == "*":
		
		if color == "blue":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "alpha_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "alpha_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] = value * temp_life[index]
			meta_rset_id(Network.opponent, "alpha_green_spells_life", temp_life)
			
	elif operation == "/":
		
		if color == "blue":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "alpha_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "alpha_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] = round(temp_life[index] / value)
			meta_rset_id(Network.opponent, "alpha_green_spells_life", temp_life)
			
	elif operation == "=":
		
		if color == "blue":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "alpha_blue_spells_life", temp_life)
			
		elif color == "red":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "alpha_red_spells_life", temp_life)
			
		elif color == "green":
			temp_life[index] = value
			meta_rset_id(Network.opponent, "alpha_green_spells_life", temp_life)
func set_beta_turn():
	meta_rset_id(Network.opponent, "is_beta_turn", true)
func set_alpha_turn():
	meta_rset_id(Network.opponent, "is_beta_turn", false)

func get_player1_points():
	if Network.letter == 'a':
		return(get_alpha_points())
	elif Network.letter == 'b':
		return(get_beta_points())
	else:
		return
func get_player2_points():
	if Network.letter == 'a':
		return(get_beta_points())
	elif Network.letter == 'b':
		return(get_alpha_points())
	else:
		return
func get_player1_hand_cards():
	if Network.letter == 'a':
		return(get_alpha_hand_cards())
	elif Network.letter == 'b':
		return(get_beta_hand_cards())
	else:
		return
func get_player2_hand_cards():
	if Network.letter == 'a':
		return(get_beta_hand_cards())
	elif Network.letter == 'b':
		return(get_alpha_hand_cards())
	else:
		return
func get_player1_heros_cards():
	if Network.letter == 'a':
		return(get_alpha_heros_cards())
	elif Network.letter == 'b':
		return(get_beta_heros_cards())
	else:
		return
func get_player2_heros_cards():
	if Network.letter == 'a':
		return(get_beta_heros_cards())
	elif Network.letter == 'b':
		return(get_alpha_heros_cards())
	else:
		return
func get_player1_heros_life():
	if Network.letter == 'a':
		return(get_alpha_heros_life())
	elif Network.letter == 'b':
		return(get_beta_heros_life())
	else:
		return
func get_player2_heros_life():
	if Network.letter == 'a':
		return(get_beta_heros_life())
	elif Network.letter == 'b':
		return(get_alpha_heros_life())
	else:
		return
func get_player1_spells_cards():
	if Network.letter == 'a':
		return(get_alpha_spells_cards())
	elif Network.letter == 'b':
		return(get_beta_spells_cards())
	else:
		return
func get_player2_spells_cards():
	if Network.letter == 'a':
		return(get_beta_spells_cards())
	elif Network.letter == 'b':
		return(get_alpha_spells_cards())
	else:
		return
func get_player1_spells_life():
	if Network.letter == 'a':
		return(get_alpha_spells_life())
	elif Network.letter == 'b':
		return(get_beta_spells_life())
	else:
		return
func get_player2_spells_life():
	if Network.letter == 'a':
		return(get_beta_spells_life())
	elif Network.letter == 'b':
		return(get_alpha_spells_life())
	else:
		return
func get_player1_cards():
	return({"heros":get_player1_heros_cards(), "spells":get_player1_spells_cards()})
func get_player2_cards():
	return({"heros":get_player2_heros_cards(), "spells":get_player2_spells_cards()})
func is_player1_turn():
	if Network.letter == 'a':
		return(is_alpha_turn())
	elif Network.letter == 'b':
		return(is_beta_turn())
	else:
		return
func is_player2_turn():
	if Network.letter == 'a':
		return(is_beta_turn())
	elif Network.letter == 'b':
		return(is_alpha_turn())
	else:
		return
func get_unique_id():
	yield(get_tree(), "idle_frame")
	var switch = unique_id
	meta_rset_id(Network.opponent, "unique_id", unique_id + 1)
	return(switch)
func get_player1_obj():
	var list = []
	for color in completed_objectives:
		if completed_objectives[color] == Network.letter:
			list.append(color)
	return (list)
func get_player2_obj():
	var list = []
	for color in completed_objectives:
		if not completed_objectives[color] == Network.letter:
			list.append(color)
	return (list)


#Funzioni di modifica fondamentali
func change_player1_points(color, operation, value):
	if Network.letter == 'a':
		change_alpha_points(color, operation, value)
	elif Network.letter == 'b':
		change_beta_points(color, operation, value)
	else:
		return
func change_player2_points(color, operation, value):
	if Network.letter == 'a':
		change_beta_points(color, operation, value)
	elif Network.letter == 'b':
		change_alpha_points(color, operation, value)
	else:
		return
func change_player1_hand_card(index,id):
	if Network.letter == 'a':
		change_alpha_hand_card(index,id)
	elif Network.letter == 'b':
		change_beta_hand_card(index,id)
	else:
		return
func change_player2_hand_card(index,id):
	if Network.letter == 'a':
		change_beta_hand_card(index,id)
	elif Network.letter == 'b':
		change_alpha_hand_card(index,id)
	else:
		return
func change_player_1_heros_card(color, index, id):
	if Network.letter == 'a':
		change_alpha_heros_card(color, index, id)
	elif Network.letter == 'b':
		change_beta_heros_card(color, index, id)
	else:
		return
func change_player_2_heros_card(color, index, id):
	if Network.letter == 'a':
		change_beta_heros_card(color, index, id)
	elif Network.letter == 'b':
		change_alpha_heros_card(color, index, id)
	else:
		return
func change_player_1_heros_life(color, index, operation, value):
	if Network.letter == 'a':
		change_alpha_heros_life(color, index, operation, value)
	elif Network.letter == 'b':
		change_beta_heros_life(color, index, operation, value)
	else:
		return
func change_player_2_heros_life(color, index, operation, value):
	if Network.letter == 'a':
		change_beta_heros_life(color, index, operation, value)
	elif Network.letter == 'b':
		change_alpha_heros_life(color, index, operation, value)
	else:
		return
func change_player_1_spells_card(color, index, id):
	if Network.letter == 'a':
		change_alpha_spells_card(color, index, id)
	elif Network.letter == 'b':
		change_beta_spells_card(color, index, id)
	else:
		return
func change_player_2_spells_card(color, index, id):
	if Network.letter == 'a':
		change_beta_spells_card(color, index, id)
	elif Network.letter == 'b':
		change_alpha_spells_card(color, index, id)
	else:
		return
func change_player_1_spells_life(color, index, operation, value):
	if Network.letter == 'a':
		change_alpha_spells_life(color, index, operation, value)
	elif Network.letter == 'b':
		change_beta_spells_life(color, index, operation, value)
	else:
		return
func change_player_2_spells_life(color, index, operation, value):
	if Network.letter == 'a':
		change_beta_spells_life(color, index, operation, value)
	elif Network.letter == 'b':
		change_alpha_spells_life(color, index, operation, value)
	else:
		return
func set_player1_turn():
	if Network.letter == 'a':
		set_alpha_turn()
	elif Network.letter == 'b':
		set_beta_turn()
	else:
		return
func set_player2_turn():
	if Network.letter == 'a':
		set_beta_turn()
	elif Network.letter == 'b':
		set_alpha_turn()
	else:
		return
func add_switch(id):
	yield(get_tree(), "idle_frame")
	if id in active_switches:
		return
	active_switches.append(id)
	meta_rset_id(Network.opponent, "active_switches", active_switches)
func remove_switch(id):
	yield(get_tree(), "idle_frame")
	if !(id in active_switches):
		return
	active_switches.erase(id)
	meta_rset_id(Network.opponent, "active_switches", active_switches)
remote func add_effect(player, effect, string):
	yield(get_tree(), "idle_frame")
	if player == 2:
		string[0] = {"1":"2", "2":"1"}[string[0]]
		rpc_id(Network.opponent, "add_effect", 1, effect, string)
	else:
		if !(effect in cards_effects):
			cards_effects[effect] = []
		if not string in cards_effects[effect]:
			cards_effects[effect].append(string)
remote func remove_effect(player, effect, string):
	yield(get_tree(), "idle_frame")
	if player == 2:
		string[0] = {"1":"2", "2":"1"}[string[0]]
		rpc_id(Network.opponent, "remove_effect", 1, effect, string)
	else:
		if !effect in cards_effects:
			return
		if string in cards_effects[effect]:
			cards_effects[effect].erase(string)
remote func remove_all_effect(player, effect):
	yield(get_tree(), "idle_frame")
	if player == 2:
		rpc_id(Network.opponent, "remove_effect", 1, effect)
	else:
		cards_effects[effect].clear()
func add_objective(color):
	completed_objectives[color] = Network.letter
	meta_rset_id(Network.opponent, "completed_objectives", completed_objectives)

#Funzioni di update 
remotesync func update_points():
	$Player_1/Points/Blue_points.text = str(get_player1_points()["blue"])
	$Player_1/Points/Green_points.text = str(get_player1_points()["green"])
	$Player_1/Points/Red_points.text = str(get_player1_points()["red"])
	
	$Player_2/Points/Blue_points.text = str(get_player2_points()["blue"])
	$Player_2/Points/Green_points.text = str(get_player2_points()["green"])
	$Player_2/Points/Red_points.text = str(get_player2_points()["red"])
remotesync func update_hand_cards():
	for i in range(10):
		$Player_1/Hand_area/Cards.set_item_icon(i, load_card_img(get_player1_hand_cards()[i]))
		if get_player1_hand_cards()[i] == 0:
			$Player_1/Hand_area/Cards.set_item_selectable(i, false)
		else:
			$Player_1/Hand_area/Cards.set_item_selectable(i, true)
	var temp_p2 = get_player2_hand_cards().duplicate(true)
	while 0 in temp_p2:
		temp_p2.erase(0)
	var p2_size = len(temp_p2)
	for j in range(p2_size):
		$Player_2/Hand_area/Cards.set_item_icon(j, load_card_img(-1))
		$Player_2/Hand_area/Cards.set_item_selectable(j, false)
	for k in range(p2_size, 10):
		$Player_2/Hand_area/Cards.set_item_icon(k, load_card_img(0))
		$Player_2/Hand_area/Cards.set_item_selectable(k, false)
remotesync func update_heros_cards():
	for i in range(3):
		$Player_1/Blue_heros/Cards.set_item_icon(i, load_card_img(get_player1_heros_cards()["blue"][i]))
		if get_player1_heros_cards()["blue"][i] == 0:
			$Player_1/Blue_heros/Cards.set_item_selectable(i, false)
		else:
			$Player_1/Blue_heros/Cards.set_item_selectable(i, true)

		$Player_1/Red_heros/Cards.set_item_icon(i, load_card_img(get_player1_heros_cards()["red"][i]))
		if get_player1_heros_cards()["red"][i] == 0:
			$Player_1/Red_heros/Cards.set_item_selectable(i, false)
		else:
			$Player_1/Red_heros/Cards.set_item_selectable(i, true)
		
		$Player_1/Green_heros/Cards.set_item_icon(i, load_card_img(get_player1_heros_cards()["green"][i]))
		if get_player1_heros_cards()["green"][i] == 0:
			$Player_1/Green_heros/Cards.set_item_selectable(i, false)
		else:
			$Player_1/Green_heros/Cards.set_item_selectable(i, true)

		$Player_2/Blue_heros/Cards.set_item_icon(i, load_card_img(get_player2_heros_cards()["blue"][i]))
		if get_player2_heros_cards()["blue"][i] == 0:
			$Player_2/Blue_heros/Cards.set_item_selectable(i, false)
		else:
			$Player_2/Blue_heros/Cards.set_item_selectable(i, true)

		$Player_2/Red_heros/Cards.set_item_icon(i, load_card_img(get_player2_heros_cards()["red"][i]))
		if get_player2_heros_cards()["red"][i] == 0:
			$Player_2/Red_heros/Cards.set_item_selectable(i, false)
		else:
			$Player_2/Red_heros/Cards.set_item_selectable(i, true)
		
		$Player_2/Green_heros/Cards.set_item_icon(i, load_card_img(get_player2_heros_cards()["green"][i]))
		if get_player2_heros_cards()["green"][i] == 0:
			$Player_2/Green_heros/Cards.set_item_selectable(i, false)
		else:
			$Player_2/Green_heros/Cards.set_item_selectable(i, true)
remotesync func update_heros_life():
	$Player_1/Blue_heros/Life_left.text = str(get_player1_heros_life()["blue"][0])
	$Player_1/Blue_heros/Life_center.text = str(get_player1_heros_life()["blue"][1])
	$Player_1/Blue_heros/Life_right.text = str(get_player1_heros_life()["blue"][2])
	
	$Player_1/Green_heros/Life_left.text = str(get_player1_heros_life()["green"][0])
	$Player_1/Green_heros/Life_center.text = str(get_player1_heros_life()["green"][1])
	$Player_1/Green_heros/Life_right.text = str(get_player1_heros_life()["green"][2])
	
	$Player_1/Red_heros/Life_left.text = str(get_player1_heros_life()["red"][0])
	$Player_1/Red_heros/Life_center.text = str(get_player1_heros_life()["red"][1])
	$Player_1/Red_heros/Life_right.text = str(get_player1_heros_life()["red"][2])
	
	$Player_2/Blue_heros/Life_left.text = str(get_player2_heros_life()["blue"][0])
	$Player_2/Blue_heros/Life_center.text = str(get_player2_heros_life()["blue"][1])
	$Player_2/Blue_heros/Life_right.text = str(get_player2_heros_life()["blue"][2])
	
	$Player_2/Green_heros/Life_left.text = str(get_player2_heros_life()["green"][0])
	$Player_2/Green_heros/Life_center.text = str(get_player2_heros_life()["green"][1])
	$Player_2/Green_heros/Life_right.text = str(get_player2_heros_life()["green"][2])
	
	$Player_2/Red_heros/Life_left.text = str(get_player2_heros_life()["red"][0])
	$Player_2/Red_heros/Life_center.text = str(get_player2_heros_life()["red"][1])
	$Player_2/Red_heros/Life_right.text = str(get_player2_heros_life()["red"][2])
remotesync func update_spells_cards():
	for i in range(3):
		$Player_1/Blue_spells/Cards.set_item_icon(i, load_card_img(get_player1_spells_cards()["blue"][i]))
		if get_player1_spells_cards()["blue"][i] == 0:
			$Player_1/Blue_spells/Cards.set_item_selectable(i, false)
		else:
			$Player_1/Blue_spells/Cards.set_item_selectable(i, true)

		$Player_1/Red_spells/Cards.set_item_icon(i, load_card_img(get_player1_spells_cards()["red"][i]))
		if get_player1_spells_cards()["red"][i] == 0:
			$Player_1/Red_spells/Cards.set_item_selectable(i, false)
		else:
			$Player_1/Red_spells/Cards.set_item_selectable(i, true)
		
		$Player_1/Green_spells/Cards.set_item_icon(i, load_card_img(get_player1_spells_cards()["green"][i]))
		if get_player1_spells_cards()["green"][i] == 0:
			$Player_1/Green_spells/Cards.set_item_selectable(i, false)
		else:
			$Player_1/Green_spells/Cards.set_item_selectable(i, true)

		$Player_2/Blue_spells/Cards.set_item_icon(i, load_card_img(get_player2_spells_cards()["blue"][i]))
		if get_player2_spells_cards()["blue"][i] == 0:
			$Player_2/Blue_spells/Cards.set_item_selectable(i, false)
		else:
			$Player_2/Blue_spells/Cards.set_item_selectable(i, true)

		$Player_2/Red_spells/Cards.set_item_icon(i, load_card_img(get_player2_spells_cards()["red"][i]))
		if get_player2_spells_cards()["red"][i] == 0:
			$Player_2/Red_spells/Cards.set_item_selectable(i, false)
		else:
			$Player_2/Red_spells/Cards.set_item_selectable(i, true)
		
		$Player_2/Green_spells/Cards.set_item_icon(i, load_card_img(get_player2_spells_cards()["green"][i]))
		if get_player2_spells_cards()["green"][i] == 0:
			$Player_2/Green_spells/Cards.set_item_selectable(i, false)
		else:
			$Player_2/Green_spells/Cards.set_item_selectable(i, true)
remotesync func update_spells_life():
	$Player_1/Blue_spells/Life_left.text = str(get_player1_spells_life()["blue"][0])
	$Player_1/Blue_spells/Life_center.text = str(get_player1_spells_life()["blue"][1])
	$Player_1/Blue_spells/Life_right.text = str(get_player1_spells_life()["blue"][2])
	
	$Player_1/Green_spells/Life_left.text = str(get_player1_spells_life()["green"][0])
	$Player_1/Green_spells/Life_center.text = str(get_player1_spells_life()["green"][1])
	$Player_1/Green_spells/Life_right.text = str(get_player1_spells_life()["green"][2])
	
	$Player_1/Red_spells/Life_left.text = str(get_player1_spells_life()["red"][0])
	$Player_1/Red_spells/Life_center.text = str(get_player1_spells_life()["red"][1])
	$Player_1/Red_spells/Life_right.text = str(get_player1_spells_life()["red"][2])
	
	$Player_2/Blue_spells/Life_left.text = str(get_player2_spells_life()["blue"][0])
	$Player_2/Blue_spells/Life_center.text = str(get_player2_spells_life()["blue"][1])
	$Player_2/Blue_spells/Life_right.text = str(get_player2_spells_life()["blue"][2])
	
	$Player_2/Green_spells/Life_left.text = str(get_player2_spells_life()["green"][0])
	$Player_2/Green_spells/Life_center.text = str(get_player2_spells_life()["green"][1])
	$Player_2/Green_spells/Life_right.text = str(get_player2_spells_life()["green"][2])
	
	$Player_2/Red_spells/Life_left.text = str(get_player2_spells_life()["red"][0])
	$Player_2/Red_spells/Life_center.text = str(get_player2_spells_life()["red"][1])
	$Player_2/Red_spells/Life_right.text = str(get_player2_spells_life()["red"][2])
remotesync func update_deck():
	$Board_Stuff/Cards_left.text = str(len(cards_deck))
func update_mana():
	$Board_Stuff/Mana_left.text = str(mana_left)

#Funzioni di meccanica gioco 
func _ready():
#warning-ignore:unused_variable
	history_create()
	var my_name = ""
	var opp_name = ""
	if Network.username.length() <= 5:
		my_name = Network.username
	else:
		my_name = Network.username.left(5) + "."
	if Network.opponent_user.length() <= 5:
		opp_name = Network.opponent_user
	else:
		opp_name = Network.opponent_user.left(5) + "."
	$Player_1/Hand_area/Label.text = my_name
	$Player_2/Hand_area/Label.text = opp_name
	$Settings/CheckBox.pressed = OS.window_fullscreen
	Network.connect("disconnected_opponent", self, "win_game")
	randomize()
	$Board_Stuff/Background_music.volume_db = linear2db(0.1)
	$Player_1/Hand_area/Cards.clear()
	$Player_2/Hand_area/Cards.clear()
	for i in range(10):
		$Player_1/Hand_area/Cards.add_icon_item(load_card_img(0))
		$Player_2/Hand_area/Cards.add_icon_item(load_card_img(0))
#warning-ignore:unused_variable
	$Player_1/Blue_heros/Cards.clear()
	$Player_1/Red_heros/Cards.clear()
	$Player_1/Green_heros/Cards.clear()
	$Player_2/Blue_heros/Cards.clear()
	$Player_2/Red_heros/Cards.clear()
	$Player_2/Green_heros/Cards.clear()
	$Player_1/Blue_spells/Cards.clear()
	$Player_1/Red_spells/Cards.clear()
	$Player_1/Green_spells/Cards.clear()
	$Player_2/Blue_spells/Cards.clear()
	$Player_2/Red_spells/Cards.clear()
	$Player_2/Green_spells/Cards.clear()
	for i in range(3):
		$Player_1/Blue_heros/Cards.add_icon_item(load_card_img(0))
		$Player_1/Red_heros/Cards.add_icon_item(load_card_img(0))
		$Player_1/Green_heros/Cards.add_icon_item(load_card_img(0))
		$Player_2/Blue_heros/Cards.add_icon_item(load_card_img(0))
		$Player_2/Red_heros/Cards.add_icon_item(load_card_img(0))
		$Player_2/Green_heros/Cards.add_icon_item(load_card_img(0))
		$Player_1/Blue_spells/Cards.add_icon_item(load_card_img(0))
		$Player_1/Red_spells/Cards.add_icon_item(load_card_img(0))
		$Player_1/Green_spells/Cards.add_icon_item(load_card_img(0))
		$Player_2/Blue_spells/Cards.add_icon_item(load_card_img(0))
		$Player_2/Red_spells/Cards.add_icon_item(load_card_img(0))
		$Player_2/Green_spells/Cards.add_icon_item(load_card_img(0))
	$Player_1/Hand_area/Cards.set_item_custom_bg_color(9,Color(1, 0, 0, 1))
	update_points()
	update_hand_cards()
	update_heros_cards()
	update_heros_life()
	update_spells_cards()
	update_spells_life()
	if Network.letter == 'b':
		start_game()
func start_game():
	meta_rset_id(Network.opponent, "is_beta_busy", true)
	randomize()
	var colors = ["blue", "green", "red"]
	for i in range(3):
		while objective_numbers[colors[i]] == null:
			var objective = randi() % $Board_Stuff.objective_list_dict.size() + 1
			if (not objective in objective_numbers) and ($Board_Stuff.objective_list_dict[objective]["color"] == colors[i]):
				objective_numbers[colors[i]] = objective
	meta_rset_id(Network.opponent, "objective_numbers", objective_numbers)
	rpc_id(Network.opponent,"load_objective_cards")
	load_objective_cards()
	for card in $Board_Stuff.card_list_dict:
		for singola in range($Board_Stuff.card_list_dict[card]["quantità"]):
			cards_deck.append(card)
	shuffle_deck()
	yield(draw_cards(6),"completed")
	var switch = yield(get_unique_id(), "completed")
	yield(add_switch(switch + 1), "completed")
	rpc_id(Network.opponent,"draw_cards", 6)
	while (switch + 1) in active_switches:
		yield(get_tree().create_timer(0.01), "timeout")
	if coin_flip() == 1:
		begin_turn()
	else:
		rpc_id(Network.opponent,"begin_turn")
func shuffle_deck():
	rpc_id(Network.opponent, "play_sound", "shuffle")
	play_sound("shuffle")
	cards_deck.shuffle()
	meta_rset_id(Network.opponent, "cards_deck", cards_deck)
remote func draw_cards(numOfCards):
	yield(get_tree(), "idle_frame")
	var switch = yield(get_unique_id(), "completed")
	history_write("%s pesca %d carta/e\n" % [Network.opponent_user, numOfCards])
	if cards_deck.size() == 0:
		lose_game()
		yield(get_tree().create_timer(5.0), "timeout")
	for i in range(numOfCards):
		var empty_space = get_hand1_empty_space()
		if !empty_space == -1:
			yield(get_tree().create_timer(DEFAULT_WAIT_TIME/2),"timeout")
			var drawn_card = cards_deck.pop_front()
			change_player1_hand_card(empty_space, drawn_card)
			meta_rset_id(Network.opponent, "cards_deck", cards_deck)
			rpc_id(Network.opponent,"update_deck")
			rpc_id(Network.opponent,"update_hand_cards")
			update_deck()
			update_hand_cards()
			rpc_id(Network.opponent, "play_sound", "draw")
			play_sound("draw")
			yield(trigger_effects("drawn_card"),"completed")
	remove_switch(switch)
			
remote func begin_turn():
	meta_rset_id(Network.opponent, "is_beta_busy", true)
	history_write("Inizia il turno di %s\n" % Network.username)
	set_player1_turn()
	$Board_Stuff/Turn_light.texture = load("res://Resources/green_light.png")
	yield(check_objectives("begin_turn"), "completed")
	mana_left = maximum_mana
	update_mana()
	kills_this_turn = 0
	yield(trigger_board_effects("begin_turn", null, 1, null, null), "completed")
	var switch = yield(get_unique_id(), "completed")
	yield(add_switch(switch + 1), "completed")
	rpc_id(Network.opponent,"trigger_board_effects", "enemy_begin_turn", null, 1, null, null)
	while (switch + 1) in active_switches:
		yield(get_tree().create_timer(0.01), "timeout")
	yield(draw_cards(1), "completed")
	if maximum_mana >= 5:
		yield(draw_cards(1), "completed")
	$Board_Stuff/Button.disabled = false
	meta_rset_id(Network.opponent, "is_beta_busy", false)
remote func attack(color, pos):
	yield(get_tree(), "idle_frame")
	var attacking_card = get_player1_heros_cards()[color][pos]
	var attacked_card = get_player2_heros_cards()[color][pos]
	if attacking_card == 0:
		return
	var string = pos2str({"player":1, "zone": "heros", "color": color, "pos": pos})
	if (string in cards_effects["frozen_hero"] or string in cards_effects["frozen_pos"]) and (not string in cards_effects["charge"]):
		return(false)
	rpc_id(Network.opponent, "play_sound", "attack")
	play_sound("attack")
	show_hero_attack(1, color, pos, true)
	meta_rset_id(Network.opponent, "attacking_value", load_card(attacking_card)["attacco"])
	meta_rset_id(Network.opponent, "attacking_confirmation_flag", true)
	yield(trigger_effects("attacking_hero","heros", 1, color, pos), "completed")
	if attacking_confirmation_flag == false:
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME/2), "timeout")
		show_hero_attack(1, color, pos, false)
		return(false)
	history_write("%s di %s in posizione %c%d attacca %s\n" % [ load_card(attacking_card)["nome"], Network.username, color[0].to_upper(), pos,  load_card(attacked_card)["nome"] ])
	yield(get_tree().create_timer(0.2),"timeout")
	if attacked_card == 0:
		yield(activate_effect(attacking_card, "tease", "heros", color, pos),"completed")
		show_hero_attack(1, color, pos, false)
		yield(trigger_effects("hero_teased", "heros", 1, color, pos),"completed")
		return (true)
	else:
		yield(damage_hero(2, color, pos, attacking_value), "completed")
		show_hero_attack(1, color, pos, false)
		yield(trigger_effects("hero_attacked", "heros", 1, color, pos),"completed")
		return (true)
func end_turn():
	meta_rset_id(Network.opponent, "is_beta_busy", true)
	history_write("Fine del turno di %s\n" % Network.username)
	meta_rset_id(Network.opponent, "is_beta_busy", true)
	$Board_Stuff/Button.disabled = true
	rpc_id(Network.opponent, "play_sound", "passturn")
	play_sound("passturn")
	for color in ["blue","green","red"]:
		for index in [0,1,2]:
			yield(attack(color, index), "completed")
	yield(get_tree(), "idle_frame")
	yield(trigger_board_effects("end_turn", null, 1, null, null), "completed")
	var switch = yield(get_unique_id(), "completed")
	yield(add_switch(switch + 1), "completed")
	rpc_id(Network.opponent,"trigger_board_effects", "enemy_end_turn", null, 1, null, null)
	while (switch + 1) in active_switches:
		yield(get_tree().create_timer(0.01), "timeout")
	for color in ["blue","green","red"]:
		for index in [0,1,2]:
			yield(damage_spell(1, color, index, 1), "completed")
	if not get_player1_hand_cards()[9] == 0:
		change_player1_hand_card(9, 0)
		yield(draw_cards(1), "completed")
	rpc_id(Network.opponent,"update_heros_cards")
	rpc_id(Network.opponent,"update_heros_life")
	rpc_id(Network.opponent,"update_spells_cards")
	rpc_id(Network.opponent,"update_spells_life")
	rpc_id(Network.opponent,"update_hand_cards")
	rpc_id(Network.opponent,"update_points")
	update_heros_cards()
	update_heros_life()
	update_spells_cards()
	update_spells_life()
	update_hand_cards()
	update_points()
	if maximum_mana < 5:
		maximum_mana += 1
	turns_passed += 1
	$Board_Stuff/Button.text = "Passa il turno (" + str(turns_passed) + ")"
	for effect in ["frozen_pos", "frozen_hero"]:
		remove_all_effect(1, effect)
	$Board_Stuff/Turn_light.texture = load("res://Resources/red_light.png")
	yield(check_objectives("end_turn"), "completed")
	rpc_id(Network.opponent,"begin_turn")
	meta_rset_id(Network.opponent, "is_beta_busy", false)
func play_hero(hand_pos, color, board_pos):
	meta_rset_id(Network.opponent, "is_beta_busy", true)
	var played_card = get_player1_hand_cards()[hand_pos]
	var board_card = get_player1_heros_cards()[color][board_pos]
	if !((is_player1_turn()) and (load_card(played_card)["tipo"] == "hero") and (color in load_card(played_card)["colori"]) and (board_card == 0) and mana_left > 0):
		update_hand_cards()
		meta_rset_id(Network.opponent, "is_beta_busy", false)
		return
	history_write("Viene giocato l'eroe %s in posizione %c%d\n" % [load_card(played_card)["nome"], color[0].to_upper(), board_pos])
	mana_left -= 1
	update_mana()
	show_bolt(1, "heros", color, board_pos, true)
	change_player1_hand_card(hand_pos, 0)
	change_player_1_heros_card(color, board_pos, played_card)
	change_player_1_heros_life(color, board_pos, "=", load_card(played_card)["vita"])
	rpc_id(Network.opponent,"update_hand_cards")
	rpc_id(Network.opponent,"update_heros_cards")
	rpc_id(Network.opponent,"update_heros_life")
	rpc_id(Network.opponent,"zoom_card", played_card)
	update_hand_cards()
	update_heros_cards()
	update_heros_life()
	zoom_card(played_card)
	rpc_id(Network.opponent, "play_played_card_sound", played_card)
	play_played_card_sound(played_card)
	var string = pos2str({"player": 1, "zone": "heros", "color": color, "pos": board_pos})
	add_effect(1, "frozen_hero", string)
	yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
	if has_effect(played_card, "played"):
		yield((activate_effect(played_card,  "played", "heros", color, board_pos)),"completed")
	show_bolt(1,"heros", color, board_pos, false)
	yield(trigger_effects("hero_played", "heros", 1, color, board_pos),"completed")
	meta_rset_id(Network.opponent, "is_beta_busy", false)
func play_spell(hand_pos, color, board_pos):
	meta_rset_id(Network.opponent, "is_beta_busy", true)
	var played_card = get_player1_hand_cards()[hand_pos]
	var board_card = get_player1_spells_cards()[color][board_pos]
	if !((is_player1_turn()) and (load_card(played_card)["tipo"] in ["spell", "event"]) and (color in load_card(played_card)["colori"]) and (board_card == 0) and mana_left > 0):
		update_hand_cards()
		meta_rset_id(Network.opponent, "is_beta_busy", false)
		return
	if load_card(played_card)["tipo"]=="spell":
		history_write("Viene giocato l'oggetto magico %s in posizione %c%d\n" % [load_card(played_card)["nome"], color[0].to_upper(), board_pos])
	elif load_card(played_card)["tipo"]=="event":
		history_write("Viene giocato l'evento %s in posizione %c%d\n" % [load_card(played_card)["nome"], color[0].to_upper(), board_pos])
	mana_left -= 1
	update_mana()
	show_bolt(1, "spells", color, board_pos, true)
	change_player1_hand_card(hand_pos, 0)
	change_player_1_spells_card(color, board_pos, played_card)
	change_player_1_spells_life(color, board_pos, "=", load_card(played_card)["vita"])
	rpc_id(Network.opponent,"update_hand_cards")
	rpc_id(Network.opponent,"update_spells_cards")
	rpc_id(Network.opponent,"update_spells_life")
	rpc_id(Network.opponent,"zoom_card", played_card)
	update_hand_cards()
	update_spells_cards()
	update_spells_life()
	zoom_card(played_card)
	rpc_id(Network.opponent, "play_played_card_sound", played_card)
	play_played_card_sound(played_card)
	yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
	if has_effect(played_card, "played"):
		yield((activate_effect(played_card, "played", "spells", color, board_pos)),"completed")
	show_bolt(1,"spells", color, board_pos, false)
	if load_card(played_card)["tipo"] == "event":
		change_player_1_spells_card(color, board_pos, 0)
		rpc_id(Network.opponent,"update_spells_cards")
		update_spells_cards()
		yield(trigger_effects("event_played", "spells", 1, color, board_pos),"completed")
	elif load_card(played_card)["tipo"] == "spell":
		yield(trigger_effects("spell_played", "spells", 1, color, board_pos),"completed")
	meta_rset_id(Network.opponent, "is_beta_busy", false)
remote func summon_hero(num, color, board_pos):
	yield(get_tree(), "idle_frame")
	var played_card = num
	var board_card = get_player1_heros_cards()[color][board_pos]
	if !((load_card(played_card)["tipo"] == "hero") and (color in load_card(played_card)["colori"]) and (board_card == 0)):
		return
	history_write("Viene evocato l'eroe %s in posizione %c%d\n" % [load_card(played_card)["nome"], color[0].to_upper(), board_pos])
	show_bolt(1, "heros", color, board_pos, true)
	change_player_1_heros_card(color, board_pos, played_card)
	change_player_1_heros_life(color, board_pos, "=", load_card(played_card)["vita"])
	rpc_id(Network.opponent,"update_heros_cards")
	rpc_id(Network.opponent,"update_heros_life")
	rpc_id(Network.opponent,"zoom_card", played_card)
	update_heros_cards()
	update_heros_life()
	zoom_card(played_card)
	rpc_id(Network.opponent, "play_played_card_sound", played_card)
	play_played_card_sound(played_card)
	var string = pos2str({"player": 1, "zone": "heros", "color": color, "pos": board_pos})
	add_effect(1, "frozen_hero", string)
	yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
	if has_effect(played_card, "played"):
		yield((activate_effect(played_card,  "played", "heros", color, board_pos)),"completed")
	show_bolt(1,"heros", color, board_pos, false)
	yield(trigger_effects("hero_played", "heros", 1, color, board_pos),"completed")
remote func summon_spell(num, color, board_pos):
	yield(get_tree(), "idle_frame")
	var played_card = num
	var board_card = get_player1_spells_cards()[color][board_pos]
	if  !((load_card(played_card)["tipo"] in ["spell", "event"]) and (color in load_card(played_card)["colori"]) and (board_card == 0)):
		return
	if load_card(played_card)["tipo"]=="spell":
		history_write("Viene evocato l'oggetto magico %s in posizione %c%d\n" % [load_card(played_card)["nome"], color[0].to_upper(), board_pos])
	if load_card(played_card)["tipo"]=="event":
		history_write("Viene evocato l'evento %s in posizione %c%d\n" % [load_card(played_card)["nome"], color[0].to_upper(), board_pos])
	show_bolt(1, "spells", color, board_pos, true)
	change_player_1_spells_card(color, board_pos, played_card)
	change_player_1_spells_life(color, board_pos, "=", load_card(played_card)["vita"])
	rpc_id(Network.opponent,"update_spells_cards")
	rpc_id(Network.opponent,"update_spells_life")
	rpc_id(Network.opponent,"zoom_card", played_card)
	update_spells_cards()
	update_spells_life()
	zoom_card(played_card)
	rpc_id(Network.opponent, "play_played_card_sound", played_card)
	play_played_card_sound(played_card)
	yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
	if has_effect(played_card, "played"):
		yield((activate_effect(played_card, "played", "spells", color, board_pos)),"completed")
	show_bolt(1,"spells", color, board_pos, false)
	if load_card(played_card)["tipo"] == "event":
		change_player_1_spells_card(color, board_pos, 0)
		rpc_id(Network.opponent,"update_spells_cards")
		update_spells_cards()
		yield(trigger_effects("event_played", "spells", 1, color, board_pos),"completed")
	elif load_card(played_card)["tipo"] == "spell":
		yield(trigger_effects("spell_played", "spells", 1, color, board_pos),"completed")

remote func activate_effect(num, type_of_effect, zone_activating, color_activating, pos_activating, player_trigger = null, zone_trigger = null, color_trigger = null , pos_trigger = null):
	yield(get_tree(), "idle_frame")
	var switch = yield(get_unique_id(), "completed")
	if num == 0:
		remove_switch(switch)
		return
	history_write("%s di %s attiva l'effetto %s dalla posizione %c%d\n" % [load_card(num)["nome"], Network.username, type_of_effect, color_activating[0].to_upper(), pos_activating])
	yield(call("effect_" + str(num), type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger), "completed")
	remove_switch(switch)
func trigger_effects(type_of_effect, zone_trigger = null, player_trigger = null, color_trigger = null , pos_trigger = null):
	yield(get_tree(), "idle_frame")
	yield(trigger_board_effects(type_of_effect, zone_trigger, player_trigger, color_trigger, pos_trigger), "completed")
	var switch = yield(get_unique_id(), "completed")
	yield(add_switch(switch + 1), "completed")
	rpc_id(Network.opponent,"trigger_board_effects", type_of_effect, zone_trigger, {1:2, 2:1, null:null}[player_trigger], color_trigger, pos_trigger)
	while (switch + 1) in active_switches:
		yield(get_tree().create_timer(0.01), "timeout")
remote func trigger_board_effects(type_of_effect, zone_trigger, player_trigger, color_trigger, pos_trigger):
	yield(get_tree(),"idle_frame")
	var switch = yield(get_unique_id(), "completed")
	for zone in ["heros","spells"]:
		for color in ["blue","green","red"]:
			for pos in [0,1,2]:
				if has_effect(get_player1_cards()[zone][color][pos], type_of_effect):
					if "silenzia" in load_card(get_player1_cards()[zone][color][pos]):
						if type_of_effect in load_card(get_player1_cards()[zone][color][pos])["silenzia"]:
							yield(activate_effect(get_player1_cards()[zone][color][pos], type_of_effect, zone, color, pos, player_trigger, zone_trigger, color_trigger, pos_trigger), "completed")
						else:
							show_bolt(1, zone, color, pos, true)
							yield(activate_effect(get_player1_cards()[zone][color][pos], type_of_effect, zone, color, pos, player_trigger, zone_trigger, color_trigger, pos_trigger), "completed")
							show_bolt(1, zone, color, pos, false)
					else:
						show_bolt(1, zone, color, pos, true)
						yield(activate_effect(get_player1_cards()[zone][color][pos], type_of_effect, zone, color, pos, player_trigger, zone_trigger, color_trigger, pos_trigger), "completed")
						show_bolt(1, zone, color, pos, false)
	remove_switch(switch)
remote func activate_single_effect(type_of_effect, player, zone, color, pos):
	var switch = yield(get_unique_id(), "completed")
	if player == 1:
		if has_effect(get_player1_cards()[zone][color][pos], type_of_effect):
			show_bolt(1, zone, color, pos, true)
			yield(activate_effect(get_player1_cards()[zone][color][pos], type_of_effect, zone, color, pos), "completed")
			show_bolt(1, zone, color, pos, false)
			remove_switch(switch)
		remove_switch(switch)
	else:
		remove_switch(switch)
		var switch_2 = yield(get_unique_id(), "completed")
		yield(add_switch(switch_2 + 1), "completed")
		rpc_id(Network.opponent, "activate_single_effect", type_of_effect, 1, zone, color, pos)
		while (switch_2 + 1) in active_switches:
			yield(get_tree().create_timer(0.01), "timeout")

func check_deaths():
	yield(get_tree(), "idle_frame")
	for color in ["blue","green","red"]:
		for index in [0,1,2]:
			if get_player1_heros_life()[color][index] <= 0 and !get_player1_heros_cards()[color][index] == 0:
				yield(kill_hero(1, color, index),"completed")
	for color in ["blue","green","red"]:
		for index in [0,1,2]:
			if get_player2_heros_life()[color][index] <= 0 and !get_player2_heros_cards()[color][index] == 0:
				yield(kill_hero(2, color, index),"completed")
	for color in ["blue","green","red"]:
		for index in [0,1,2]:
			if get_player1_spells_life()[color][index] <= 0 and !get_player1_spells_cards()[color][index] == 0:
				yield(kill_spell(1, color, index),"completed")
	for color in ["blue","green","red"]:
		for index in [0,1,2]:
			if get_player2_spells_life()[color][index] <= 0 and !get_player2_spells_cards()[color][index] == 0:
				yield(kill_spell(2, color, index),"completed")
func check_death(player, zone, color, pos):
	yield(get_tree(), "idle_frame")
	if player == 1:
		if zone == "heros":
			if get_player1_heros_life()[color][pos] <= 0 and !get_player1_heros_cards()[color][pos] == 0:
				yield(kill_hero(1, color, pos),"completed")
		else:
			if get_player1_spells_life()[color][pos] <= 0 and !get_player1_spells_cards()[color][pos] == 0:
				yield(kill_spell(1, color, pos),"completed")
	else:
		if zone == "heros":
			if get_player2_heros_life()[color][pos] <= 0 and !get_player2_heros_cards()[color][pos] == 0:
				yield(kill_hero(2, color, pos),"completed")
		else:
			if get_player2_spells_life()[color][pos] <= 0 and !get_player2_spells_cards()[color][pos] == 0:
				yield(kill_spell(2, color, pos),"completed")
func check_objectives(trigger):
	yield(get_tree(), "idle_frame")
	for color in objective_numbers:
		print($Board_Stuff.objective_list_dict[objective_numbers[color]]["trigger"])
		print(trigger)
		if (color in completed_objectives) or (not $Board_Stuff.objective_list_dict[objective_numbers[color]]["trigger"] == trigger):
			continue
		print("objective_" + str(objective_numbers[color]))
		var flag = call("objective_" + str(objective_numbers[color]))
		print(flag)
		if flag:
			history_write("Il giocatore %s ha completato l'obiettivo %s" % [Network.username, $Board_Stuff.objective_list_dict[objective_numbers[color]]["nome"] ])
			add_objective(color)
			rpc_id(Network.opponent,"load_objective_cards")
			play_sound("objective_completed")
			rpc_id(Network.opponent,"play_sound", "objective_completed")
			load_objective_cards()
			if get_player1_obj().size() >= 2:
				yield(get_tree().create_timer(3.0), "timeout")
				win_game()
				yield(get_tree().create_timer(20.0), "timeout")
		


remote func win_game():
	rpc_id(Network.opponent,"lose_game")
	yield(get_tree().create_timer(0.5),"timeout")
	get_tree().change_scene('res://Win.tscn')
remote func lose_game():
	rpc_id(Network.opponent,"win_game")
	yield(get_tree().create_timer(0.5),"timeout")
	get_tree().change_scene('res://Lose.tscn')


#Funzioni di caricamento, grafica e suono
func load_card(num):
	return($Board_Stuff.card_list_dict[num])
func load_card_img(num):
	return(load_card(num)["img"])
func has_effect(num,effect):
	if !(effect == "tease"):
		return(effect in load_card(num)["effetti"])
	else:
		return(load_card(num)["tipo"] == "hero")
remote func zoom_card(num):
	$Board_Stuff/Card_Container/Selected_card.texture = load_card_img(num)
remote func load_objective_cards():
	var colors = ["blue", "green", "red"]
	for i in range(3):
		var color = colors[i]
		var num = objective_numbers[color]
		print(color)
		print(num)
		print($Board_Stuff.objective_list_dict[num])
		print("Board_Stuff/Objective_Panel_" + str(i+1) + "/Objective_" + str(i+1))
		get_node("Board_Stuff/Objective_Panel_" + str(i+1) + "/Objective_" + str(i+1)).texture = $Board_Stuff.objective_list_dict[num]["img"]
		if color in get_player1_obj():
			get_node("Board_Stuff/Objective_Panel_" + str(i+1) + "/Check").texture = preload("res://Resources/green_check.png")
			get_node("Board_Stuff/Objective_Panel_" + str(i+1) + "/Check").visible = true
		elif color in get_player2_obj():
			get_node("Board_Stuff/Objective_Panel_" + str(i+1) + "/Check").texture = preload("res://Resources/red_check.png")
			get_node("Board_Stuff/Objective_Panel_" + str(i+1) + "/Check").visible = true
		else:
			get_node("Board_Stuff/Objective_Panel_" + str(i+1) + "/Check").visible = false
remote func set_heros_icon_visible(icon, player, color, board_pos, switch):
	var node_path = "Player_" + str(player) + "/" + {"blue":"Blue", "red":"Red", "green":"Green"}[color] + "_heros/Icon_" + str(board_pos + 1)
	get_node(node_path).texture = load("res://Resources/" + icon +".png")
	set_sprite_size(get_node(node_path), Vector2(30,60))
	if switch:
		get_node(node_path).show()
	else:
		get_node(node_path).hide()
remote func set_spells_icon_visible(icon, player, color, board_pos, switch):
	var node_path = "Player_" + str(player) + "/" + {"blue":"Blue", "red":"Red", "green":"Green"}[color] + "_spells/Icon_" + str(board_pos + 1)
	get_node(node_path).texture = load("res://Resources/" + icon +".png")
	set_sprite_size(get_node(node_path), Vector2(30,60))
	if switch:
		get_node(node_path).show()
	else:
		get_node(node_path).hide()
remote func set_points_icon_visible(icon, player, color, switch):
	var node_path = "Player_" + str(player) + "/Points/" + {"blue":"Blue", "red":"Red", "green":"Green"}[color] + "_icon"
	get_node(node_path).texture = load("res://Resources/" + icon +".png")
	set_sprite_size(get_node(node_path), Vector2(30,60))
	if switch:
		get_node(node_path).show()
	else:
		get_node(node_path).hide()
func show_bolt(player, zone, color, board_pos, switch):
	if zone == 'heros':
		set_heros_icon_visible("bolt", player, color, board_pos, switch)
		rpc_id(Network.opponent,"set_heros_icon_visible","bolt", {1:2, 2:1}[player], color, board_pos, switch)
	elif zone == 'spells':
		set_spells_icon_visible("bolt", player, color, board_pos, switch)
		rpc_id(Network.opponent,"set_spells_icon_visible","bolt", {1:2, 2:1}[player], color, board_pos, switch)
func show_skull(player, zone, color, board_pos, switch):
	if zone == 'heros':
		set_heros_icon_visible("skull", player, color, board_pos, switch)
		rpc_id(Network.opponent,"set_heros_icon_visible","skull", {1:2, 2:1}[player], color, board_pos, switch)
	elif zone == 'spells':
		set_spells_icon_visible("skull", player, color, board_pos, switch)
		rpc_id(Network.opponent,"set_spells_icon_visible","skull", {1:2, 2:1}[player], color, board_pos, switch)
func show_damage_card(player, zone, color, board_pos, switch):
	if zone == 'heros':
		set_heros_icon_visible("damage", player, color, board_pos, switch)
		rpc_id(Network.opponent,"set_heros_icon_visible","damage", {1:2, 2:1}[player], color, board_pos, switch)
	elif zone == 'spells':
		set_spells_icon_visible("damage", player, color, board_pos, switch)
		rpc_id(Network.opponent,"set_spells_icon_visible","damage", {1:2, 2:1}[player], color, board_pos, switch)
func show_heal_card(player, zone, color, board_pos, switch):
	if zone == 'heros':
		set_heros_icon_visible("heal", player, color, board_pos, switch)
		rpc_id(Network.opponent,"set_heros_icon_visible","heal", {1:2, 2:1}[player], color, board_pos, switch)
	elif zone == 'spells':
		set_spells_icon_visible("heal", player, color, board_pos, switch)
		rpc_id(Network.opponent,"set_spells_icon_visible","heal", {1:2, 2:1}[player], color, board_pos, switch)
func show_damage_player(player, color, switch):
	set_points_icon_visible("down", player, color, switch)
	rpc_id(Network.opponent,"set_points_icon_visible","down", {1:2, 2:1}[player], color, switch)
func show_heal_player(player, color, switch):
	set_points_icon_visible("up", player, color, switch)
	rpc_id(Network.opponent,"set_points_icon_visible","up", {1:2, 2:1}[player], color, switch)
func show_hero_attack(player, color, board_pos, switch):
	set_heros_icon_visible("attack", player, color, board_pos, switch)
	rpc_id(Network.opponent,"set_heros_icon_visible","attack", {1:2, 2:1}[player], color, board_pos, switch)
remote func play_played_card_sound(num):
	var player2 = AudioStreamPlayer.new()
	player2.stream = load_card(num)["sound"]
	player2.volume_db = sound_volume
	$Board_Stuff.add_child(player2)
	if not $Board_Stuff/Background_music.volume_db == -INF:
		$Board_Stuff/Background_music.volume_db = linear2db($Settings/HSlider.value/10)
	player2.play()
	if load_card(num)["quantità"] == 1:
		$Board_Stuff/Background_music.volume_db = -INF
		yield(get_tree().create_timer(1.0),"timeout")
		yield(play_sound("epic", sound_volume), "completed")
		$Board_Stuff/Background_music.volume_db = linear2db($Settings/HSlider.value)
		yield(player2, "finished")
		$Board_Stuff.remove_child(player2)
	else:
		yield(player2, "finished")
		$Board_Stuff.remove_child(player2)
		if not $Board_Stuff/Background_music.volume_db == -INF:
			$Board_Stuff/Background_music.volume_db = linear2db($Settings/HSlider.value)
remote func play_sound(sound, volume = null):
	var player = AudioStreamPlayer.new()
	if volume == null:
		player.volume_db = sound_volume
	else:
		player.volume_db = volume
	player.stream = load("res://Resources/" + sound +".wav")
	$Board_Stuff.add_child(player)
	player.play()
	yield(player, "finished")
	$Board_Stuff.remove_child(player)

#Funzioni di cronologia
remotesync var history
remote func history_create():
	history = File.new()
	history.open("user://history.txt", File.WRITE)
	history.store_line("CRONOLOGIA DELLA PARTITA")
	history.close()
remote func history_write(content, flag=true):
	history = File.new()
	history.open("user://history.txt", File.READ_WRITE)
	history.seek_end()
	history.store_string(content)
	history.close()
	if flag:
		rpc_id(Network.opponent,"history_write", content, false)
	
remote func history_read():
	history = File.new()
	history.open("user://history.txt", File.READ)
	var content = history.get_as_text()
	history.close()
	return content

#Altre funzioni utili
func _on_Button_pressed():
	if is_player1_turn() and !is_beta_busy:
		end_turn()
func set_sprite_size(sprite, final_size):
	var initial_size = sprite.texture.get_size()
	var scalevector = final_size/initial_size
	sprite.scale = scalevector
func coin_flip():
	randomize()
	var toss = randi()%2
	return(toss)
func swap_hand_cards(ind_from, ind_to):
	var temp_card = get_player1_hand_cards()[ind_from]
	change_player1_hand_card(ind_from, get_player1_hand_cards()[ind_to])
	change_player1_hand_card(ind_to, temp_card)
	update_hand_cards()
func get_free_spots(player, zone, color = null):
	var list = []
	if color == null:
		if player == 1:
			for acolor in ["red", "blue", "green"]:
				for pos in [0,1,2]:
					if get_player1_cards()[zone][acolor][pos] == 0:
						list.append({"color": acolor, "pos" : pos})
		else:
			for acolor in ["red", "blue", "green"]:
				for pos in [0,1,2]:
					if get_player2_cards()[zone][acolor][pos] == 0:
						list.append({"color": acolor, "pos" : pos})
		return(list)
	else:
		if player == 1:
			for pos in [0,1,2]:
				if get_player1_cards()[zone][color][pos] == 0:
					list.append(pos)
		else:
			for pos in [0,1,2]:
				if get_player2_cards()[zone][color][pos] == 0:
					list.append(pos)
		return(list)
func get_heros_spots(player, color = null):
	var list = []
	if color == null:
		if player == 1:
			for acolor in ["red", "blue", "green"]:
				for pos in [0,1,2]:
					if !(get_player1_heros_cards()[acolor][pos] == 0):
						list.append({"color": acolor, "pos" : pos})
		else:
			for acolor in ["red", "blue", "green"]:
				for pos in [0,1,2]:
					if !(get_player2_heros_cards()[acolor][pos] == 0):
						list.append({"color": acolor, "pos" : pos})
		return(list)
	else:
		if player == 1:
			for pos in [0,1,2]:
				if !(get_player1_heros_cards()[color][pos] == 0):
					list.append(pos)
		else:
			for pos in [0,1,2]:
				if !(get_player2_heros_cards()[color][pos] == 0):
					list.append(pos)
	return(list)
func get_spells_spots(player, color = null):
	var list = []
	if color == null:
		if player == 1:
			for acolor in ["red", "blue", "green"]:
				for pos in [0,1,2]:
					if !(get_player1_spells_cards()[acolor][pos] == 0):
						list.append({"color": acolor, "pos" : pos})
		else:
			for acolor in ["red", "blue", "green"]:
				for pos in [0,1,2]:
					if !(get_player2_spells_cards()[acolor][pos] == 0):
						list.append({"color": acolor, "pos" : pos})
		return(list)
	else:
		if player == 1:
			for pos in [0,1,2]:
				if !(get_player1_spells_cards()[color][pos] == 0):
					list.append(pos)
		else:
			for pos in [0,1,2]:
				if !(get_player2_spells_cards()[color][pos] == 0):
					list.append(pos)
	return(list)
func get_hand1_empty_space():
	for i in range(10):
		if get_player1_hand_cards()[i] == 0:
			return(i)
	return(-1)
func get_hand2_empty_space():
	for i in range(10):
		if get_player2_hand_cards()[i] == 0:
			return(i)
	return(-1)
func pos2str (pos_dict):
	var string = "****"
	string[0] = str(pos_dict["player"])[0]
	string[1] = str(pos_dict["zone"])[0]
	string[2] = str(pos_dict["color"])[0]
	string[3] = str(pos_dict["pos"])[0]
	return(string)
func str2pos (string):
	var dict = {}
	dict["player"] = int(string[0])
	dict["zone"] = {"h": "heros", "s": "spells"}[string[1]]
	dict["color"] = {"r":"red", "g":"green", "b":"blue"}[string[2]]
	dict["pos"] = int(string[3])
	return(dict)
func get_name_card(name):
	for card in $Board_Stuff.card_list_dict:
		if $Board_Stuff.card_list_dict[card]["nome"] == name:
			return card
	return -1
func logBase(value, base):
	return log(value) / log(base)

#Funzioni per le carte
func is_on_board(num):
	for color in ["red","blue","green"]:
		if (num in get_player1_heros_cards()[color]) or (num in get_player1_spells_cards()[color]):
			return(true)
		if (num in get_player2_heros_cards()[color]) or (num in get_player2_spells_cards()[color]):
			return(true)
	return(false)
func find_on_board(num):
	var list = []
	for color in ["red","blue","green"]:
		for pos in [0,1,2]:
			if get_player1_heros_cards()[color][pos] == num or get_player1_spells_cards()[color][pos] == num:
				list.append({"player":1, "color":color, "pos": pos})
	for color in ["red","blue","green"]:
		for pos in [0,1,2]:
			if get_player2_heros_cards()[color][pos] == num or get_player2_spells_cards()[color][pos] == num:
				list.append({"player":2, "color":color, "pos": pos})
	return(list)
func kill_hero(player, color, index):
	yield(get_tree(), "idle_frame")
	if player == 1:
		var dying_card = get_player1_heros_cards()[color][index]
		if dying_card == 0 or load_card(dying_card)["vita"] == 0:
			return(false)
		meta_rset_id(Network.opponent, "kill_confirmation_flag", true)
		yield(trigger_effects("killing_hero","heros", 1, color, index), "completed")
		if kill_confirmation_flag == false:
			return(false)
		history_write("L'eroe %s di %s in posizione %c%d è morto\n" % [load_card(dying_card)["nome"], Network.username, color[0].to_upper(), index])
		rpc_id(Network.opponent, "play_sound", "death")
		play_sound("death")
		show_skull(1, "heros", color, index, true)
		rpc_id(Network.opponent,"zoom_card", dying_card)
		zoom_card(dying_card)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		change_player_1_heros_card(color, index, 0)
		change_player_1_heros_life(color, index, "=",0)
		rpc_id(Network.opponent,"update_heros_cards")
		rpc_id(Network.opponent,"update_heros_life")
		update_heros_cards()
		update_heros_life()
		var string = pos2str({"player": player, "zone": "heros", "color": color, "pos": index})
		for effect in ["frozen_hero"]:
			remove_effect(1, effect, string)
			remove_effect(2, effect, string)
		if has_effect(dying_card, "dead"):
			yield((activate_effect(dying_card, "dead","heros", color, index)),"completed")
		show_skull(1, "heros", color, index, false)
		yield(trigger_effects("dead_hero","heros", 1, color, index), "completed")
		kills_this_turn += 1
		return(true)
	else:
		var dying_card = get_player2_heros_cards()[color][index]
		if dying_card == 0 or load_card(dying_card)["vita"] == 0:
			return(false)
		meta_rset_id(Network.opponent, "kill_confirmation_flag", true)
		yield(trigger_effects("killing_hero","heros", 2, color, index), "completed")
		if kill_confirmation_flag == false:
			return(false)
		history_write("L'eroe %s di %s in posizione %c%d è morto\n" % [load_card(dying_card)["nome"], Network.opponent_user, color[0].to_upper(), index])
		rpc_id(Network.opponent, "play_sound", "death")
		play_sound("death")
		show_skull(2, "heros", color, index, true)
		rpc_id(Network.opponent,"zoom_card", dying_card)
		zoom_card(dying_card)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		change_player_2_heros_card(color, index, 0)
		change_player_2_heros_life(color, index, "=",0)
		rpc_id(Network.opponent,"update_heros_cards")
		rpc_id(Network.opponent,"update_heros_life")
		update_heros_cards()
		update_heros_life()
		var string = pos2str({"player": player, "zone": "heros", "color": color, "pos": index})
		for effect in ["frozen_hero"]:
			remove_effect(1, effect, string)
			remove_effect(2, effect, string)
		if has_effect(dying_card, "dead"):
			var switch = yield(get_unique_id(), "completed")
			yield(add_switch(switch + 1), "completed")
			rpc_id(Network.opponent,"activate_effect", dying_card, "dead", "heros" , color, index)
			while (switch + 1) in active_switches:
				yield(get_tree().create_timer(0.01), "timeout")
		show_skull(2 ,"heros", color, index, false)
		yield(trigger_effects("dead_hero","heros", 2, color, index), "completed")
		kills_this_turn += 1
		return(true)
func kill_spell(player, color, index):
	yield(get_tree(), "idle_frame")
	if player == 1:
		var dying_card = get_player1_spells_cards()[color][index]
		if dying_card == 0 or load_card(dying_card)["tipo"] == "event":
			return(false)
		meta_rset_id(Network.opponent, "kill_confirmation_flag", true)
		yield(trigger_effects("killing_spell","spells", 1, color, index), "completed")
		if kill_confirmation_flag == false:
			return(false)
		history_write("L'oggetto magico %s di %s in posizione %c%d è stato distrutto\n" % [load_card(dying_card)["nome"], Network.username, color[0].to_upper(), index])
		rpc_id(Network.opponent, "play_sound", "death")
		play_sound("death")
		show_skull(1, "spells", color, index, true)
		rpc_id(Network.opponent,"zoom_card", dying_card)
		zoom_card(dying_card)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		change_player_1_spells_card(color, index, 0)
		change_player_1_spells_life(color, index, "=",0)
		rpc_id(Network.opponent,"update_spells_cards")
		rpc_id(Network.opponent,"update_spells_life")
		update_spells_cards()
		update_spells_life()
		var string = pos2str({"player": player, "zone": "spells", "color": color, "pos": index})
		for effect in []:
			remove_effect(1, effect, string)
			remove_effect(2, effect, string)
		if has_effect(dying_card, "dead"):
			yield((activate_effect(dying_card, "dead","spells", color, index)),"completed")
		show_skull(1, "spells", color, index, false)
		yield(trigger_effects("dead_spell","spells", 1, color, index), "completed")
		kills_this_turn += 1
		return(true)
	else:
		var dying_card = get_player2_spells_cards()[color][index]
		if dying_card == 0 or load_card(dying_card)["vita"] == 0:
			return(false)
		meta_rset_id(Network.opponent, "kill_confirmation_flag", true)
		yield(trigger_effects("killing_spell","spells", 2, color, index), "completed")
		if kill_confirmation_flag == false:
			return(false)
		history_write("L'oggetto magico %s di %s in posizione %c%d è stato distrutto\n" % [load_card(dying_card)["nome"], Network.opponent_user, color[0].to_upper(), index])
		rpc_id(Network.opponent, "play_sound", "death")
		play_sound("death")
		show_skull(2, "spells", color, index, true)
		rpc_id(Network.opponent,"zoom_card", dying_card)
		zoom_card(dying_card)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		change_player_2_spells_card(color, index, 0)
		change_player_2_spells_life(color, index, "=",0)
		rpc_id(Network.opponent,"update_spells_cards")
		rpc_id(Network.opponent,"update_spells_life")
		update_spells_cards()
		update_spells_life()
		var string = pos2str({"player": player, "zone": "spells", "color": color, "pos": index})
		for effect in []:
			remove_effect(1, effect, string)
			remove_effect(2, effect, string)
		if has_effect(dying_card, "dead"):
			var switch = yield(get_unique_id(), "completed")
			yield(add_switch(switch + 1), "completed")
			rpc_id(Network.opponent,"activate_effect", dying_card, "dead", "spells", color, index)
			while (switch + 1) in active_switches:
				yield(get_tree().create_timer(0.01), "timeout")
		show_skull(2 ,"spells", color, index, false)
		yield(trigger_effects("dead_spell","spells", 2, color, index), "completed")
		kills_this_turn += 1
		return(true)
func damage_spell(player, color, index, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		var damaged_card = get_player1_spells_cards()[color][index]
		if damaged_card == 0 or load_card(damaged_card)["tipo"] == "event":
			return
		meta_rset_id(Network.opponent, "damage_hero_confirmation_flag", true)
		yield(trigger_effects("damaging_spell","heros", 1, color, index), "completed")
		if damage_hero_confirmation_flag == false:
			return(false)
		history_write("L'oggetto magico %s di %s in posizione %c%d subisce %d danni\n" % [load_card(damaged_card)["nome"], Network.username, color[0].to_upper(), index, amount])
		rpc_id(Network.opponent, "play_sound", "damage")
		play_sound("damage")
		show_damage_card(player, "spells", color, index, true)
		change_player_1_spells_life(color, index, "-", amount)
		rpc_id(Network.opponent,"update_spells_life")
		update_spells_life()
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME/2),"timeout")
		if has_effect(damaged_card, "damaged"):
			yield(activate_effect(damaged_card, "damaged","spells", color, index), "completed")
		show_damage_card(player, "spells", color, index, false)
		yield(trigger_effects("damaged_spell", "spells", 1, color, index),"completed")
		yield(check_death(player, "spells", color, index),"completed")
		
		
	else:
		var damaged_card = get_player2_spells_cards()[color][index]
		if damaged_card == 0:
			return
		meta_rset_id(Network.opponent, "damage_hero_confirmation_flag", true)
		yield(trigger_effects("damaging_spell","heros", 2, color, index), "completed")
		if damage_hero_confirmation_flag == false:
			return(false)
		history_write("L'oggetto magico %s di %s in posizione %c%d subisce %d danni\n" % [load_card(damaged_card)["nome"], Network.opponent_user, color[0].to_upper(), index, amount])
		rpc_id(Network.opponent, "play_sound", "damage")
		play_sound("damage")
		show_damage_card(player,"spells", color, index, true)
		change_player_2_spells_life(color, index, "-", amount)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME/2),"timeout")
		if has_effect(damaged_card, "damaged"):
			var switch = yield(get_unique_id(), "completed")
			yield(add_switch(switch + 1), "completed")
			rpc_id(Network.opponent,"activate_effect", damaged_card, "damaged", "spells", color, index)
			while (switch + 1) in active_switches:
				yield(get_tree().create_timer(0.01), "timeout")
		rpc_id(Network.opponent,"update_spells_life")
		update_spells_life()
		show_damage_card(player,"spells", color, index, false)
		yield(trigger_effects("damaged_spell","spells", 2, color, index),"completed")
		yield(check_death(player, "spells", color, index),"completed")
func damage_hero(player, color, index, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		var damaged_card = get_player1_heros_cards()[color][index]
		if damaged_card == 0:
			return
		meta_rset_id(Network.opponent, "damage_hero_confirmation_flag", true)
		yield(trigger_effects("damaging_hero","heros", 1, color, index), "completed")
		if damage_hero_confirmation_flag == false:
			return(false)
		history_write("L'eroe %s di %s in posizione %c%d subisce %d danni\n" % [load_card(damaged_card)["nome"], Network.username, color[0].to_upper(), index, amount])
		rpc_id(Network.opponent, "play_sound", "damage")
		play_sound("damage")
		show_damage_card(player, "heros", color, index, true)
		change_player_1_heros_life(color, index, "-", amount)
		rpc_id(Network.opponent,"update_heros_life")
		update_heros_life()
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME/2),"timeout")
		if has_effect(damaged_card, "damaged"):
			yield(activate_effect(damaged_card, "damaged","heros", color, index), "completed")
		show_damage_card(player, "heros", color, index, false)
		yield(trigger_effects("damaged_hero", "heros", 1, color, index),"completed")
		yield(check_death(player, "heros", color, index),"completed")
	else:
		var damaged_card = get_player2_heros_cards()[color][index]
		if damaged_card == 0:
			return
		meta_rset_id(Network.opponent, "damage_hero_confirmation_flag", true)
		yield(trigger_effects("damaging_hero","heros", 2, color, index), "completed")
		if damage_hero_confirmation_flag == false:
			return(false)
		history_write("L'eroe %s di %s in posizione %c%d subisce %d danni\n" % [load_card(damaged_card)["nome"], Network.opponent_user, color[0].to_upper(), index, amount])
		rpc_id(Network.opponent, "play_sound", "damage")
		play_sound("damage")
		show_damage_card(player,"heros", color, index, true)
		change_player_2_heros_life(color, index, "-", amount)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME/2),"timeout")
		if has_effect(damaged_card, "damaged"):
			var switch = yield(get_unique_id(), "completed")
			yield(add_switch(switch + 1), "completed")
			rpc_id(Network.opponent,"activate_effect", damaged_card, "damaged", "heros", color, index)
			while (switch + 1) in active_switches:
				yield(get_tree().create_timer(0.01), "timeout")
		rpc_id(Network.opponent,"update_heros_life")
		update_heros_life()
		show_damage_card(player,"heros", color, index, false)
		yield(trigger_effects("damaged_hero","heros", 2, color, index),"completed")
		yield(check_death(player, "heros", color, index),"completed")
func heal_spell(player, color, index, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		var healed_card = get_player1_spells_cards()[color][index]
		if healed_card == 0 or load_card(healed_card)["tipo"] == "event":
			return
		history_write("L'oggetto magico %s di %s in posizione %c%d guadagna %d di durabilità\n" % [load_card(healed_card)["nome"], Network.username, color[0].to_upper(), index, amount])
		rpc_id(Network.opponent, "play_sound", "heal")
		play_sound("heal")
		show_heal_card(player, "spells", color, index, true)
		change_player_1_spells_life(color, index, "+", amount)
		rpc_id(Network.opponent,"update_spells_life")
		update_spells_life()
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		if has_effect(healed_card, "healed"):
			yield(activate_effect(healed_card, "healed","spells", color, index), "completed")
		show_heal_card(player, "spells", color, index, false)
		yield(trigger_effects("healed_spell", "spells", 1, color, index),"completed")
		
		
	else:
		var healed_card = get_player2_spells_cards()[color][index]
		if healed_card == 0:
			return
		history_write("L'oggetto magico %s di %s in posizione %c%d guadagna %d di durabilità\n" % [load_card(healed_card)["nome"], Network.opponent_user, color[0].to_upper(), index, amount])
		rpc_id(Network.opponent, "play_sound", "heal")
		play_sound("heal")
		show_heal_card(player,"spells", color, index, true)
		change_player_2_spells_life(color, index, "+", amount)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		if has_effect(healed_card, "healed"):
			var switch = yield(get_unique_id(), "completed")
			yield(add_switch(switch + 1), "completed")
			rpc_id(Network.opponent,"activate_effect", healed_card, "healed", "spells", color, index)
			while (switch+1) in active_switches:
				yield(get_tree().create_timer(0.001), "timeout")
		rpc_id(Network.opponent,"update_spells_life")
		update_spells_life()
		show_heal_card(player,"spells", color, index, false)
		yield(trigger_effects("healed_card","spells", 2, color, index),"completed")
func heal_hero(player, color, index, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		var healed_card = get_player1_heros_cards()[color][index]
		if healed_card == 0:
			return
		history_write("L'eroe %s di %s in posizione %c%d guadagna %d di vita\n" % [load_card(healed_card)["nome"], Network.username, color[0].to_upper(), index, amount])
		rpc_id(Network.opponent, "play_sound", "heal")
		play_sound("heal")
		show_heal_card(player, "heros", color, index, true)
		change_player_1_heros_life(color, index, "+", amount)
		rpc_id(Network.opponent,"update_heros_life")
		update_heros_life()
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		if has_effect(healed_card, "healed"):
			yield(activate_effect(healed_card, "healed","heros", color, index), "completed")
		show_heal_card(player, "heros", color, index, false)
		yield(trigger_effects("healed_hero", "heros", 1, color, index),"completed")
	else:
		var healed_card = get_player2_heros_cards()[color][index]
		if healed_card == 0:
			return
		history_write("L'eroe %s di %s in posizione %c%d guadagna %d di vita\n" % [load_card(healed_card)["nome"], Network.opponent_user, color[0].to_upper(), index, amount])
		rpc_id(Network.opponent, "play_sound", "heal")
		play_sound("heal")
		show_heal_card(player,"heros", color, index, true)
		change_player_2_heros_life(color, index, "+", amount)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		if has_effect(healed_card, "healed"):
			var switch = yield(get_unique_id(), "completed")
			yield(add_switch(switch + 1), "completed")
			rpc_id(Network.opponent,"activate_effect", healed_card, "healed", "heros", color, index)
			while (switch + 1) in active_switches:
				yield(get_tree().create_timer(0.01), "timeout")
		rpc_id(Network.opponent,"update_heros_life")
		update_heros_life()
		show_heal_card(player,"heros", color, index, false)
		yield(trigger_effects("healed_hero","heros", 2, color, index),"completed")
func set_hero(player, color, index, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		if get_player1_heros_life()[color][index] == amount:
			return
		if get_player1_heros_life()[color][index] > amount:
			yield(damage_hero(1, color, index, get_player1_heros_life()[color][index] - amount), "completed")
		else:
			yield(heal_hero(1, color, index, amount - get_player1_heros_life()[color][index]), "completed")
func set_spell(player, color, index, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		if get_player1_spells_life()[color][index] == amount:
			return
		if get_player1_spells_life()[color][index] > amount:
			yield(damage_spell(1, color, index, get_player1_spells_life()[color][index] - amount), "completed")
		else:
			yield(heal_spell(1, color, index, amount - get_player1_spells_life()[color][index]), "completed")
func damage_player(player, color, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		history_write("Il giocatore %s ha perso %d di %s\n" % [Network.username, amount, {"red":"libido", "blue":"intelligenza", "green":"follia"}[color] ])
		show_damage_player(player, color, true)
		change_player1_points(color,"-", amount)
		if get_player1_points()[color] < 0:
			change_player1_points(color,"=", 0)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		rpc_id(Network.opponent,"update_points")
		update_points()
		show_damage_player(player, color, false)
		yield(trigger_effects("damaged_player",null, 1, color), "completed")
	else:
		history_write("Il giocatore %s ha perso %d di %s\n" % [Network.opponent_user, amount, {"red":"libido", "blue":"intelligenza", "green":"follia"}[color] ])
		show_damage_player(player, color, true)
		change_player2_points(color,"-", amount)
		if get_player2_points()[color] < 0:
			change_player2_points(color,"=", 0)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		rpc_id(Network.opponent,"update_points")
		update_points()
		show_damage_player(player, color, false)
		yield(trigger_effects("damaged_player",null, 1, color), "completed")
func heal_player(player, color, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		meta_rset_id(Network.opponent, "heal_player_confirmation_flag", true)
		yield(trigger_effects("healing_player", amount, 1, color), "completed")
		if heal_player_confirmation_flag == false:
			return(false)
		history_write("Il giocatore %s ha guadagnato %d di %s\n" % [Network.username, amount, {"red":"libido", "blue":"intelligenza", "green":"follia"}[color] ])
		show_heal_player(player, color, true)
		change_player1_points(color,"+", amount)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		rpc_id(Network.opponent,"update_points")
		update_points()
		show_heal_player(player, color, false)
		yield(trigger_effects("healed_player", amount, 1, color), "completed")
		
	else:
		meta_rset_id(Network.opponent, "heal_player_confirmation_flag", true)
		yield(trigger_effects("healing_player", amount, 2, color), "completed")
		if heal_player_confirmation_flag == false:
			return(false)
		history_write("Il giocatore %s ha guadagnato %d di %s\n" % [Network.username, amount, {"red":"libido", "blue":"intelligenza", "green":"follia"}[color] ])
		show_heal_player(player, color, true)
		change_player2_points(color,"+", amount)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		rpc_id(Network.opponent,"update_points")
		update_points()
		show_heal_player(player, color, false)
		yield(trigger_effects("healed_player", amount, 2, color), "completed")
func set_player(player, color, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		var diff = abs(get_player1_points()[color] - amount)
		if get_player1_points()[color] == amount:
			return
		if get_player1_points()[color] > amount:
			yield(damage_player(player, color, diff), "completed")
		else:
			yield(heal_player(player, color, diff), "completed")
		
	else:
		var diff = abs(get_player2_points()[color] - amount)
		if get_player2_points()[color] == amount:
			return
		if get_player2_points()[color] > amount:
			yield(damage_player(player, color, diff), "completed")
		else:
			yield(heal_player(player, color, diff), "completed")
		

remote func random_summon_hero(num, color = null):
	yield(get_tree(), "idle_frame")
	var switch = yield(get_unique_id(), "completed")
	if !(color == null):
		var free_spots = get_free_spots(1, "heros", color)
		if free_spots.size() == 0:
			remove_switch(switch)
			zoom_card(num)
			rpc_id(Network.opponent, "zoom_card", num)
			yield(get_tree().create_timer(1.0), "timeout")
			return
		randomize()
		var sel_spot = free_spots[randi()%free_spots.size()]
		yield(summon_hero(num, color, sel_spot), "completed")
		remove_switch(switch)
		return({"color": color, "pos" : sel_spot})
	else: 
		var free_spots = get_free_spots(1, "heros")
		var randint
		var sel_spot 
		while free_spots.size() > 0:
			randint = randi()%free_spots.size()
			sel_spot = free_spots[randint]
			if sel_spot["color"] in load_card(num)["colori"]:
				yield(summon_hero(num, sel_spot["color"], sel_spot["pos"]), "completed")
				remove_switch(switch)
				return({"color": sel_spot["color"], "pos" : sel_spot["pos"]})
			free_spots.remove(randint)
		remove_switch(switch)
		zoom_card(num)
		rpc_id(Network.opponent, "zoom_card", num)
		yield(get_tree().create_timer(1.0), "timeout")
		return 
remote func random_summon_spell(num, color = null):
	yield(get_tree(), "idle_frame")
	var switch = yield(get_unique_id(), "completed")
	if !(color == null):
		var free_spots = get_free_spots(1, "spells", color)
		if free_spots.size() == 0:
			remove_switch(switch)
			zoom_card(num)
			rpc_id(Network.opponent, "zoom_card", num)
			yield(get_tree().create_timer(1.0), "timeout")
			return
		randomize()
		var sel_spot = free_spots[randi()%free_spots.size()]
		yield(summon_spell(num, color, sel_spot), "completed")
		remove_switch(switch)
		return({"color": color, "pos" : sel_spot})
	else:
		var free_spots = get_free_spots(1, "spells")
		var randint
		var sel_spot 
		while free_spots.size() > 0:
			randint = randi()%free_spots.size()
			sel_spot = free_spots[randint]
			if sel_spot["color"] in load_card(num)["colori"]:
				yield(summon_spell(num, sel_spot["color"], sel_spot["pos"]), "completed")
				remove_switch(switch)
				return({"color": sel_spot["color"], "pos" : sel_spot["pos"]})
			free_spots.remove(randint)
		remove_switch(switch)
		zoom_card(num)
		rpc_id(Network.opponent, "zoom_card", num)
		yield(get_tree().create_timer(1.0), "timeout")
		return
remote func random_summon_card(num):
	if "hero" == load_card(num)["tipo"]:
		yield(random_summon_hero(num), "completed")
	else:
		yield(random_summon_spell(num), "completed")

func no_triggers_heal_player(player, color, amount):
	yield(get_tree(), "idle_frame")
	if player == 1:
		history_write("Il giocatore %s ha guadagnato %d di %s\n" % [Network.username, amount, {"red":"libido", "blue":"intelligenza", "green":"follia"}[color] ])
		show_heal_player(player, color, true)
		change_player1_points(color,"+", amount)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		rpc_id(Network.opponent,"update_points")
		update_points()
		show_heal_player(player, color, false)
	else:
		history_write("Il giocatore %s ha guadagnato %d di %s\n" % [Network.username, amount, {"red":"libido", "blue":"intelligenza", "green":"follia"}[color] ])
		show_heal_player(player, color, true)
		change_player2_points(color,"+", amount)
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
		rpc_id(Network.opponent,"update_points")
		update_points()
		show_heal_player(player, color, false)

func random_summon_enemy_hero(num, color = null):
	var switch = yield(get_unique_id(), "completed")
	yield(add_switch(switch + 1), "completed")
	rpc_id(Network.opponent,"random_summon_hero", num, color)
	while (switch + 1) in active_switches:
		yield(get_tree().create_timer(0.01), "timeout")
func random_summon_enemy_spell(num, color = null):
	var switch = yield(get_unique_id(), "completed")
	yield(add_switch(switch + 1), "completed")
	rpc_id(Network.opponent,"random_summon_spell", num, color)
	while (switch + 1) in active_switches:
		yield(get_tree().create_timer(0.01), "timeout")
func random_summon_enemy_card(num):
	var switch = yield(get_unique_id(), "completed")
	yield(add_switch(switch + 1), "completed")
	rpc_id(Network.opponent,"random_summon_card", num)
	while (switch + 1) in active_switches:
		yield(get_tree().create_timer(0.01), "timeout")

func add_to_hand(player, num):
	yield(get_tree(), "idle_frame")
	if player == 1:
		var hand = get_player1_hand_cards()
		var index = hand.find(0)
		if index == -1:
			return
		history_write("Il giocatore %s aggiunge alla mano una carta\n" % Network.username)
		change_player1_hand_card(index, num)
		update_hand_cards()
		rpc_id(Network.opponent,"update_hand_cards")
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
	else:
		var hand = get_player2_hand_cards()
		var index = hand.find(0)
		if index == -1:
			return
		history_write("Il giocatore %s aggiunge alla mano una carta\n" % Network.opponent_user)
		change_player2_hand_card(index, num)
		update_hand_cards()
		rpc_id(Network.opponent,"update_hand_cards")
		yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
func add_to_deck(num):
	yield(get_tree(), "idle_frame")
	cards_deck.append(num)
	shuffle_deck()
	update_deck()
	rpc_id(Network.opponent,"update_deck")
	yield(get_tree().create_timer(DEFAULT_WAIT_TIME),"timeout")
func power_attack(value):
	meta_rset_id(Network.opponent, "attacking_value", attacking_value + value)

#Obiettivi

#func objective_1():
#	print(get_heros_spots(1, "red").size())
#	print(get_player1_points()["red"])
#	var flag = (get_heros_spots(1, "red").size() == 1) and (get_player1_points()["red"] >= 1000)
#	return(flag)
#func objective_2():
#	var flag1 = false
#	for alcolico in $Board_Stuff.get_alcolici():
#		for spot in find_on_board(alcolico):
#			if spot["player"] == 1:
#				flag1 = true
#	var flag = flag1 and (get_player1_points()["green"] >= 800)
#	return(flag)
#func objective_3():
#	var flag1 = false
#	for libro in $Board_Stuff.get_libri():
#		for spot in find_on_board(libro):
#			if spot["player"] == 1:
#				flag1 = true
#	var flag = flag1 and (get_player1_points()["blue"] >= 900)
#	return(flag)
#func objective_4():
#	var flag1 = get_heros_spots(1).size() >= 5
#	var flag = flag1 and (get_player1_points()["red"] >= 800)
#	return(flag)
#func objective_5():
#	var flag1 = kills_this_turn >= 5
#	var flag = flag1 and (get_player1_points()["green"] >= 700)
#	return(flag)
#func objective_6():
#	var flag1 = get_player1_points()["red"] == get_player1_points()["green"]
#	var flag = flag1 and (get_player1_points()["blue"] >= 500)
#	return(flag)
#func objective_7():
#	var flag1 = false
#	var flag2 = false
#	for pietanza in $Board_Stuff.get_pietanze():
#		for spot in find_on_board(pietanza):
#			if spot["player"] == 1:
#				flag1 = true
#	for bevanda in $Board_Stuff.get_bevande():
#		for spot in find_on_board(bevanda):
#			if spot["player"] == 1:
#				flag2 = true
#	var flag = flag1 and flag2 and (get_player1_points()["red"] >= 600)
#	return(flag)
#func objective_8():
#	var flag1 = get_heros_spots(1, "green").size() == 3
#	var flag = flag1 and (get_player1_points()["green"] >= 1000)
#	return(flag)
#func objective_9():
	var flag = get_player1_points()["blue"] - get_player2_points()["blue"] >= 500
	return(flag)
func objective_1():
	var flag1 = (get_heros_spots(1, "red").size()) >= 1
	var flag = flag1 and (get_player1_points()["red"] >= 600)
	return(flag)
func objective_2():
	var flag1 = false
	for alcolico in $Board_Stuff.get_alcolici():
		for spot in find_on_board(alcolico):
			if spot["player"] == 1:
				flag1 = true
	var flag = flag1 and (get_player1_points()["green"] >= 550)
	return(flag)
func objective_3():
	var flag1 = false
	for libro in $Board_Stuff.get_libri():
		for spot in find_on_board(libro):
			if spot["player"] == 1:
				flag1 = true
	var flag = flag1 and (get_player1_points()["blue"] >= 700)
	return(flag)
func objective_4():
	var flag1 = get_heros_spots(1).size() >= 5
	var flag = flag1 and (get_player1_points()["red"] >= 600)
	return(flag)
func objective_5():
	var flag1 = kills_this_turn >= 4
	var flag = flag1 and (get_player1_points()["green"] >= 600)
	return(flag)
func objective_6():
	var red = get_heros_spots(1, "red").size() + get_spells_spots(1, "red").size()
	var green = get_heros_spots(1, "green").size() + get_spells_spots(1, "green").size()
	var flag1 = (red == green)
	var flag = flag1 and (get_player1_points()["blue"] >= 500)
	return(flag)
func objective_7():
	var flag1 = false
	var flag2 = false
	for pietanza in $Board_Stuff.get_pietanze():
		for spot in find_on_board(pietanza):
			if spot["player"] == 1:
				flag1 = true
	for bevanda in $Board_Stuff.get_bevande():
		for spot in find_on_board(bevanda):
			if spot["player"] == 1:
				flag2 = true
	var flag = flag1 and flag2 and (get_player1_points()["red"] >= 500)
	return(flag)
func objective_8():
	var flag1 = get_heros_spots(1, "green").size() == 3
	var flag = flag1 and (get_player1_points()["green"] >= 700)
	return(flag)
func objective_9():
	var flag = get_player1_points()["blue"] - get_player2_points()["blue"] >= 450
	return(flag)
#Effetti delle carte
func effect_0(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(heal_player(1, "red", 50), "completed")
		"tease":
			yield(damage_player(2, "red", 50), "completed")
		"spell_played":
			yield(damage_player(2, "red", 10), "completed")



func effect_1(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			yield(heal_player(1, "green", 10), "completed")
		"dead":
			if polenta_flag:
				yield(random_summon_enemy_spell(1), "completed")
func effect_2(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if color_activating == "blue":
				yield(heal_player(1, "blue", 40), "completed")
				yield(draw_cards(1), "completed")
			elif color_activating == "green":
				yield(heal_player(1, "green", 40), "completed")
				yield(draw_cards(2), "completed")
func effect_3(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if is_on_board(49):
				if get_player1_points()["red"] < 300:
					yield(heal_player(1, "red", 2 * get_player1_points()["red"]), "completed")
				if get_player2_points()["red"] < 300:
					yield(heal_player(2, "red", 2 * get_player2_points()["red"]), "completed")
			else:
				if get_player1_points()["red"] < 300:
					yield(heal_player(1, "red", get_player1_points()["red"]), "completed")
				if get_player2_points()["red"] < 300:
					yield(heal_player(2, "red", get_player2_points()["red"]), "completed")
func effect_4(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if color_activating == "blue":
				yield(heal_player(1, "blue", 40), "completed")
			elif color_activating == "red":
				if is_on_board(45):
					yield(heal_player(1, "red", 100), "completed")
					yield(draw_cards(1), "completed")
				else:
					yield(heal_player(1, "red", 50), "completed")
func effect_5(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(heal_player(1, "green", 40), "completed")
			if get_player1_points()["green"] < 300:
				yield(heal_player(1, "green", get_player1_points()["green"]), "completed")
			if is_on_board(89):
				yield(damage_player(2, "blue", get_player2_points()["blue"]/2), "completed")
func effect_6(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"hero_played":
			if player_trigger == 1:
				yield(random_summon_enemy_spell(1), "completed")
		"dead":
			meta_rset_id(Network.opponent, "polenta_flag", false)
			for color in ["blue","green","red"]:
				for index in [0,1,2]:
					if get_player1_heros_cards()[color][index] == 1:
						yield(kill_hero(1, color, index), "completed")
			for color in ["blue","green","red"]:
				for index in [0,1,2]:
					if get_player2_heros_cards()[color][index] == 1:
						yield(kill_hero(2, color, index), "completed")
			meta_rset_id(Network.opponent, "polenta_flag", true)
func effect_7(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(damage_player(2, "blue", 50), "completed")
			yield(heal_player(1, "blue", 50), "completed")
			var hand1 = get_player1_hand_cards()
			var hand2 = get_player2_hand_cards()
			var temp_hand1 = hand1.duplicate(true)
			var temp_hand2 = hand2.duplicate(true)
			while 0 in temp_hand1:
				temp_hand1.erase(0)
			while 0 in temp_hand2:
				temp_hand2.erase(0)
			if temp_hand1.size() == 10 or temp_hand2.size() == 0:
				return
			randomize()
			var randint = randi()%temp_hand2.size()
			var temp_card = temp_hand2[randint]
			var index1 = get_player2_hand_cards().find(temp_card)
			var index2 = get_player1_hand_cards().find(0)
			change_player2_hand_card(index1, 0)
			change_player1_hand_card(index2, temp_card)
			update_hand_cards()
			rpc_id(Network.opponent,"update_hand_cards")
func effect_8(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			randomize()
			var random_hero = $Board_Stuff.get_color_heros("red")[randi()%$Board_Stuff.get_color_heros("red").size()]
			yield(random_summon_hero(random_hero, "red"), "completed")
		"tease":
			yield(damage_player(2, "red", 40), "completed")
			yield(heal_player(1, "red", 40), "completed")
func effect_9(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			randomize()
			yield(random_summon_spell(10), "completed")
			yield(get_tree().create_timer(0.5), "timeout")
			yield(random_summon_spell(10), "completed")
		"tease":
			yield(damage_player(2, "red", get_player2_points()["red"]/2), "completed")
func effect_10(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			yield(heal_player(1, "blue", 15), "completed")
func effect_11(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if color_activating == "green":
				yield(kill_hero(2, "green", pos_activating), "completed")
		"dead":
			if color_activating == "red":
				yield(heal_player(1, "red", 100), "completed")
		"tease":
			yield(heal_player(1, "green", 40), "completed")
			yield(heal_player(1, "red", 40), "completed")
func effect_12(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			yield(heal_player(1, "green", 15), "completed")
			yield(damage_player(1, "blue", 15), "completed")
		"dead":
			yield(damage_player(2, "blue", 40), "completed")
func effect_13(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"hero_teased":
			if ((player_trigger == 1) and (color_trigger == color_activating) and (pos_trigger == pos_activating)):
				yield(activate_single_effect("tease", 1, "heros", color_trigger, pos_trigger), "completed")
func effect_14(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(add_to_hand(1, 15), "completed")
			yield(add_to_hand(1, 16), "completed")
			yield(add_to_hand(1, 18), "completed")
			yield(add_to_deck(17), "completed")
func effect_15(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			if is_on_board(14) and is_on_board(16) and is_on_board(18):
				yield(damage_player(2, "blue", 40), "completed")
				yield(heal_player(1, "blue", 40), "completed")
func effect_16(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			if is_on_board(14) and is_on_board(15) and is_on_board(18):
				yield(damage_player(2, "blue", 30), "completed")
				yield(heal_player(1, "blue", 30), "completed")
func effect_17(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(heal_player(1, "blue", 150), "completed")
			yield(heal_player(2, "green", 50), "completed")
func effect_18(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			if is_on_board(14) and is_on_board(15) and is_on_board(16):
				yield(damage_player(2, "blue", 30), "completed")
				yield(heal_player(1, "blue", 30), "completed")
func effect_19(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			yield(heal_player(1, "green", 15), "completed")
			for spot in find_on_board(50):
				yield(kill_hero(spot["player"], spot["color"], spot["pos"]), "completed")
func effect_20(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(kill_spell(2, color_activating, pos_activating), "completed")
			yield(damage_player(1, "red", 150), "completed")
			yield(damage_player(2, "red", 150), "completed")
func effect_21(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for player in [1]:
				for color in ["blue","green","red"]:
					for pos in [0,1,2]:
						yield(kill_spell(player, color, pos), "completed")
			yield(draw_cards(3), "completed")
func effect_22(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"dead":
			yield(heal_player(1, "green", 80),"completed")
			randomize()
			var random_hero = $Board_Stuff.get_color_heros("green")[randi()%$Board_Stuff.get_color_heros("green").size()]
			yield(summon_hero(random_hero, "green", pos_activating), "completed")
func effect_23(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	var str_this = pos2str({"player":1, "zone": "spells", "color": color_activating, "pos":pos_activating})
	match type_of_effect:
		"played":
			var hero = {"blue": 24, "green": 25, "red": 26}[color_activating]
			var a = yield(random_summon_hero(hero), "completed")
			if a == null:
				return
			var str_that = pos2str({"player": 1, "zone": "heros",  "color": a["color"], "pos": a["pos"]})
			add_effect(1, "pal" + str_this, str_that)
		"dead":
			cards_effects.erase("pal" + str_this)
		"end_turn":
			for card in cards_effects["pal" + str_this]:
				var hero_dict = str2pos(card)
				yield(damage_hero(hero_dict["player"], hero_dict["color"], hero_dict["pos"], 3) , "completed")
func effect_24(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"tease":
			yield(heal_player(1, "blue", 30), "completed")
		"dead":
			randomize()
			var spots = get_heros_spots(2)
			if spots.size() > 0:
				var spot = spots[randi()%spots.size()]
				yield(kill_hero(2, spot["color"], spot["pos"]), "completed")
func effect_25(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"tease":
			yield(heal_player(2, "green", get_player2_points()["green"]), "completed")
			yield(damage_player(2, "blue", 30), "completed")
			yield(damage_player(2, "red", 30), "completed")
func effect_26(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"tease":
			yield(heal_player(1, "red", 40), "completed")
			yield(heal_player(2, "red", 40), "completed")
		"killing_hero":
			if player_trigger == 1 and color_trigger == "red" and (!get_player1_heros_cards()[color_trigger][pos_trigger] == 26):
				meta_rset_id(Network.opponent, "kill_confirmation_flag", false)
		"dead":
			yield(check_deaths(), "completed")
func effect_27(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"tease":
			if 67 in cards_deck:
				cards_deck.erase(67)
				update_deck()
				yield(add_to_hand(1, 67), "completed")
			else:
				yield(add_to_deck(67) ,"completed")
		"dead":
			if randi()%2 == 0:
				yield(random_summon_hero(27), "completed")
func effect_28(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			var color = ["blue", "green", "red"][randi()%3]
			while true:
				var objective = randi() % $Board_Stuff.objective_list_dict.size() + 1
				if (not objective in objective_numbers.values()) and ($Board_Stuff.objective_list_dict[objective]["color"]) == color:
					objective_numbers[color] = objective
					if color in completed_objectives:
						completed_objectives.erase(color)
					break
			meta_rset_id(Network.opponent, "completed_objectives", completed_objectives)
			meta_rset_id(Network.opponent, "objective_numbers", objective_numbers)
			yield(get_tree().create_timer(0.5), "timeout")
			rpc_id(Network.opponent,"load_objective_cards")
			load_objective_cards()
		"tease":
			var color = ["blue", "green", "red"][randi()%3]
			while true:
				var objective = randi() % $Board_Stuff.objective_list_dict.size() + 1
				if (not objective in objective_numbers.values()) and ($Board_Stuff.objective_list_dict[objective]["color"]) == color:
					objective_numbers[color] = objective
					if color in completed_objectives:
						completed_objectives.erase(color)
					break
			meta_rset_id(Network.opponent, "completed_objectives", completed_objectives)
			meta_rset_id(Network.opponent, "objective_numbers", objective_numbers)
			yield(get_tree().create_timer(0.5), "timeout")
			rpc_id(Network.opponent,"load_objective_cards")
			load_objective_cards()
func effect_29(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for color in ["red", "green", "blue"]:
				for pos in [0,1,2]:
					var card = get_player1_heros_cards()[color][pos]
					if !(card == 0) and get_player1_heros_life()[color][pos] < load_card(card)["vita"]:
						yield(set_hero(1, color, pos, load_card(card)["vita"]), "completed")
			for color in ["red", "green", "blue"]:
				for pos in [0,1,2]:
					yield(damage_hero(2, color, pos, 3), "completed")
		"tease":
			yield(heal_player(1, "green", 100), "completed")
			yield(heal_player(2, "green", 100), "completed")
func effect_30(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for player in [1,2]:
				for pos in [0,1,2]:
					yield(heal_hero(player, "blue", pos, 4), "completed")
			for player in [1,2]:
				for pos in [0,1,2]:
					yield(damage_hero(player, "green", pos, 4), "completed")
			var card = 0
			for pos in [0,1,2]:
				card = get_player1_spells_cards()["blue"][pos]
				if !(card == 0) and get_player1_spells_life()["blue"][pos] < load_card(card)["vita"]:
					yield(set_spell(1, "blue", pos, load_card(card)["vita"]), "completed")
			for pos in [0,1,2]:
				card = get_player2_spells_cards()["blue"][pos]
				if !(card == 0) and get_player2_spells_life()["blue"][pos] < load_card(card)["vita"]:
					yield(set_spell(2, "blue", pos, load_card(card)["vita"]), "completed")
			for player in [1,2]:
				for pos in [0,1,2]:
					yield(kill_spell(player, "green", pos), "completed")
func effect_31(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			var flag = false
			flag = yield(kill_hero(1, "red", pos_activating), "completed")
			if flag == true:
				yield(heal_player(1, "red", 35), "completed")
			flag = yield(kill_hero(2, "red", pos_activating), "completed")
			if flag == true:
				yield(heal_player(1, "red", 35), "completed")
			flag = yield(kill_spell(2, "red", pos_activating), "completed")
			if flag == true:
				yield(heal_player(1, "red", 35), "completed")
func effect_32(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			yield(heal_player(1, "green", 30), "completed")
		"begin_turn":
			yield(damage_player(1, "blue", 10), "completed")
		"tease":
			for player in [1,2]:
				for pos in [0,1,2]:
					yield(activate_single_effect("tease", player, "heros", "red", pos), "completed")
func effect_33(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(heal_player(1, "green", 30), "completed")
			yield(heal_player(1, "blue", 30), "completed")
func effect_34(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"attacking_hero":
			if player_trigger == 2 and color_activating == color_trigger and pos_activating == pos_trigger:
				meta_rset_id(Network.opponent, "attacking_confirmation_flag", false)
		"killing_hero":
			if player_trigger == 1 and color_activating == color_trigger and pos_activating == pos_trigger and is_on_board(29):
				meta_rset_id(Network.opponent, "kill_confirmation_flag", false)
		"tease":
			yield(add_to_hand(1, 4), "completed")
func effect_35(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"begin_turn":
			if get_player1_points()["green"] < 100 and get_player1_points()["blue"] > 450:
				yield(heal_player(1, "blue", 150), "completed")
				yield(kill_spell(1, color_activating, pos_activating), "completed")
			else:
				yield(add_to_hand(1, 38), "completed")
func effect_36(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for card in get_heros_spots(1):
				if not card["color"] == "red":
					yield(kill_hero(1, card["color"], card["pos"]), "completed")
			for card in get_heros_spots(2):
				if not card["color"] == "red":
					yield(kill_hero(2, card["color"], card["pos"]), "completed")
			for card in get_spells_spots(1):
				if not card["color"] == "red":
					yield(kill_spell(1, card["color"], card["pos"]), "completed")
			for card in get_spells_spots(2):
				if not card["color"] == "red":
					yield(kill_spell(2, card["color"], card["pos"]), "completed")
		"tease":
			yield(heal_player(1, "red", get_player1_points()["red"]), "completed")
func effect_37(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"begin_turn":
			yield(heal_player(1, "green", 40), "completed")
			yield(damage_player(1, "blue", 10), "completed")
		"dead":
			yield(damage_player(1, "red", 50), "completed")
func effect_38(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(heal_player(1, "blue", 50), "completed")
			yield(damage_player(1, "green", 50), "completed")
func effect_39(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			if color_activating == "blue":
				yield(heal_player(1, "blue", 15), "completed")
				yield(activate_single_effect("tease", 1, "heros", color_activating, pos_activating), "completed")
			elif color_activating == "green":
				var power = get_heros_spots(1, "green").size() + get_spells_spots(1, "green").size()
				yield(heal_player(1, "green", power * 10), "completed")
			elif color_activating == "red":
				yield(heal_player(1, "red", 15), "completed")
		"damaging_hero":
			if player_trigger == 1 and color_trigger == "red" and pos_activating == pos_trigger:
				meta_rset_id(Network.opponent, "damage_hero_confirmation_flag", false)
				yield(get_tree().create_timer(0.1), "timeout")
func effect_40(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(heal_player(1, "red", 50), "completed")
			yield(heal_player(1, "blue", 10), "completed")
func effect_41(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for i in range (10):
				var random_card = $Board_Stuff.get_all_events()[randi()%$Board_Stuff.get_all_events().size()]
				yield(random_summon_spell(random_card), "completed")
		"tease":
			for i in range (3): 
				var random_card = $Board_Stuff.get_all_events()[randi()%$Board_Stuff.get_all_events().size()]
				yield(random_summon_spell(random_card), "completed")
func effect_42(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played": 
			var num1 = get_player1_points()["red"]
			var num2 = get_player1_points()["green"]
			yield(set_player(1, "red", 0), "completed")
			yield(set_player(1, "green", 0), "completed")
			yield(heal_player(1, "blue", num1 + num2), "completed")
		"tease":
			yield(add_to_hand(1, get_name_card("Zona studio")), "completed")
func effect_43(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			if color_activating == "blue":
				yield(heal_player(1, "blue", 40), "completed")
				yield(damage_player(1, "green", 40), "completed")
			elif color_activating == "green":
				yield(heal_player(1, "green", 40), "completed")
				yield(damage_player(1, "blue", 40), "completed")
func effect_44(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			var bit_coins = get_spells_spots(1).size() + get_spells_spots(2).size()
			yield(heal_player(1, "blue", bit_coins * 30), "completed")
		"tease":
			yield(add_to_hand(1, get_name_card("Indizio piccolo")), "completed")
			yield(add_to_hand(1, get_name_card("Indizio medio")), "completed")
			yield(add_to_hand(1, get_name_card("Indizio grande")), "completed")
func effect_45(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			randomize()
			while !(get_hand1_empty_space() == -1):
				var red_list = $Board_Stuff.get_color_heros("red") + $Board_Stuff.get_color_spells("red")
				var random_card = red_list[randi()%red_list.size()]
				yield(add_to_hand(1, random_card), "completed")
		"tease":
			var num = 0
			for card in get_player1_hand_cards():
				if "red" in load_card(card)["colori"]:
					num += 1
			yield(heal_player(1, "red", num * 25), "completed")
func effect_46(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			randomize()
			var pietanze = $Board_Stuff.get_pietanze()
			var count = 0
			for player in [1,2]:
				for color in ["blue","green","red"]:
					for pos in [0,1,2]:
						if yield(kill_spell(player, color, pos), "completed") == true:
							count += 1
			yield(get_tree().create_timer(DEFAULT_WAIT_TIME), "timeout")
			for i in range(count):
				var random_pietanza = pietanze[randi()%pietanze.size()]
				yield(random_summon_card(random_pietanza), "completed")
		"tease":
			var pietanze = $Board_Stuff.get_pietanze()
			var count = 0
			for color in ["blue","green","red"]:
				for pos in [0,1,2]:
					if get_player1_heros_cards()[color][pos] in pietanze:
						count +=1
					if get_player1_spells_cards()[color][pos] in pietanze:
						count +=1
			yield(get_tree().create_timer(DEFAULT_WAIT_TIME), "timeout")
			for i in range(count):
				var random_pietanza = pietanze[randi()%pietanze.size()]
				rpc_id(Network.opponent,"zoom_card", random_pietanza)
				zoom_card(random_pietanza)
				yield(get_tree().create_timer(DEFAULT_WAIT_TIME), "timeout")
				yield(random_summon_card(random_pietanza), "completed")
func effect_47(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for card in get_heros_spots(2):
				var num = get_player2_heros_cards()[card["color"]][card["pos"]]
				if load_card(num)["nome"].count("s") > 0:
					yield(kill_hero(2, card["color"], card["pos"]), "completed")
			for card in get_spells_spots(2):
				var num = get_player2_spells_cards()[card["color"]][card["pos"]]
				if load_card(num)["nome"].count("s") > 0:
					yield(kill_spell(2, card["color"], card["pos"]), "completed")
		"tease":
			var counter = 0
			for card in get_heros_spots(2):
				var num = get_player2_heros_cards()[card["color"]][card["pos"]]
				counter += load_card(num)["nome"].count("s")
			for card in get_spells_spots(2):
				var num = get_player2_spells_cards()[card["color"]][card["pos"]]
				counter += load_card(num)["nome"].count("s")
			for card in get_heros_spots(1):
				var num = get_player1_heros_cards()[card["color"]][card["pos"]]
				counter += load_card(num)["nome"].count("s")
			for card in get_spells_spots(1):
				var num = get_player1_spells_cards()[card["color"]][card["pos"]]
				counter += load_card(num)["nome"].count("s")
			yield(heal_player(2, "green", counter * 10), "completed")
func effect_48(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"healing_player":
			if not color_trigger == "blue":
				meta_rset_id(Network.opponent, "heal_player_confirmation_flag", false)
		"tease":
			yield(heal_player(1, "blue", 100), "completed")
func effect_49(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"tease":
			randomize()
			var random_girl = $Board_Stuff.get_girls()[randi()%$Board_Stuff.get_girls().size()]
			yield(random_summon_hero(random_girl), "completed")
		"end_turn":
			for color in ["blue","green","red"]:
				for pos in [0,1,2]:
					if get_player1_heros_cards()[color][pos] in $Board_Stuff.get_girls():
						yield(add_to_hand(1, 29), "completed")
func effect_50(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(random_summon_spell(72), "completed")
			yield(random_summon_spell(84), "completed")
			yield(random_summon_spell(85), "completed")
		"tease":
			yield(add_to_hand(1, [72, 84, 85][randi()%3]), "completed")
func effect_51(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			var counter = 0
			var index = 0
			while cards_deck.size() > 0 and counter < 3:
				var card = cards_deck[index]
				if load_card(card)["tipo"] == "hero":
					rpc_id(Network.opponent, "play_sound", "draw")
					play_sound("draw")
					cards_deck.remove(index)
					meta_rset_id(Network.opponent, "cards_deck", cards_deck)
					yield(random_summon_hero(card), "completed")
					counter += 1
				else:
					index += 1
		"tease":
			yield(heal_player(1, "red", 20 * get_heros_spots(1, "red").size()), "completed")
func effect_52(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(heal_player(1, color_activating, 50), "completed")
func effect_53(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if color_activating == "red":
				for color in ["red", "green", "blue"]:
					for pos in [0,1,2]:
						yield(add_effect(2, "frozen_pos", pos2str({"player":2, "zone":"heros", "color": color, "pos" : pos})), "completed")
				yield(heal_player(1, "red", 10), "completed")
			else:
				for color in ["blue", "green", "red"]:
					for pos in [0,1,2]:
						var dict = {"player" : 1, "zone" : "heros", "color": color, "pos" : pos}
						yield(add_effect(1, "charge", dict), "completed")
						yield(attack(color, pos), "completed")
						yield(remove_effect(1, "charge", dict), "completed")
				yield(heal_player(1, "green", 10), "completed")
func effect_54(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			var hand1 = get_player1_hand_cards()
			var hand2 = get_player2_hand_cards()
			var temp_hand1 = hand1.duplicate(true)
			var temp_hand2 = hand2.duplicate(true)
			while 0 in temp_hand1:
				temp_hand1.erase(0)
			while 0 in temp_hand2:
				temp_hand2.erase(0)
			if temp_hand1.size() == 10 or temp_hand2.size() == 0:
				return
			randomize()
			var randint = randi()%temp_hand2.size()
			var temp_card = temp_hand2[randint]
			var index1 = get_player2_hand_cards().find(temp_card)
			var index2 = get_player1_hand_cards().find(0)
			change_player2_hand_card(index1, 0)
			change_player1_hand_card(index2, temp_card)
			update_hand_cards()
			rpc_id(Network.opponent,"update_hand_cards")
			yield(get_tree().create_timer(DEFAULT_WAIT_TIME), "timeout")
func effect_55(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			for pos in [0,1,2]:
				yield(damage_hero(2, "green", pos, 3), "completed")
			yield(heal_player(2, "green", 50) , "completed")
func effect_56(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			if color_activating == "red":
				yield(heal_player(1, "red", 30) , "completed")
			else:
				yield(heal_player(1, "green", 100) , "completed")
				yield(damage_player(1, "blue", 50) , "completed")
				yield(kill_spell(1, color_activating, pos_activating) , "completed")
func effect_57(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"begin_turn":
			for color in ["blue", "green", "red"]:
				for pos in [0,1,2]:
					if load_card(get_player1_heros_cards()[color][pos])["vita"] > get_player1_heros_life()[color][pos]:
						yield(heal_hero(1, color, pos, 3) , "completed")
						yield(damage_spell(1, color_activating, pos_activating, 1) , "completed")
func effect_58(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			if get_player1_points()["green"] > 500:
				yield(heal_player(1, "green",75) , "completed")
func effect_59(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for spot in find_on_board(27):
				yield(kill_hero(spot["player"], spot["color"], spot["pos"]), "completed")
			for spot in find_on_board(28):
				yield(kill_hero(spot["player"], spot["color"], spot["pos"]), "completed")
		"tease":
			yield(damage_player(2, "red", 60), "completed")
			yield(heal_player(1, "red", 60), "completed")
func effect_60(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			if color_activating == "blue":
				yield(add_to_hand(1, [40, 38, 33][randi()%3]), "completed")
			else:
				yield(heal_player(1, "green", 50) , "completed")
				yield(add_to_hand(1, [40, 38, 33][randi()%3]), "completed")
				yield(add_to_hand(1, [40, 38, 33][randi()%3]), "completed")
				yield(kill_spell(1, color_activating, pos_activating), "completed")
func effect_61(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			yield(heal_player(1, "green", 30) , "completed")
		"dead":
			if coin_flip() == 0:
				yield(draw_cards(1), "completed")
			else:
				for i in range(3):
					var spots1 = get_heros_spots(1)
					var spots2 = get_heros_spots(2)
					var size = spots1.size() + spots2.size()
					if size > 0:
						var num = randi()%size
						if num < spots1.size():
							var spot = spots1[num]
							yield(kill_hero(1, spot["color"], spot["pos"]), "completed")
						else:
							var spot = spots2[num - spots1.size()]
							yield(kill_hero(2, spot["color"], spot["pos"]), "completed")
func effect_62(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"begin_turn":
			if color_activating == "blue":
				yield(damage_player(1, "red", 25) , "completed")
				yield(damage_player(1, "green", 25) , "completed")
				yield(damage_player(2, "red", 25) , "completed")
				yield(damage_player(2, "green", 25) , "completed")
		"played":
			if color_activating == "green":
				yield(damage_player(1, "blue", 100) , "completed")
				yield(damage_player(2, "blue", 100) , "completed")
				for spot in find_on_board(42):
					yield(kill_hero(spot["player"], spot["color"], spot["pos"]), "completed")
				yield(kill_spell(1, color_activating, pos_activating), "completed")
func effect_63(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if get_player1_points()["blue"] >= 600:
				yield(random_summon_hero(34), "completed")
		"tease":
			yield(heal_player(1, "blue", 50) , "completed")
			yield(draw_cards(1) , "completed")
func effect_64(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for color in ["red", "green", "blue"]:
				for pos in [0,1,2]:
					var card = get_player1_spells_cards()[color][pos]
					if !(card == 0) and get_player1_spells_life()[color][pos] < load_card(card)["vita"]:
						yield(set_spell(1, color, pos, load_card(card)["vita"]), "completed")
		"tease":
			yield(heal_player(1, "blue", 50), "completed")
			for spot in find_on_board(34):
				if yield(kill_hero(spot["player"], spot["color"], spot["pos"]), "completed"):
					yield(draw_cards(3) , "completed")
func effect_65(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"tease":
			yield(get_tree().create_timer(DEFAULT_WAIT_TIME), "timeout")
func effect_66(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			var spots1 = get_heros_spots(1, color_activating)
			var spots2 = get_heros_spots(2, color_activating)
			var size = spots1.size() + spots2.size()
			while size > find_on_board(66).size():
				var num = randi()%size
				if num < spots1.size():
					var spot = spots1[num]
					var hero = get_player1_heros_cards()[color_activating][spot]
					if hero == 66:
						continue
					change_player_1_heros_card(color_activating, pos_activating, 0)
					yield(summon_hero(hero, color_activating, pos_activating), "completed")
					return
				else:
					var spot = spots2[num - spots1.size()]
					var hero = get_player2_heros_cards()[color_activating][spot]
					if hero == 66:
						continue
					change_player_1_heros_card(color_activating, pos_activating, 0)
					yield(summon_hero(hero, color_activating, pos_activating), "completed")
					return
				spots1 = get_heros_spots(1, color_activating)
				spots2 = get_heros_spots(2, color_activating)
				size = spots1.size() + spots2.size()
func effect_67(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for item in [22, 54, 55, 75, 76]:
				if !(item in get_player1_hand_cards()):
					return
			yield(get_tree().create_timer(1.0), "timeout")
			win_game()
		"dead":
			yield(add_to_deck(68), "completed")
		"tease":
			yield(add_to_hand(1, [22, 54, 55, 75, 76][randi()%5]), "completed")
func effect_68(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if get_player1_points()["red"] >= 600:
				yield(add_to_hand(1, 31), "completed")
		"tease":
			yield(heal_player(1, "red", 50), "completed")
			yield(draw_cards(1), "completed")
func effect_69(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"attacking_hero":
			if attacking_value <= 2:
				meta_rset_id(Network.opponent, "attacking_value", 1)
			else:
				meta_rset_id(Network.opponent, "attacking_value", attacking_value - 2)
		"tease":
			if get_player1_points()["green"] < 600:
				yield(random_summon_hero([8,9][randi()%2]), "completed")
func effect_70(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if get_player1_points()["green"] < 600:
				for pos in [0,1,2]:
					if not pos == pos_activating:
						yield(kill_hero(1, "green", pos), "completed")
		"tease":
			yield(damage_player(2, "green", 70), "completed")
			yield(heal_player(1, "green", 70), "completed")
			yield(draw_cards(1), "completed")
func effect_71(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if get_player1_points()["red"] < 250:
				yield(set_player(1, "red", 250), "completed")
		"tease":
			if get_player1_points()["red"] >= 500:
				yield(add_to_hand(1, 72), "completed")
func effect_72(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		#Per l'effetto uso zone_activating per mettere la quantità
		"healed_player":
			if color_trigger == "red":
				yield(no_triggers_heal_player(player_trigger, color_trigger, zone_trigger), "completed")
func effect_73(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if get_heros_spots(1, "green").size() + get_spells_spots(1, "green").size() <= 1:
				yield(random_summon_hero(73, "green"), "completed")
		"tease":
			yield(heal_player(1, "green", 40 * find_on_board(73).size()), "completed")
func effect_74(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	var str_this = pos2str({"player":1, "zone": "spells", "color": color_activating, "pos":pos_activating})
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			yield(random_summon_spell(12), "completed")
			yield(random_summon_enemy_spell(12), "completed")
			for card in find_on_board(12):
				if coin_flip() == 0:
					yield(kill_spell(card["player"], card["color"], card["pos"]), "completed")
func effect_75(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"attacking_hero":
			if color_trigger == color_activating and pos_trigger == pos_activating:
				meta_rset_id(Network.opponent, "attacking_value", attacking_value + 5)
				yield(get_tree().create_timer(0.5), "timeout")
func effect_76(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"begin_turn":
			if not get_player1_heros_cards()[color_activating][pos_activating] == 0:
				yield(damage_hero(1, color_activating, pos_activating, 4), "completed")
				return
			if not get_player2_heros_cards()[color_activating][pos_activating] == 0:
				yield(damage_hero(2, color_activating, pos_activating, 4), "completed")
				return
			if not get_player2_spells_cards()[color_activating][pos_activating] == 0:
				yield(damage_spell(2, color_activating, pos_activating, 4), "completed")
				return
func effect_77(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"hero_played":
			if player_trigger == 1 and color_activating == color_trigger:
				yield(heal_hero(1, color_trigger, pos_trigger, 4), "completed")
				yield(damage_spell(1, color_activating, pos_activating, 1), "completed")
func effect_78(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"healed_player":
			if color_trigger == "green":
				show_bolt(1, zone_activating, color_activating, pos_activating, true)
				var random_card = $Board_Stuff.get_all_events()[randi()%$Board_Stuff.get_all_events().size()]
				zoom_card(random_card)
				rpc_id(Network.opponent, "zoom_card", random_card)
				yield(get_tree().create_timer(0.5), "timeout")
				yield(random_summon_spell(random_card), "completed")
				show_bolt(1, zone_activating, color_activating, pos_activating, false)
func effect_79(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"healed_player":
			if color_trigger == "blue":
				show_bolt(1, zone_activating, color_activating, pos_activating, true)
				rpc_id(Network.opponent, "draw_cards", 1)
				yield(get_tree().create_timer(0.5), "timeout")
				yield(draw_cards(1), "completed")
				show_bolt(1, zone_activating, color_activating, pos_activating, false)
func effect_80(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			if get_player1_points()["blue"] < 300:
				yield(set_player(1, "blue", 300), "completed")
			else:
				yield(heal_player(1, "green", 100), "completed")
				var spots = get_heros_spots(1)
				if spots.size() > 0:
					var spot = spots[randi()%spots.size()]
					yield(kill_hero(1, spot["color"], spot["pos"]), "completed")
func effect_81(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"begin_turn":
			if get_player1_points()["blue"] < 300:
				yield(add_to_hand(1, 80), "completed")
		"enemy_begin_turn":
			if get_player2_points()["blue"] < 300:
				yield(add_to_hand(2, 80), "completed")
func effect_82(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"dead":
			for color in ["blue", "green", "red"]:
				for pos in [0,1,2]:
					yield(kill_hero(1, color, pos), "completed")
					yield(kill_hero(2, color, pos), "completed")
func effect_83(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"played":
			for alcolico in $Board_Stuff.get_alcolici():
				for spot in find_on_board(alcolico):
					if spot["player"] == 1:
						yield(add_to_hand(1, $Board_Stuff.get_alcolici()[randi()%$Board_Stuff.get_alcolici().size()]), "completed")
						yield(add_to_hand(1, $Board_Stuff.get_alcolici()[randi()%$Board_Stuff.get_alcolici().size()]), "completed")
						yield(add_to_hand(1, $Board_Stuff.get_alcolici()[randi()%$Board_Stuff.get_alcolici().size()]), "completed")
						return
		"tease":
			yield(random_summon_spell($Board_Stuff.get_alcolici()[randi()%$Board_Stuff.get_alcolici().size()]), "completed")
func effect_84(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			var life = get_player1_spells_life()[color_activating][pos_activating]
			if life == 3:
				for color in ["blue", "green", "red"]:
					for pos in [0,1,2]:
						yield(damage_hero(1, color, pos, 4), "completed")
						yield(damage_hero(2, color, pos, 4), "completed")
			elif life == 2:
				yield(damage_player(1, "green", get_player1_points()["green"]/2), "completed")
				yield(damage_player(1, "red", get_player1_points()["red"]/2), "completed")
			else:
				yield(draw_cards(2),"completed")
func effect_85(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"begin_turn":
			yield(heal_player(1, "green", 30), "completed")
			yield(damage_player(1, "blue", 15), "completed")
func effect_86(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"begin_turn":
			yield(random_summon_spell($Board_Stuff.get_giochi()[randi()%$Board_Stuff.get_giochi().size()]), "completed")
		"end_turn":
			yield(random_summon_spell($Board_Stuff.get_giochi()[randi()%$Board_Stuff.get_giochi().size()]), "completed")
		"tease":
			yield(add_to_hand(1, $Board_Stuff.get_giochi()[randi()%$Board_Stuff.get_giochi().size()]), "completed")
func effect_87(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"begin_turn":
			var counter = 0 
			for card in get_heros_spots(2):
				var num = get_player2_heros_cards()[card["color"]][card["pos"]]
				yield(damage_hero(2, card["color"], card["pos"], 1), "completed")
				counter += 1
			for card in get_heros_spots(1):
				var num = get_player1_heros_cards()[card["color"]][card["pos"]]
				yield(damage_hero(1, card["color"], card["pos"], 1), "completed")
				counter += 1
			yield(heal_hero(1, color_activating, pos_activating, counter), "completed")
		"enemy_begin_turn":
				var counter = 0 
				for card in get_heros_spots(2):
					var num = get_player2_heros_cards()[card["color"]][card["pos"]]
					yield(damage_hero(2, card["color"], card["pos"], 1), "completed")
					counter += 1
				for card in get_heros_spots(1):
					var num = get_player1_heros_cards()[card["color"]][card["pos"]]
					yield(damage_hero(1, card["color"], card["pos"], 1), "completed")
					counter += 1
				yield(heal_hero(1, color_activating, pos_activating, counter), "completed")
		"tease":
			yield(add_to_hand(1, 13), "completed")
func effect_88(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	if not player_trigger == 1:
		return
	match type_of_effect:
		"hero_played":
			yield(heal_player(1, "blue", 10), "completed")
		"event_played":
			yield(heal_player(1, "blue", 10), "completed")
		"spell_played":
			yield(heal_player(1, "blue", 10), "completed")
func effect_89(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"end_turn":
			for card in get_heros_spots(2):
				var num = get_player2_heros_cards()[card["color"]][card["pos"]]
				if randi()%4 == 0:
					yield(kill_hero(2, card["color"], card["pos"]), "completed")
			for card in get_spells_spots(2):
				var num = get_player2_spells_cards()[card["color"]][card["pos"]]
				if randi()%4 == 0:
					yield(kill_spell(2, card["color"], card["pos"]), "completed")
		"tease":
			yield(random_summon_spell(74), "completed")
			yield(add_to_hand(1, 74) , "completed")
func effect_90(type_of_effect, zone_activating, color_activating, pos_activating, player_trigger, zone_trigger, color_trigger, pos_trigger):
	yield(get_tree(), "idle_frame")
	match type_of_effect:
		"attacking_hero":
			if player_trigger == 2:
				meta_rset_id(Network.opponent, "attacking_confirmation_flag", false)
				yield(damage_hero(1, color_activating, pos_activating, attacking_value), "completed")
		"tease":
			yield(heal_player(1, "red", 10 * get_player1_heros_life()[color_activating][pos_activating]), "completed")




































