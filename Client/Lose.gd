extends Node2D

func _ready():
	var player = AudioStreamPlayer.new()
	player.stream = load("res://Resources/Lose.wav")
	add_child(player)
	player.volume_db = Network.sound_volume
	player.play()
	yield(player, "finished")
	remove_child(player)
	Network.opponent = ''
	get_tree().change_scene('res://Lobby.tscn')
