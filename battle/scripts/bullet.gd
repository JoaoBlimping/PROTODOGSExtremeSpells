extends StaticBody2D

export var speed = 150
export (String) var sound

var owner = null
var velocity = Vector2(0,0)

func _ready():
	add_to_group("bullet")

func retarget(angle,newSpeed = null):
	if (newSpeed == null): newSpeed = speed
	velocity.x = -sin(angle) * newSpeed
	velocity.y = -cos(angle) * newSpeed

func damp(multiplier):
	velocity *= multiplier