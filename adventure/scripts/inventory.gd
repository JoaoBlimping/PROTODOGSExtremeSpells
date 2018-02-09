extends Sprite

onready var room = get_node("/root/room")
onready var global = get_node("/root/global")
onready var list = get_node("scroller/list")
onready var item = preload("res://adventure/objects/item.tscn")
onready var thing = preload("res://adventure/scripts/thing.gd")

func _ready():
	get_node("sample").play("open")
	for i in global.inventory:
		var ib = item.instance()
		ib.set_tooltip("%s\n%s" % [i, global.items[i].description])
		ib.get_node("sprite").set_texture(global.items[i].texture)
		ib.connect("button_down",self,"press",[i])
		list.add_child(ib)

func close(ended=false):
	if (ended): room.gui = false
	queue_free()

func press(item):
	room.gui = false
	if (global.itemProperty(item,"use")):
		if (!room.has_node(item)):
			var node = thing.new()
			node.realName = item
			room.add_child(node)
			room.run(item,node)
		else:
			room.run(item,get_node(item))
	else:
		room.useItem(item)
	close()