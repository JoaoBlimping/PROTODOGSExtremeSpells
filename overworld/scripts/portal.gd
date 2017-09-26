extends Sprite

onready var player = get_node("/root/level/bus")

export(String, FILE) var destination

func _ready():
	get_node("hitbox").connect("body_enter",self,"hit")

func hit(body):
	if (body == player): get_tree().change_scene(destination)