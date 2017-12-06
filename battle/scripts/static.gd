extends "actor.gd"

const TICK = 0.2

export var spin = 5
export var startHealth = 10
export var healthDecay = 0

func _ready():
	addRoutine("main")
	
func main():
	health = startHealth
	var timer = createTimer(TICK)
	while (true):
		yield(timer.r(),"timeout")
		health -= TICK * healthDecay
		rotate(TICK * spin)
		if (isDone()): return
		
