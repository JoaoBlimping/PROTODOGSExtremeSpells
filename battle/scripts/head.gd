extends Sprite

export var limit = 5
export var portraitFrame = 0

onready var sound = get_node("/root/level/hud/sound")
onready var portrait = get_node("/root/level/hud/leftPanel/portrait")
onready var particles = get_node("/root/level/actors/player/particles")

var power = 0

func _ready():
	var hud = get_node("/root/level/hud")
	var hitbox = get_node("hitbox")
	hitbox.connect("body_enter",self,"hit")


func hit(body):
	body.queue_free()
	power += 1
	if (power == limit):
		power = 0
		portrait.set_frame(portraitFrame)
		portrait.get_node("animation").play("fade")
		particles.set_emitting(true)
		sound.play(get_name())
		power()
