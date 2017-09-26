extends Area2D

onready var room = get_node("/root/room")
onready var global = get_node("/root/global")

export var realName = "Inanimate Object"
export var autorun = false
export (String) var birthSwitch = null
export (String) var deathSwitch = null


func _ready():
	connect("input_event",self,"click")
	if (birthSwitch != null && !global.getSwitch(birthSwitch)): queue_free()
	elif (deathSwitch != null && global.getSwitch(deathSwitch)): queue_free()
	elif (autorun): room.call_deferred("run",get_name(),self)

func click(viewport,event,shape_idx):
	if (event.is_action_pressed("ui_accept") && room.running == null):
		room.run(get_name(),self)
