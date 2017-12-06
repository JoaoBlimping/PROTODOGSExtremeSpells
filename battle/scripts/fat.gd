extends "actor.gd"

onready var bullet = preload("res://battle/objects/fatBullet.tscn")
onready var bullet2 = preload("res://battle/objects/fatBullet2.tscn")
onready var jamBullet = preload("res://battle/objects/jamBullet.tscn")
onready var jam = preload("res://battle/objects/jam.tscn")
onready var player = get_node("/root/level/actors/player")

func _ready():
	routines.push_back("flirt1")
	routines.push_back("donut")
	routines.push_back("flirt2")
	routines.push_back("discs")
	routines.push_back("flirt3")



func donut():
	health = 100
	velocity.x = 0
	velocity.y = 0
	var donuts = []
	while (true):
		donuts.append(weakref(shoot(jamBullet,get_pos().angle_to_point(player.get_pos()))))
		yielding("wait",2);yield()
		var mainRef = donuts.back().get_ref()
		if (mainRef): mainRef.damp(0.3)
		for donut in donuts:
			var instance = donut.get_ref()
			if (!instance): continue
			for i in range(4):
				shoot(jam,(PI * 2 / 4) * i + PI,instance)
		yielding("wait",0.7);yield()
		for donut in donuts:
			var instance = donut.get_ref()
			if (!instance): continue
			for i in range(4):
				shoot(jam,(PI * 2 / 4) * i + PI,instance)

func discs():
	health = 100
	get_node("/root/level/overBackground/animation").play("dissapear")
	yielding("moveTo",get_node("/root/level/fatOrigin"));yield()
	while (true):
		var niceBullets = []
		var meanBullets = []
		for i in range(6):
			niceBullets.append(weakref(shoot(bullet2,PI * 2 / 6 * i)))
			meanBullets.append(weakref(shoot(bullet,PI * 2 / 6 * (i + 0.5))))
		yielding("wait",0.5);yield()
		var angle = get_pos().angle_to_point(player.get_pos())
		for bullet in meanBullets:
			var ref = bullet.get_ref()
			if (!ref): continue
			ref.retarget(angle)
		yielding("wait",0.5);yield()
		for bullet in niceBullets:
			var ref = bullet.get_ref()
			if (!ref): continue
			ref.retarget(ref.get_pos().angle_to_point(player.get_pos()))
		
		
		

func flirt1():
	health = 100
	var angle = 0
	while (true):
		angle += 0.5
		shoot(bullet2,angle)
		shoot(bullet,angle + PI)
		yielding("wait",0.1);yield()

func flirt2():
	health = 100
	var angle = 0
	while (true):
		velocity = Vector2(cos(angle / 4) * 100,0)
		angle -= 0.2
		shoot(bullet,angle)
		shoot(bullet,angle + PI)
		shoot(bullet2,angle + PI / 2)
		shoot(bullet2,angle + PI * 3 / 2)
		yielding("wait",0.05);yield()

func flirt3():
	health = 100
	var timer = 0
	while (true):
		timer += 0.2
		var angle = cos(timer) * 2 + timer
		shoot(bullet,angle)
		shoot(bullet,angle + PI)
		shoot(bullet,angle + PI / 2)
		shoot(bullet,angle + PI * 3 / 2)
		shoot(bullet2,angle + PI / 4)
		shoot(bullet2,angle + PI * 5 / 4)
		shoot(bullet2,angle + PI * 3 / 4)
		shoot(bullet2,angle + PI * 7 / 4)
		yielding("wait",0.1);yield()