extends Node

onready var itemSprite = preload("res://adventure/objects/itemSprite.tscn")
onready var animator = preload("animator.gd").new(self)
onready var textbox = preload("res://adventure/objects/textbox.tscn")
onready var question = preload("res://adventure/objects/question.tscn")
onready var bag = preload("res://adventure/objects/bag.tscn")
onready var transition = preload("res://adventure/objects/transition.tscn")
onready var fader = preload("res://adventure/objects/fade.tscn")
onready var global = get_node("/root/global")

const NORMAL = 0
const ANGRY = 1
const EXCITED = 2

export var music = "ambience"

signal animated
signal said

const S = "said"
const A = "animated"

var guiNode
var item = null
var gui = false
var caller = null
var value = null


func _ready():
	set_process_input(true)
	global.resetMouse()
	if (global.getSong() != music): global.playSong(music)
	add_child(bag.instance())
	guiNode = Node2D.new()
	guiNode.set_name("gui")
	add_child(guiNode)
	if (has_method("start")): start()

func run(code,owner):
	caller = owner
	
	if (item == null):
		if (has_method(code)): call(code)
		else: print("uhoh missing function %s" % code)
	else:
		var itemCode = "%s_%s" % [code,item]
		if (has_method(itemCode)):
			call(itemCode)
			if (global.itemProperty(item,"dispose")): global.removeFromInventory(item)
		else: say("%s does nothing here" % item)
		item = null
		get_node("itemSprite").queue_free()


func getActive(name):
	if (name != null):
		return get_node("actives/%s" % name)
	return caller

func useItem(name):
	item = name
	var ib = itemSprite.instance()
	ib.set_texture(global.items[name].texture)
	add_child(ib)
	
##########################################################################################
######################## Functions for using in script ###################################
##########################################################################################
func s(name,change=null):
	if (change == null): return global.getSwitch(name)
	global.setSwitch(name,change)

func ss(name,change=null):
	return s(global.area + ":" + name,change)

func move(map):
	global.enterAdventure(map)

func pose(n,name = null):
	var owner = getActive(name)
	if (owner != null): owner.get_node("sprite").set_frame(n)


func give(item):
	get_node("/root/global").setSwitch(item,true)
	say("Got %s!" % item)

func say(text,name = null,face = null):
	var ib = textbox.instance()
	var active = getActive(name)
	if (active == null): return ib
	ib.get_node("name").set_text(active.realName)
	
	if (face != null):
		ib.setFace(active.get_node("sprite"))
		active.get_node("sprite").set_frame(face)
	
	#make he text nicer
	text = text.replace("\n"," ")
	text = text.replace("~","\n")
	
	#back to work
	ib.get_node("text").set_text(text)
	guiNode.add_child(ib)
	gui = true
	return ib


func ask(text,a1,a2,name = null,a3 = null,a4 = null):
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
	return ib

func animate(anim):
	return animator.r(anim)

func puzzle(filename):
	var puzzle = load("res://adventure/scenes/%s.tscn" % filename).instance()
	var holder = get_node("puzzle")
	if (holder == null):
		print("you're meant to add a puzzle node to set where it'll appear idiota")
		return
	get_node("puzzle").add_child(puzzle)
	gui = true
	return puzzle

func battle(map):
	gui = true
	var ib = transition.instance()
	var scene = load("res://battle/scenes/%s.tscn" % map).instance()
	get_node("/root/room/gui").add_child(ib)
	global.playSong("%s" % scene.song)
	ib.get_node("anim").connect("finished",self,"beginBattle",[scene])
	return scene

func beginBattle(scene):
	get_node("/root/room/gui/transition").queue_free()
	add_child(scene)

func fade(map):
	gui = true
	var ib = fader.instance()
	var scene = load("res://adventure/scenes/%s.tscn" % map).instance()
	get_node("/root/room/gui").add_child(ib)
	ib.get_node("anim").connect("finished",global,"enterAdventure",[map])

func fadeIn():
	gui = true
	var ib = fader.instance()
	get_node("/root/room/gui").add_child(ib)
	ib.get_node("anim").play("enter")
	return ib



##########################################################################################
############################### Item Functions ###########################################
##########################################################################################
func save():
	global.saveGame()
	say("game saved!")

func exit():
	yield(ask("Are you sure you want to quit?","yeah","nah"),S)
	if (value == "a"): get_tree().change_scene("res://menu/scenes/menu.tscn")
	

func tunneler():
	yield(ask("""If you dig a hole with the tunneler, you might not be able to
	get back up, will you continue?""","yeah","nah"),S)
	if (value == "a"): fade("tunnel/1")