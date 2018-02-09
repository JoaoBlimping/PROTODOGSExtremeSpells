extends "thing.gd"


func _ready():
	pointer = "use"
	call_deferred("testDeath")

func testDeath():
	if (room.ss("_"+get_name())): queue_free()

func _input(event):
	if (event.is_action_pressed("ui_accept") && !room.gui && poised):
		global.addToInventory(realName)
		room.ss("_"+get_name(),true)
		room.say("Got %s!" % realName,get_name())
		queue_free()