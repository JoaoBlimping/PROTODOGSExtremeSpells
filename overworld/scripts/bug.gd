extends Area2D

export var speed = 1000
export var maximum = 500
onready var player = get_node("/root/level/bus")
onready var level = get_node("/root/level")
var velocity = Vector2(0,0)

func _ready():
	set_process(true)

func _process(delta):
	control(delta)
	set_pos(get_pos() + velocity * delta)
	set_rot(player.get_rot())

func hit(body):
	queue_free()
	level.get_node("sound").play("splat")
	player.get_node("blade/particle").set_emitting(true)
	var speed = player.get_linear_velocity().length()
	if (body == player):
		level.hurt += 2
		player.score += abs(speed / 10)
	else:
		player.score += 5 + abs(speed / 10)

func control(delta):
	velocity = velocity.clamped(maximum)
	var pos = get_pos()
	var playerPos = player.get_pos()
	if (pos.distance_to(playerPos) < 250):
		velocity.x = (playerPos.x - pos.x) + (randf() * speed - speed/2) * delta
		velocity.y = (playerPos.y - pos.y) + (randf() * speed - speed/2) * delta
	else:
		velocity.x += (randf() * speed - speed/2) * delta
		velocity.y += (randf() * speed - speed/2) * delta