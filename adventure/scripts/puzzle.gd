extends Node2D

signal said

func finish(success):
	get_node("/root/room").gui = false
	queue_free()
	emit_signal("said",success)