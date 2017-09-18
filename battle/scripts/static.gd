extends "actor.gd"

export var spin = 5
export var startHealth = 10
export var healthDecay = 0

func _ready():
	routines.push_back("main")
	
func main():
	health = startHealth
	while (true):
		var delta = yield()
		health -= delta * healthDecay
		rotate(delta * spin)
		if (health <= 0): die()
		
