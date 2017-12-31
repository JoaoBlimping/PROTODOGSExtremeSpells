extends Sprite

onready var player = get_node("/root/level/bus")

export(String, FILE) var destination
export var driving = true

func _ready():
	get_node("hitbox").connect("body_enter",self,"hit")

func hit(body):
	if (body == player):
		if (driving): get_node("/root/global").driveFile(destination,get_node("/root/level").title)
		else: global.enterAdventure(destination.right(23).split(".")[0])