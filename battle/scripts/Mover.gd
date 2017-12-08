extends Node

var dude = null
var target = null
var going = false

signal moved

func _ready():
	set_process(true)

func _process(delta):
	var angle = dude.get_pos().angle_to_point(target)
	dude.velocity.x = -sin(angle) * dude.speed
	dude.velocity.y = -cos(angle) * dude.speed
	if ((dude.get_pos() - target).length() <= dude.velocity.length() * delta):
		dude.velocity.x = 0
		dude.velocity.y = 0
		emit_signal("moved")

func r(tar):
	target = tar.get_pos()
	going = true
	return self