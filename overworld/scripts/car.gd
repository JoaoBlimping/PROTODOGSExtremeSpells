extends "bug.gd"

var offroad = false
export var health = 3
var angle = 0

func control(delta):
	var angleToPlayer = get_pos().angle_to_point(player.get_pos())
	angle = angleToPlayer
	velocity = Vector2(sin(angle),cos(angle)) * -speed

func hit(body):
	level.get_node("sound").play("splat")
	player.get_node("blade/particle").set_emitting(true)
	var playerSpeed = player.get_linear_velocity().length()
	if (body == player):
		level.hurt += 2
		player.score += abs(playerSpeed / 10)
	else:
		player.score += 5 + abs(playerSpeed / 10)
	
	health -= 1
	if (health == 0):
		queue_free()