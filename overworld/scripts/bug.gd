extends Area2D

const SPEED = 1000
const MAX = 500
onready var player = get_node("/root/level/bus")
onready var level = get_node("/root/level")
var velocity = Vector2(0,0)

func _ready():
	set_process(true)

func _process(delta):
	velocity = velocity.clamped(MAX)
	var pos = get_pos()
	var playerPos = player.get_pos()
	if (pos.distance_to(playerPos) < 250):
		velocity.x = (playerPos.x - pos.x) * (randf() + 0.2) + (randf() * 10 - 5) * delta
		velocity.y = (playerPos.y - pos.y) * (randf() + 0.2) + (randf() * 10 - 5) * delta
	else:
		velocity.x += (randf() * SPEED - SPEED/2) * delta
		velocity.y += (randf() * SPEED - SPEED/2) * delta
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
