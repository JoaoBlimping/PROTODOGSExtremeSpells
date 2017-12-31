extends Node

onready var transition = preload("res://adventure/objects/transition.tscn")
onready var musicPlayer = get_node("/root/musicPlayer")

var mice = {}
var inventory = []
var switches = {}
var town = null
var area = null
var song = null
var filename

func _enter_tree():
	preloadMice()
	preloadSongs()

func restart():
	switches.clear()
	town = null
	area = null

	
func setSwitch(name,value):
	switches[name] = value

func getSwitch(name):
	if (switches.has(name)): return switches[name]
	else: return false

func hasSwitch(name):
	return switches.has(name)

func addToInvetory(name):
	inventory.push_back(name)

func inInventory(name):
	return inventory.count(name) > 0
	
func drive(map,from=null):
	town = from
	get_tree().change_scene("res://overworld/scenes/%s.tscn" % map)

func driveFile(file,from):
	town = from
	get_tree().change_scene(file)

func battle(map):
	setSwitch(map,true)
	var ib = transition.instance()
	var scene = load("res://battle/scenes/%s.tscn" % map)
	get_node("/root/room/gui").add_child(ib)
	playSong("%s" % scene.get_state().get_node_property_value(0,1))
	ib.get_node("anim").connect("finished",get_tree(),"change_scene_to",[scene])

func battled(map):
	return getSwitch(map)

func finishBattle():
	get_tree().change_scene("res://adventure/scenes/%s.tscn" % area)

func enterAdventure(map):
	area = map
	get_tree().change_scene("res://adventure/scenes/%s.tscn" % area)


func preloadMice():
	var dir = Directory.new()
	dir.open("res://mice")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "": break
		elif not file.begins_with("."): mice[file] = {"pic":load("res://mice/%s" % file),"priority":0}
	dir.list_dir_end()

func resetMouse():
	Input.set_custom_mouse_cursor(mice["normal.png"].pic)
	for mouse in mice: mice[mouse].priority = 0

func refreshMouse():
	var best = {"pic":mice["normal.png"].pic,"priority":-1}
	for mouse in mice:
		if (mice[mouse].priority > best.priority):
			best.pic = mice[mouse].pic
			best.priority = mice[mouse].priority
	Input.set_custom_mouse_cursor(best.pic)

func setMouse(type,priority):
	mice[type].priority += priority
	refreshMouse()

func removeMouse(type,priority):
	mice[type].priority -= priority
	refreshMouse()


func preloadSongs():
	var dir = Directory.new()
	dir.open("res://songs")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "": break
		elif not file.begins_with("."): load(file)
	dir.list_dir_end()

func playSong(name,loop=true):
	song = name
	musicPlayer.set_stream(load("res://songs/%s.ogg" % name))
	musicPlayer.set_loop(loop)
	musicPlayer.play()

func stopSong():
	musicPlayer.stop()
	song = null

func getSong():
	return song

func addSongCallback(caller,method):
	musicPlayer.connect("finished",caller,method)

func removeSongCallback(caller,method):
	musicPlayer.disconnect("finished",caller,method)

func joinArray(array):
	var output = ""
	for i in range(array.size()):
		output += array[i] + ("@^@" if i != array.size() - 1 else "")
	return output

func splitArray(string):
	return string.split("@^@")
	

func saveGame():
	var file = File.new()
	file.open("user://losSave%d.pig" % filename,File.WRITE)
	file.store_line(area)
	file.store_line(switches.to_json())
	file.store_line(joinArray(inventory))
	file.close()

func loadGame():
	var file = File.new()
	file.open("user://losSave%d.pig" % filename,File.READ)
	area = file.get_line()
	switches.parse_json(file.get_line())
	inventory = splitArray(file.get_line())
	file.close()
	
	
	