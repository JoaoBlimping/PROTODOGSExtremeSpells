extends "actor.gd"

const NORMAL_SPEED = 222
const STRAFE_SPEED = 129

onready var sounds = get_node("sounds")
onready var heart = get_node("hitbox/heart")
onready var bullet = load("res://battle/objects/fogleBullet.tscn")
onready var dispenser = get_node("../../hud/friends/dispenser")
var bounds


var timer = 0
var hurting = -1


func _ready():
	var lifezone = get_node("../../lifezone")
	bounds = Rect2(lifezone.get_pos(),lifezone.get_node("corner").get_pos())
	health = 3


func hit(body):
	if (body.is_in_group("power")):
		body.set_pos(dispenser.get_global_pos())
	elif (hurting < 0):
		if (.hit(body)):
			sounds.play("ow")
			hurting = 1
			set_blend_mode(BLEND_MODE_ADD)
			
	
	
func die():
	get_tree().change_scene("res://menu/scenes/gameover.tscn")
	

func _process(delta):
	hurting -= delta
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
		timer -= delta
		if (timer < 0):
			timer += 0.1
			shoot(bullet,randf() * spread - spread / 2)
	
	
	#moving
	velocity.x = 0
	velocity.y = 0
	if (Input.is_action_pressed("ui_left")): velocity.x = -speed
	if (Input.is_action_pressed("ui_right")): velocity.x = speed
	if (Input.is_action_pressed("ui_up")): velocity.y = -speed
	if (Input.is_action_pressed("ui_down")): velocity.y = speed
	
	var pos = get_pos()
	
	if (pos.x < bounds.pos.x): pos.x = bounds.pos.x
	if (pos.y< bounds.pos.y): pos.y = bounds.pos.y
	if (pos.x > bounds.pos.x + bounds.size.x): pos.x = bounds.pos.x + bounds.size.x
	if (pos.y > bounds.pos.y + bounds.size.y): pos.y = bounds.pos.y + bounds.size.y
	set_pos(pos)