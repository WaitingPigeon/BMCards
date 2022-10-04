extends Node

var id = 1 
var card_name = ''
var color = 'blue' #Can be 'blue', 'green' or 'red'
var completed_by = null #Can be null if not completed, or one between 'a' and 'b'
var signals = [] #List of signals the objective will listen to

var game = null #The 'game' variable will contain the game node
func set_game():
	game = get_parent()

func _init():
	for single_signal in signals:
		game.connect(single_signal, self, single_signal)

func disconnect_all_signals():
	for single_signal in signals:
		game.disconnect(single_signal, self, single_signal)
