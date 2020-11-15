extends Node

var current_chapter;
var chapters = {
	0:{
		"nome" : "0) Introduzione",
		"path" : "Chapter0"
		},
	1:{
		"nome" : "1) Il campo da gioco",
		"path" : "Chapter1"
		},
	2:{
		"nome" : "2) Eroi",
		"path" : "Chapter2"
		},
	3:{
		"nome" : "3) Oggetti Magici ed Eventi",
		"path" : "Chapter3"
		},
	4:{
		"nome" : "4) Turno di gioco",
		"path" : "Chapter4"
		},
	5:{
		"nome" : "5) Obiettivi",
		"path" : "Chapter5"
		}
	}

func _ready():
	open_chapter(0)
	pass # Replace with function body. 



func open_chapter(i) :
	get_node(chapters[i]["path"]).visible = true
	current_chapter=i

func close_chapter(i):
	get_node(chapters[i]["path"]).visible = false
	current_chapter=-1

func _on_Back_to_login_pressed():
	get_tree().change_scene("res://Login.tscn")


func _on_Chapters_ready():
	for i in chapters:
		$Chapters.add_item(chapters[i]["nome"])


func _on_Chapters_item_selected(index):
	close_chapter(current_chapter)
	open_chapter(index)
