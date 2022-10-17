extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Accendo la lobby")

func _on_Login_button_pressed():
	print(Network.my_id)
