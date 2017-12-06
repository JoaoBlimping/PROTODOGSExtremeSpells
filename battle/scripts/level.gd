extends Node2D

export var song = "battle"

func _ready():
	var global = get_node("/root/global")
	if (global.getSong() != song): global.playSong(song)