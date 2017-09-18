extends "actor.gd"

onready var bullet = preload("res://battle/objects/fatBullet.tscn")
onready var player = get_node("/root/level/actors/player")

func _ready():
	routines.push_back("attack")
	routines.push_back("otherAttack")
	routines.push_back("wackAttack")


func attack():
	health = 10
	var timer = 0.3
	
	while (true):
		velocity.x += randf() - 0.5
		velocity.y += randf() - 0.5
		timer -= yield()
		if (timer < 0):
			timer += 0.33
			shoot(bullet,get_pos().angle_to_point(player.get_pos()))

func otherAttack():
	health = 100
	velocity.x = 0
	velocity.y = 0
	var timer = 0
	while (true):
		timer += 1
		shoot(bullet,cos(timer))
		yielding("wait",0.2);yield()

func wackAttack():
	health = 100
	var angle = 0
	while (true):
		angle += 0.5
		shoot(bullet,angle)
		shoot(bullet,angle + PI * 4 / 3)
		shoot(bullet,angle + PI * 2 / 3)
		yielding("wait",0.1);yield()