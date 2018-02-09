extends Node

onready var musicPlayer = get_node("/root/musicPlayer")

var mice = {}
var items = {}
var inventory = []
var switches = {}
var town = null
var area = null
var song = null
var filename

func _enter_tree():
	preloadMice()
	preloadSongs()
	preloadItems()

func restart():
	switches.clear()
	town = null
	area = null

func preloadItems():
	var file = File.new()
	file.open("res://adventure/items.json",File.READ)
	items.parse_json(file.get_as_text())
	for k in items.keys(): items[k].texture = load("res://adventure/pics/items/%s.png" % k)

	
func setSwitch(name,value):
	switches[name] = value

func getSwitch(name):
	if (switches.has(name)): return switches[name]
	else: return false

func hasSwitch(name):
	return switches.has(name)

func addToInventory(name):
	inventory.push_back(name)

func inInventory(name):
	return inventory.count(name) > 0

func removeFromInventory(name):
	for i in range(inventory.size()):
		if (inventory[i] == name):
			inventory.remove(i)
			return

func itemProperty(item,property):
	var properties = items[item]
	if (properties.has(property)): return properties[property]
	else: return false

func drive(map,from=null):
	town = from
	get_tree().change_scene("res://overworld/scenes/%s.tscn" % map)

func driveFile(file,from):
	town = from
	get_tree().change_scene(file)

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