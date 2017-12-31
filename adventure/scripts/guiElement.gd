extends Panel

signal said

func destroy(arg):
	var room = get_node("/root/room")
	room.value = arg
	room.gui = false
	queue_free()
	emit_signal("said")