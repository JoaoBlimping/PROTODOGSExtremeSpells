extends RigidBody2D

const SPEED = -300
var offroad = false


func _ready():
	var mod = Color(randf(),randf(),randf())
	get_node("sprite").set_modulate(mod)
	set_process(true)

func _process(delta):
	var pos = get_pos()
	var angular = get_angular_velocity()
	var rot = get_rot()
	var spin = clamp(angular + ((randf() *  46) - 23) * delta,-2,2)
	set_angular_velocity(spin)
	set_linear_velocity(Vector2(sin(rot),cos(rot)) * (-SPEED if offroad else SPEED))