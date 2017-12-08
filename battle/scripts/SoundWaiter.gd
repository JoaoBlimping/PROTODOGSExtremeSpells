extends Node

var running = false
var sp = null

signal soundDone

func _ready():
	set_process(true)

func _process(delta):
	if (running && !sp.is_active()):
		running = false
		emit_signal("soundDone")

func r(sound):
	sp.play(sound)
	running = true
	return self