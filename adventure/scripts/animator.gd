extends Node

signal animated

var room

func _init(room):
	self.room = room

func r(name):
	room.gui = true
	var anim = room.get_node("animation")
	anim.play(name)
	anim.connect("finished",self,"done")
	return self

func done():
	room.gui = false
	emit_signal("animated")