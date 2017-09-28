extends Node

onready var textbox = preload("res://adventure/objects/textbox.tscn")
onready var question = preload("res://adventure/objects/question.tscn")
onready var guiNode = get_node("gui")

const NORMAL = 0
const ANGRY = 1

var running = null
var gui = false
var caller = null
var value = null

func _ready():
	set_process(true)

func _process(delta):
	if (!gui && running != null):
		if (running.is_valid()):
			running = running.resume()
		else:
			running = null

func run(code,owner):
	caller = owner
	running = call(code)


func getActive(name):
	if (name != null):
		return get_node("actives/%s" % name)
	return caller
	

func pose(n,name = null):
	var owner = getActive(name)
	if (owner != null): owner.get_node("sprite").set_frame(n)

func give(item):
	get_node("/root/global").setSwitch(item,true)
	say("Got %s!" % item)

func say(text,name = null):
	var ib = textbox.instance()
	var active = getActive(name)
	if (active == null): return
	ib.get_node("name").set_text(active.realName)
	ib.get_node("text").set_text(text)
	guiNode.add_child(ib)
	gui = true


func ask(text,a1,a2,a3 = null,a4 = null,name = null):
	var ib = question.instance()
	ib.get_node("name").set_text(getActive(name).realName)
	ib.get_node("text").set_text(text)
	
	ib.get_node("a").set_text(a1)
	ib.get_node("b").set_text(a2)
	if (a3 == null): ib.get_node("c").free()
	else: ib.get_node("c").set_text(a3)
	if (a4 == null): ib.get_node("d").free()
	else: ib.get_node("d").set_text(a4)
	guiNode.add_child(ib)
	gui = true
	