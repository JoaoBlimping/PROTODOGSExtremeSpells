extends "thing.gd"


func _ready():
	pointer = "use"
	if (get_node("/root/global").hasSwitch(realName)):
		queue_free()

func _input(event):
	if (event.is_action_pressed("ui_accept") && room.running == null && !room.gui && poised):
		get_node("/root/global").setSwitch(realName,true)
		room.say("Got %s!" % realName,get_name())
		queue_free()