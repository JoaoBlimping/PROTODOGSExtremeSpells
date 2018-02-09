extends Sprite

onready var GoodTimer = preload("res://battle/scripts/GoodTimer.gd")
onready var Mover = preload("res://battle/scripts/Mover.gd")
onready var SoundWaiter = preload("res://battle/scripts/SoundWaiter.gd")
onready var sound = get_node("sound")
onready var animation = get_node("animation")
onready var bullets = get_node("../../bulletStuff/bullets")
onready var bulletSounds = get_node("../../bulletStuff/bulletSounds")

const T = "timeout"
const M = "moved"
const S = "soundDone"

export var flippy = false
export var walky = false
export var target = true
export var speed = 100

var velocity = Vector2(0,0)
var health = 1

var routines = []
var finished = false


# built in function which is used to set up some event thingies
func _ready():
	set_process(true)
	var hitbox = get_node("hitbox")
	hitbox.connect("body_enter",self,"hit")


# built in function which controls routines and animation
func _process(delta):
	if (finished):
		if (routines.size() > 1):
			routines.pop_front()
			call(routines.front())
			finished = false
		else:
			die()
			queue_free()

	#move
	set_pos(get_pos() + velocity * delta)
	if (flippy):
		if (velocity.x < 0): set_flip_h(true)
		if (velocity.x > 0): set_flip_h(false)

	#animate
	if (walky):
		if (velocity.length() == 0): animation.stop()
		elif (!animation.is_playing()):
			animation.play("walk")


# Fires a copy of a given bullet at a given angle, and also optionally from an origin object.
func shoot(bullet,angle,origin=self):
	return shootFrom(bullet,angle,origin.get_global_pos())


# Fires a copy of a given object at a given angle from a given vector position and optionally at a
# given speed, otherwise using the default.
func shootFrom(bullet,angle,location,speed=null):
	var ib = bullet.instance()
	if (ib.sound != null):
		bulletSounds.play(ib.sound)
	ib.owner = self
	bullets.add_child(ib)
	ib.set_pos(location)
	if (speed != null): ib.speed = speed
	ib.velocity.x = -sin(angle) * ib.speed
	ib.velocity.y = -cos(angle) * ib.speed
	return ib


func die():
	if (target): get_node("../..").finish(true)


# This gets called when an actor is hit by a bullet or powerup which is a kind of bullet anyway
func hit(body):
	if (!body.is_in_group("power") && body.owner != self):
		if (randi() % 5 > 3): bullets.addPowerup(body.get_pos())
		body.queue_free()
		health -= 1
		return true
	return false


# This function checks if the actor is out of health and tells you if they are, and at the same time
# if they are out of health it sets them to go to their next routine and blanks all bullets if they
# are a target
func isDone():
	if (health < 1):
		done()
		return true
	else: return false


# Ends the given routine and does all the stuff
func done():
	if (target): yield(bullets.clear(),"cleared")
	finished = true


# Creates a timer which lets you yield for a given amount of time.
func createTimer(time):
	var timer = GoodTimer.new()
	timer.set_wait_time(time)
	timer.start()
	add_child(timer)
	return timer


# Creates a mover which lets you yield until the actor has moved somewhere.
func createMover():
	var mover = Mover.new()
	mover.dude = self
	add_child(mover)
	return mover


# Creates a sound waiter which lets you yield until a sound has played.
func createSoundWaiter(sp):
	var waiter = SoundWaiter.new()
	waiter.sp = sp
	add_child(waiter)
	return waiter


# adds a routine for the actor to perform. the name is the string name of the method to call.
# they are performed in the order that they are added.
func addRoutine(name):
	if (routines.size() == 0): call(name)
	routines.push_back(name)
