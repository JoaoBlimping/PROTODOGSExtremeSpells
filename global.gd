extends Node

var switches = {}
var town = null

	
func setSwitch(name,value):
	switches[name] = value

func getSwitch(name):
	if (switches.has(name)): return switches[name]
	else: return false

func hasSwitch(name):
	return switches.has(name)

func drive(map,from):
	town = from
	get_tree().change_scene("res://overworld/scenes/%s.tscn" % map)