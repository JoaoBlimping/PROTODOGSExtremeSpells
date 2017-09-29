extends MenuButton

onready var thing = preload("thing.gd")

func _ready():
	var global = get_node("/root/global")
	var popup = get_popup()
	popup.connect("item_pressed",self,"chosen")
	for item in global.inventory:
		popup.add_item(item)

func chosen(id):
	# This is a hack and I love it
	get_parent().destroy(0)
	var room = get_node("/root/room")
	var item = global.inventory[id]
	if (!room.has_node(item)):
		var node = thing.new()
		node.realName = item
		room.add_child(node)
		room.run(item.replace(" ","_"),node)
	else:
		room.run(item.replace(" ","_"),get_node(item))
