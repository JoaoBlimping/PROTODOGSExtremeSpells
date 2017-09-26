extends Node

onready var panel = load("res://pool/objects/bar.tscn").instance()
onready var bar = panel.get_node("bar")
onready var pissPen = get_node("piss")

export var requirement = 50

func _ready():
	set_process(true)
	add_child(panel)

func _process(delta):
	bar.set_region_rect(Rect2(0,0,float(pissPen.get_child_count()) / requirement * 120,16))
	
	
