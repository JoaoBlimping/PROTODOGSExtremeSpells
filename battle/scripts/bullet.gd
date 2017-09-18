extends StaticBody2D

export var speed = 150
export (String) var sound

var owner = null
var velocity = Vector2(0,0)

func _ready():
	add_to_group("bullet")