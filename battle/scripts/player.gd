extends "actor.gd"

const NORMAL_SPEED = 222
const STRAFE_SPEED = 129

onready var sounds = get_node("sounds")
onready var heart = get_node("hitbox/heart")
onready var bullet = load("res://battle/objects/fogleBullet.tscn")
onready var dispenser = get_node("/root/level/hud/friends/dispenser")


var timer = 0


func _ready():
	routines.push_back("attack")


func hit(body):
	if (.hit(body)):
		sounds.play("ow")
	else:
		body.set_pos(dispenser.get_global_pos())
	
	
func die():
	get_tree().change_scene("res://menu/scenes/gameover.tscn")
	

func attack():
	health = 3
	
	while (true):
		var delta = yield()
		
		#shooting
		if (Input.is_action_pressed("ui_accept")):
			timer -= delta
			if (timer < 0):
				timer += 0.1
				shoot(bullet,randf() / 2 - 0.25)
		
		#strafing
		var speed = NORMAL_SPEED
		if (Input.is_action_pressed("ui_select")):
			speed = STRAFE_SPEED
			heart.show()
		else:
			heart.hide()
		
		#moving
		velocity.x = 0
		velocity.y = 0
		if (Input.is_action_pressed("ui_left")): velocity.x = -speed
		if (Input.is_action_pressed("ui_right")): velocity.x = speed
		if (Input.is_action_pressed("ui_up")): velocity.y = -speed
		if (Input.is_action_pressed("ui_down")): velocity.y = speed