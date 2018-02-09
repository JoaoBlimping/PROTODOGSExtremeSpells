extends "head.gd"

onready var eel = load("res://battle/objects/eel.tscn")
onready var player = get_node("../../../../actors/player")
onready var actors = get_node("../../../../actors")


func power():
	for actor in actors.get_children():
		if (actor != player):
			var ib = eel.instance()
			actors.add_child(ib)
			ib.set_pos(actor.get_pos())