extends Node

onready var animator = preload("animator.gd")
onready var textbox = preload("res://adventure/objects/textbox.tscn")
onready var question = preload("res://adventure/objects/question.tscn")
onready var inventory = preload("res://adventure/objects/inventory.tscn")
onready var guiNode = get_node("gui")
onready var global = get_node("/root/global")

const NORMAL = 0
const ANGRY = 1

export var music = "ambience"

signal animated
signal said

const S = "said"
const A = "animated"

var gui = false
var caller = null
var value = null


func _ready():
	set_process_input(true)
	global.resetMouse()
	if (global.getSong() != music): global.playSong(music)
	if (has_method("start")): start()



func _input(event):
	if (event.is_action_pressed("ui_select") && !gui):
		var ib = inventory.instance()
		guiNode.add_child(ib)
		gui = true


func run(code,owner):
	caller = owner
	call(code)


func getActive(name):
	if (name != null):
		return get_node("actives/%s" % name)
	return caller

##########################################################################################
######################## Functions for using in script ###################################
##########################################################################################
func pose(n,name = null):
	var owner = getActive(name)
	if (owner != null): owner.get_node("sprite").set_frame(n)


func give(item):
	get_node("/root/global").setSwitch(item,true)
	say("Got %s!" % item)

func say(text,name = null):
	var ib = textbox.instance()
	var active = getActive(name)
	if (active == null): return ib
	ib.get_node("name").set_text(active.realName)
	
	#make he text nicer
	text = text.replace("\n"," ")
	text = text.replace("~","\n")
	
	#back to work
	ib.get_node("text").set_text(text)
	guiNode.add_child(ib)
	gui = true
	return ib


func battle(name):
	gui = true
	global.battle(name)


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

func createAnimator():
	return animator.new(self)
	
	

##########################################################################################
############################### Item Functions ###########################################
##########################################################################################
func save_machine():
	global.saveGame()
	say("game saved!");yield()

func tunneler():
	ask("""If you dig a hole with the tunneler, you might not be able to
	get back up, will you continue?""","yeah","nah"); yield()
	if (value == "a"): global.enterAdventure("tunnel/1")