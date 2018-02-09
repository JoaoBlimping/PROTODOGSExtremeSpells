extends Area2D

onready var room = get_node("/root/room")
onready var global = get_node("/root/global")


export var realName = "AIIIIIIEEEEEEEEE"
export(String, "move", "talk", "use") var pointer = "move"
export (String) var birthSwitch = null
export (String) var deathSwitch = null
export (String) var birthSelfSwitch = null
export (String) var deathSelfSwitch = null
var poised = false


func _ready():
	connect("mouse_enter",self,"enter")
	connect("mouse_exit",self,"exit")
	set_process_input(true)
	call_deferred("testDeath")

func _input(event):
	if (event.is_action_pressed("ui_accept") && !room.gui && poised):
		room.run(get_name(),self)
		get_tree().set_input_as_handled()

func testDeath():
	if (birthSwitch != null && !room.s(birthSwitch)): queue_free()
	elif (deathSwitch != null && room.s(deathSwitch)): queue_free()
	elif (birthSelfSwitch != null && !room.ss(birthSelfSwitch)): queue_free()
	elif (deathSelfSwitch != null && room.ss(deathSelfSwitch)): queue_free()

func enter():
	poised = true
	global.setMouse("%s.png" % pointer,get_index() + 1)

func exit():
	poised = false
	global.removeMouse("%s.png" % pointer,get_index() + 1)

func queue_free():
	if (poised): global.removeMouse("%s.png" % pointer,get_index() + 1)
	.queue_free()
