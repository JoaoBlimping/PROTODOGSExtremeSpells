extends "thing.gd"


func _ready():
	if (get_node("/root/global").hasSwitch(realName)):
		queue_free()

func click(viewport,event,shape_idx):
	if (event.is_action_pressed("ui_accept") && room.running == null && !room.gui):
		get_node("/root/global").setSwitch(realName,true)
		room.say("Got %s!" % realName,get_name())
		queue_free()
