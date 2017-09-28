extends Sprite

export var health = 3
export var speed = 0
var velocity = Vector2(0,0)


func _ready():
s	var playerPos = get_node("/root/pool/fogle").get_pos()
	var angle = get_pos().angle_to_point(playerPos)
	velocity.x = -sin(angle) * speed
	velocity.y = -cos(angle) * speed
	set_process(true)

func _process(delta):
	var pos = get_pos()
	set_pos(get_pos() + velocity * delta) 

func _on_body_body_enter(body):
	if (body.is_in_group("pisse")):
		body.get_parent().queue_free()
		health -= 1
		if (health == 0): queue_free()
