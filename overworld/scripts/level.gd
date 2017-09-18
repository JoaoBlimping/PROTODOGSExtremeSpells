extends Node2D

onready var radio = get_node("radio")
onready var tint = get_node("tint")
onready var player = get_node("cars/bus")
onready var cars = get_node("cars")
onready var signs = get_node("signs").get_children()
onready var car = load("res://overworld/objects/car.tscn")

const talkFile = "res://overworld/songs/radio%d.ogg"
const songFile = "res://overworld/songs/song%d.ogg"
const talks = 3
const songs = 4
const OFFROAD_TIME = 4

var talking = false
var outside = false
var hurt = 0
var blood = Color(1,1,1)
var carTimer = 5

func _ready():
	set_process(true)
	#start the radio
	randomize()
	for i in range(talks):
		load(talkFile % (i + 1))
	for i in range(songs):
		load(songFile % (i + 1))
	play()

func _process(delta):
	var pos = player.get_pos()
	#signs
	for s in signs:
		s.set_rot(player.get_rot())
	
	#cars
	carTimer -= delta
	if (carTimer <= 0):
		carTimer = randf() * 8
		var ib = car.instance()
		var angle = randf() * PI * 2
		ib.set_pos(pos + Vector2(sin(angle),cos(angle)) * 800)
		cars.add_child(ib)
		
	#hurting
	if (outside): hurt += delta
	elif (hurt > 0): hurt -= delta
	blood.g = (OFFROAD_TIME - hurt) / OFFROAD_TIME
	blood.b = (OFFROAD_TIME - hurt) / OFFROAD_TIME
	tint.set_color(blood)
	if (hurt >= OFFROAD_TIME):
		get_tree().change_scene("res://menu/scenes/gameover.tscn")

func play():
	if (talking):
		var num = (randi() % talks) + 1
		radio.set_stream(load(songFile % num))
	else:
		var num = (randi() % songs) + 1
		radio.set_stream(load(talkFile % num))
	talking = !talking
	radio.play()


func _on_crashZone_body_enter(body):
	if (body == player): outside = false
	else: body.offroad = false


func _on_crashZone_body_exit( body ):
	if (body == player): outside = true
	else: body.offroad = true
