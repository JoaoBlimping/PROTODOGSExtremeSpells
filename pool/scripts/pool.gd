extends Node

onready var panel = load("res://pool/objects/bar.tscn").instance()
onready var banner = load("res://pool/objects/banner.tscn")
onready var bar = panel.get_node("bar")
onready var pissPen = get_node("piss")

export var requirement = 50
var winCount = -100

func _ready():
	set_process(true)
	add_child(panel)

func _process(delta):
	var nPiss = float(pissPen.get_child_count())
	bar.set_region_rect(Rect2(0,0,nPiss / requirement * 120,16))
	if (nPiss > requirement && winCount == -100):
		winCount = 5
		var ib = banner.instance()
		add_child(ib)
	if (winCount > 0):
		winCount -= delta
	elif (winCount > -100):
		print("end level")
	
	
