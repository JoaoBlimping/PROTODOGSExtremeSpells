extends Sprite

onready var pissPen = get_node("/root/pool/piss")
onready var pisse = load("res://pool/objects/pisse.tscn")
onready var bounds = get_viewport().get_rect().size
onready var sound = get_node("sound")
var speed = 200
var timer = 0.2
var health = 5

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	var velocity = Vector2(0,0)
	if (Input.is_action_pressed("ui_up")): velocity.y = -speed
	if (Input.is_action_pressed("ui_down")): velocity.y = speed
	if (Input.is_action_pressed("ui_left")): velocity.x = -speed
	if (Input.is_action_pressed("ui_right")): velocity.x = speed
	var pos = get_pos()
	while pos.x > bounds.x: pos.x -= bounds.x
	while pos.y > bounds.y: pos.y -= bounds.y
	while pos.x < 0: pos.x += bounds.x
	while pos.y < 0: pos.y += bounds.y
	set_pos(pos + velocity * delta)
	
	if (velocity.length() > 0): timer -= delta
	if (timer <= 0):
		sound.play("pisse")
		timer += randf() / 4
		var ib = pisse.instance()
		ib.set_pos(get_pos())
		pissPen.add_child(ib)
			


func _on_body_body_enter(body):
	body.get_parent().free()
	health -= 1
	sound.play("fuck")
	if (health <= 0):
		print("dead")
