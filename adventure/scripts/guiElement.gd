extends Panel

func destroy(arg):
	var room = get_node("/root/room")
	room.gui = false
	room.value = arg
	queue_free()