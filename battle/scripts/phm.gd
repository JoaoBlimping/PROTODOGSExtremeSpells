extends "head.gd"

onready var player = get_node("../../../../actors/player")


func power():
	player.health += 1
