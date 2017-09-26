extends RigidBody2D

onready var road = get_node("/root/level/road")
onready var blade = get_node("blade")
onready var compass = get_node("compass")
onready var kills = get_node("kills")
var bladeSpin = 0
var score = 0

func _ready():
	set_process(true)
	set_process_input(true)
	var bounds = get_node("/root/level/ground").get_region_rect()
	get_node("camera").set_limit(0,bounds.pos.x)
	get_node("camera").set_limit(1,bounds.pos.y)
	get_node("camera").set_limit(2,bounds.end.x)
	get_node("camera").set_limit(3,bounds.end.y)

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
	speed = clamp(speed,-555 + bladeSpin * 3,250)
	set_linear_velocity(Vector2(sin(angle),cos(angle)) * speed)
	
	bladeSpin -= bladeSpin * delta
	blade.rotate(bladeSpin * delta)
	
	compass.set_global_rot(0)
	
	kills.set_text("%d" % score)
	
func _input(event):
	if (event.is_action_pressed("ui_accept")): bladeSpin = -15
