extends Node2D

onready var radio = get_node("radio")
onready var sound = get_node("sound")
onready var tint = get_node("tint")
onready var player = get_node("bus")
onready var signs = get_node("signs").get_children()
onready var bugs = [preload("res://overworld/objects/bug1.tscn"),preload("res://overworld/objects/bug2.tscn")]

const talkFile = "res://overworld/songs/radio%d.ogg"
const songFile = "res://overworld/songs/song%d.ogg"
const talks = 3
const songs = 4
const OFFROAD_TIME = 4
const N_FIENDS = 1000
var talking = false
var outside = false
var hurt = 0
var blood = Color(1,1,1)

func _ready():
	set_process(true)
	
	#start the radio
	randomize()
	for i in range(talks):
		load(talkFile % (i + 1))
	for i in range(songs):
		load(songFile % (i + 1))
	call_deferred("play")
	
	#add cars
	var bounds = get_node("ground").get_region_rect()
	for c in range(N_FIENDS):
		var ib = bugs[randi() % 2].instance()
		var angle = randf() * PI * 2
		ib.set_pos(Vector2(randf() * bounds.size.x,randf() * bounds.size.y))
		add_child(ib)
	
	#move the player
	var global = get_node("/root/global")
	if (global.town != null):
		var exit = get_node("portals/%s/exit" % global.town)
		player.set_pos(exit.get_global_pos())
		player.set_rot(exit.get_global_rot())

func _process(delta):
	var pos = player.get_pos()
	#signs
	for s in signs:
		s.set_rot(player.get_rot())
		
	#hurting
	if (outside): hurt += delta
	elif (hurt > 0): hurt -= delta * 0.8
	blood.g = (OFFROAD_TIME - hurt) / OFFROAD_TIME
	blood.b = (OFFROAD_TIME - hurt) / OFFROAD_TIME
	tint.set_color(blood)
	if (hurt >= OFFROAD_TIME):
		get_tree().change_scene("res://menu/scenes/gameover.tscn")

func play():
	if (talking):
		var num = (randi() % songs) + 1
		print(num)
		radio.set_stream(load(songFile % num))
	else:
		var num = (randi() % talks) + 1
		radio.set_stream(load(talkFile % num))
	talking = !talking
	radio.play()


func _on_crashZone_body_enter(body):
	if (body == player): outside = false


func _on_crashZone_body_exit(body):
	if (body == player): outside = true
	sound.play("crash")
	
