extends "actor.gd"

const NORMAL_SPEED = 222
const STRAFE_SPEED = 129

onready var sounds = get_node("sounds")
onready var heart = get_node("hitbox/heart")
onready var bullet = load("res://battle/objects/fogleBullet.tscn")
onready var dispenser = get_node("/root/level/hud/friends/dispenser")


const TICK = 0.0105
var timer = 0
var hurting = -1


func _ready():
	attack()


func hit(body):
	if (hurting < 0):
		if (.hit(body)):
			sounds.play("ow")
			hurting = 1
			set_blend_mode(BLEND_MODE_ADD)
		else:
			body.set_pos(dispenser.get_global_pos())
	
	
func die():
	get_tree().change_scene("res://menu/scenes/gameover.tscn")
	

func attack():
	health = 3
	var tick = createTimer(TICK)
	
	while (true):
		yield(tick,"timeout")
		
		hurting -= TICK
		if (hurting < 0):
			set_blend_mode(BLEND_MODE_MIX)
		
		
		#strafing
		var speed = NORMAL_SPEED
		var spread = 0.4
		if (Input.is_action_pressed("ui_select")):
			spread = 0.7
			speed = STRAFE_SPEED
			heart.show()
		else:
			heart.hide()
		
		#shooting
		if (Input.is_action_pressed("ui_accept")):
			timer -= TICK
			if (timer < 0):
				timer += 0.08
				shoot(bullet,randf() * spread - spread / 2)
		
		
		
		#moving
		velocity.x = 0
		velocity.y = 0
		if (Input.is_action_pressed("ui_left")): velocity.x = -speed
		if (Input.is_action_pressed("ui_right")): velocity.x = speed
		if (Input.is_action_pressed("ui_up")): velocity.y = -speed
		if (Input.is_action_pressed("ui_down")): velocity.y = speed