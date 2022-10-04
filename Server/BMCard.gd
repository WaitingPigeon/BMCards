extends Node
#----------------------------Generic variables----------------------------#

var id = 0 
var card_name = ''
var families = [] #For example food, 
var type = '' #Can be 'hero', 'spell' or 'event'
var quantity = 3 
var playable_colors = [] #Can be 'blue', 'green' or 'red'
var card_text = ''

#----------------------------Position variables----------------------------#

var place = null  #Can be deck, board, hand or grave
var player = null #Can be 'a' or 'b'
var board_type = null #Can be 'heros' or 'spells (or null if the card is in the deck, hand or grave)
var board_color = null #Can be 'blue', 'green' or 'red' (or null if the card is in the deck, hand or grave)
var board_pos = null #Can be 'left', 'center' or right (or null if the card is in the deck, hand or grave) 

#-----------------------------Ingame variables-----------------------------#

var conditions = {} #es. "frozen", "immortal" etc.
var health = 0
var attack = 0
var cost = 0

#----------------------------------Signals----------------------------------#
var deck_signals = [] #Signals that the card listens for when it is in the deck
var board_signals = [] # // // in someone's board
var hand_signals = [] # // // in someone's hand
var grave_signals = [] # // // in the grave
#------------------------------Other variables------------------------------#

var game = null #The 'game' variable will contain the game node

#------------------------------Generic methods------------------------------#
#Called when a new instance is created 
func _init():
	pass

#Called by the game node when it creates the card
func set_game():
	game = get_parent()

func set_loc(loc):
	#We disconnect signal connections from previous place
	if not place == null:
		for single_signal in get(place + "_signals"):
			game.disconnect(single_signal, self, single_signal)
			
	#We change loc variables
	place = loc["place"] if "place" in loc else null
	player = loc["player"] if "player" in loc else null
	board_type = loc["board_type"] if "board_type" in loc else null
	board_color = loc["board_color"] if "board_color" in loc else null
	board_pos = loc["board_pos"] if "board_pos" in loc else null
	
	#We set new connection
	if not place == null:
		for single_signal in get(place + "_signals"):
			game.connect(single_signal, self, single_signal)
	
