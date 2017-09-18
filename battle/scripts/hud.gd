extends Sprite

onready var health = get_node("health")
onready var player = get_node("/root/level/actors/player")
onready var heads = get_node("friends/heads")
onready var cornerPos = get_node("friends/corner").get_pos()
onready var dispenser = get_node("friends/dispenser")
var healthDimensions

func _ready():
	set_process(true)
	healthDimensions = health.get_texture().get_size()

func _process(delta):
	health.set_region_rect(Rect2(0,0,healthDimensions.x * player.health,healthDimensions.y))
	
	for head in heads.get_children():
		var angle = head.get_rot()
		angle += (randf() * 4 - 2) * delta
		head.set_rot(angle)
		var pos = head.get_pos() - Vector2(sin(angle),cos(angle))
		
		if (pos.x < 0): pos.x = cornerPos.x
		if (pos.y < 0): pos.y = cornerPos.y
		if (pos.x > cornerPos.x): pos.x = 0
		if (pos.y > cornerPos.y): pos.y = 0
		head.set_pos(pos)
	
	var pos = dispenser.get_pos()
	pos.x += player.velocity.x * delta
	if (pos.x < 0): pos.x = 0
	if (pos.x > cornerPos.x): pos.x = cornerPos.x
	dispenser.set_pos(pos)
