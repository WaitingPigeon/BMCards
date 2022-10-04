extends Node

#---------------------------Permanent (= to be saved) variables---------------------------#
var username = ""
var password = ""

var achievements = []
#---------------------------Temporary (= changing with istance) variables---------------------------#
var status = "offline" #Can be "offline", "lobby" or "playing"
var id = -1
var current_game = null
