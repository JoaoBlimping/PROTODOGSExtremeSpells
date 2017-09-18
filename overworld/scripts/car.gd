extends RigidBody2D

onready var player = get_node("../bus")

const SPEED = -600
const OFFROAD_SPEED = -300
var offroad = false


func _ready():
	var mod = Color(randf(),randf(),randf())
	get_node("sprite").set_modulate(mod)
	set_process(true)

func _process(delta):
	var pos = get_pos()
	var playerPos = player.get_pos()
	var angle = pos.angle_to_point(playerPos)
	var angular = get_angular_velocity()
	var rot = get_rot()
	var spin = clamp(angular + (rot - angle) * 46 * delta,-2.5,2.5) + (randf() * 20 - 10) * delta
	set_angular_velocity(spin)
	set_linear_velocity(Vector2(sin(rot),cos(rot)) * (OFFROAD_SPEED if offroad else SPEED))
	
	if (pos.distance_to(playerPos) > 2000):
		queue_free()