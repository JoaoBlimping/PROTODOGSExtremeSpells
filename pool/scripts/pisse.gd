extends Sprite

onready var bounds = get_viewport().get_rect().size




func _ready():
	set_process(true)

func _process(delta):
	var pos = get_pos()
	while pos.x > bounds.x: pos.x -= bounds.x
	while pos.y > bounds.y: pos.y -= bounds.y
	while pos.x < 0: pos.x += bounds.x
	while pos.y < 0: pos.y += bounds.y
	pos.x += (randf() * 400 - 200) * delta
	pos.y += (randf() * 400 - 200) * delta
	set_pos(pos)
