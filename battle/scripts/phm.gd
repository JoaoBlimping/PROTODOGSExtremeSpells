extends "head.gd"

onready var player = get_node("/root/level/actors/player")


func power():
	player.health += 1
