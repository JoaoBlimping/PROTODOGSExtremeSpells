extends RigidBody2D

onready var tint = get_node("tint")
onready var road = get_node("/root/level/road")

func _ready():
	set_process(true)

func _process(delta):
	var velocity = get_linear_velocity()
	var speed = velocity.length() - delta * 50
	var angle = get_rot()
	if (abs(angle - velocity.angle()) > 0.2): speed = -speed
	var angular = get_angular_velocity()
	if (Input.is_action_pressed("ui_left")): set_angular_velocity(angular - 10 * delta)
	if (Input.is_action_pressed("ui_right")): set_angular_velocity(angular + 10 * delta)
	if (Input.is_action_pressed("ui_up")):  speed -= 250 * delta
	if (Input.is_action_pressed("ui_down")): speed += 300 * delta
	speed = clamp(speed,-555,250)
	set_linear_velocity(Vector2(sin(angle),cos(angle)) * speed)


func _on_bus_body_enter( body ):
	print("tes")
