extends Sprite

onready var sound = get_node("sound")
onready var animation = get_node("animation")
onready var bullets = get_node("/root/level/bullets")
onready var bulletSounds = get_node("/root/level/bulletSounds")

export var flippy = false
export var walky = false
export var target = true

var velocity = Vector2(0,0)
var health = 1

var routines = []
var activity = []
var activityOffset = 0



func _ready():
	set_process(true)
	var hitbox = get_node("hitbox")
	hitbox.connect("body_enter",self,"hit")


func _process(delta):
	#do the activity
	if (activity.size() == 0):
		if (routines.size() == 0):
			queue_free()
			if (target): get_node("/root/global").finishBattle()
		else:
			activity.push_front(call(routines[0]))
			routines.pop_front()
		return
	else:
		activityOffset = 0
		var completed = activity[0].resume(delta)
		activity[activityOffset] = completed
		
		if (activityOffset == 0 && (completed == null || !completed.is_valid())):
			activity.pop_front()
	
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


func shoot(bullet,angle,origin=self):
	var ib = bullet.instance()
	if (ib.sound != null):
		bulletSounds.play(ib.sound)
	ib.owner = self
	bullets.add_child(ib)
	ib.set_pos(origin.get_pos())
	ib.velocity.x = -sin(angle) * ib.speed
	ib.velocity.y = -cos(angle) * ib.speed


func hit(body):
	if (!body.is_in_group("power") && body.owner != self):
		if (randi() % 5 > 3): bullets.addPowerup(body.get_pos())
		body.queue_free()
		health -= 1
		if (health <= 0): die()
		return true
	return false


func die():
	activity.clear()


func yielding(function,arg):
	activity.push_front(call(function,arg))
	activityOffset += 1

##########################################################################################
############ YIelding thingies ###########################################################
##########################################################################################
func wait(time):
	var count = 0
	var n = 0
	while (count + (count / n if (n > 2) else 0) < time):
		count += yield()
		n += 1


func waitSound(sample):
	if (sound == null): return
	sound.play(sample)
	yielding("wait",sound.get_sample_library().get_sample(sample).get_length()) 