extends Sprite

export var speed = Vector2(0,0)

var textureSize = null


func _ready():
	textureSize = get_texture().get_size()
	set_region(true)
	set_region_rect(Rect2(Vector2(0,0),get_viewport_rect().size + textureSize))
	set_process(true)


func _process(delta):
	var offset = get_offset()
	if (offset.x < -textureSize.x): offset.x = 0
	if (offset.y < -textureSize.y): offset.y = 0
	if (offset.x > 0): offset.x = -textureSize.x
	if (offset.y > 0): offset.y = -textureSize.y
	set_offset(offset + speed * delta)
