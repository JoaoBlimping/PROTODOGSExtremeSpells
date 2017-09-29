extends Node

var inventory = []
var switches = {}
var town = null
var area = null

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

func drive(map,from):
	town = from
	get_tree().change_scene("res://overworld/scenes/%s.tscn" % map)

func battle(map):
	setSwitch(map,true)
	get_tree().change_scene("res://battle/scenes/%s.tscn" % map)

func battled(map):
	return getSwitch(map)

func finishBattle():
	get_tree().change_scene("res://adventure/scenes/%s.tscn" % area)

func enterAdventure(map):
	area = map
	get_tree().change_scene("res://adventure/scenes/%s.tscn" % area)