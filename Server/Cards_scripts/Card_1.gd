#Extends BMCard class, which contains variables and methods common to all cards
extends "res://BMCard.gd"

#Called when a new istance of the card is created
func _init(): 
	id = 1
	card_name = 'Eleonora'
	families = ['Alcolico', 'Professore']
	type = 'hero'
	attack = 10
	health = 9
	cost = 5
	quantity = 1
	playable_colors = ['blue', 'green', 'red']
	card_text = """[center]Quando questo eroe muore, se si trovava nella zona rossa guadagni 50 di libido

Quando questo eroe viene evocato, se si trova nella zona follia, uccide il servitore davanti.

Dispetto: raddoppia la tua libido"""
	
	deck_signals = []
	board_signals = []
	hand_signals = []
	grave_signals = []
	
	
	

