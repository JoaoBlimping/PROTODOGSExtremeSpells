extends Node2D

onready var screen = get_viewport().get_rect()
onready var power = load("res://battle/objects/power.tscn")
var lifeRect = null

func _ready():
	set_process(true)
	var lifezone = get_node("/root/level/lifezone")
	lifeRect = Rect2(lifezone.get_pos(),lifezone.get_node("corner").get_pos())
	
func _process(delta):
	var bullets = get_children()
	
	for bullet in bullets:
		var pos = bullet.get_pos()
		bullet.set_pos(bullet.get_pos() + bullet.velocity * delta)
		if (!lifeRect.has_point(pos)):
			if (!bullet.is_in_group("power") || !screen.has_point(pos)):
				bullet.queue_free()

func addPowerup(pos):
	var ib = power.instance()
	ib.add_to_group("power")
	add_child(ib)
	ib.set_pos(pos)
	ib.velocity.x = 0
	ib.velocity.y = 100
