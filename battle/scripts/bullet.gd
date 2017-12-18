extends StaticBody2D

export var speed = 150
export var rotation = 0.0
export (String) var sound

var owner = null
var velocity = Vector2(0,0)
var gravity = Vector2(0,0)

func _ready():
	add_to_group("bullet")

func retarget(angle,newSpeed = null):
	if (newSpeed == null): newSpeed = speed
	velocity.x = -sin(angle) * newSpeed
	velocity.y = -cos(angle) * newSpeed

func gravify(angle,power):
	gravity.x = -sin(angle) * power
	gravity.y = -cos(angle) * power

func damp(multiplier):
	velocity *= multiplier