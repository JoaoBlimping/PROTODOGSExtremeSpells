extends "actor.gd"

onready var bullet = preload("res://battle/objects/fatBullet.tscn")
onready var bullet2 = preload("res://battle/objects/fatBullet2.tscn")
onready var jamBullet = preload("res://battle/objects/jamBullet.tscn")
onready var jam = preload("res://battle/objects/jam.tscn")
onready var player = get_node("../player")

func _ready():
	addRoutine("flirt1")
	addRoutine("donut")
	addRoutine("flirt2")
	addRoutine("discs")
	addRoutine("flirt3")



func donut():
	yield(createSoundWaiter(sound).r("jam"),S)
	animation.play("press")
	health = 100
	velocity.x = 0
	velocity.y = 0
	var donuts = []
	var tick1 = createTimer(2.1)
	var tick2 = createTimer(0.7)
	while (true):
		donuts.append(weakref(shoot(jamBullet,get_pos().angle_to_point(player.get_pos()))))
		yield(tick1.r(),T)
		var mainRef = donuts.back().get_ref()
		if (mainRef): mainRef.damp(0.3)
		for donut in donuts:
			var instance = donut.get_ref()
			if (!instance): continue
			for i in range(4):
				shoot(jam,(PI * 2 / 4) * i + PI,instance)
		yield(tick2.r(),T)
		for donut in donuts:
			var instance = donut.get_ref()
			if (!instance): continue
			for i in range(4):
				shoot(jam,(PI * 2 / 4) * i + PI,instance)
		if (isDone()): return

func discs():
	var tick = createTimer(0.4)
	yield(createMover().r(get_node("../../fatOrigin")),M)
	yield(createSoundWaiter(sound).r("piadina"),S)
	animation.play("press")
	get_node("../../overBackground/animation").play("dissapear")
	health = 100
	while (true):
		var niceBullets = []
		var meanBullets = []
		for i in range(5):
			meanBullets.append(weakref(shoot(bullet,PI * 2 / 5 * i)))
		for i in range(4):
			niceBullets.append(weakref(shoot(bullet2,PI * 2 / 4 * (i + 0.5))))
		yield(tick.r(),T)
		var angle = get_pos().angle_to_point(player.get_pos())
		for bullet in meanBullets:
			var ref = bullet.get_ref()
			if (!ref): continue
			ref.retarget(angle)
		yield(tick.r(),T)
		for bullet in niceBullets:
			var ref = bullet.get_ref()
			if (!ref): continue
			ref.retarget(ref.get_pos().angle_to_point(player.get_pos()))
		if (isDone()): return
		
		
		

func flirt1():
	health = 70
	var angle = 0
	var tick = createTimer(0.1)
	while (true):
		angle += 0.5
		shoot(bullet2,angle)
		shoot(bullet,angle + PI)
		yield(tick.r(),T)
		if (isDone()): return

func flirt2():
	animation.play("still")
	health = 80
	var angle = 0
	var tick = createTimer(0.05)
	while (true):
		velocity = Vector2(cos(angle / 4) * 100,0)
		angle -= 0.2
		shoot(bullet,angle)
		shoot(bullet,angle + PI)
		shoot(bullet2,angle + PI / 2)
		shoot(bullet2,angle + PI * 3 / 2)
		yield(tick.r(),T)
		if (isDone()): return

func flirt3():
	yield(createSoundWaiter(sound).r("swirl"),S)
	health = 100
	var timer = 0
	var tick = createTimer(0.1)
	while (true):
		timer += 0.2
		var angle = cos(timer) * 2 + timer
		velocity = Vector2(cos(timer * 2) * 150,0)
		shoot(bullet,angle)
		shoot(bullet,angle + PI)
		shoot(bullet,angle + PI / 2)
		shoot(bullet,angle + PI * 3 / 2)
		shoot(bullet2,angle + PI / 4)
		shoot(bullet2,angle + PI * 5 / 4)
		shoot(bullet2,angle + PI * 3 / 4)
		shoot(bullet2,angle + PI * 7 / 4)
		yield(tick.r(),T)
		if (isDone()): return