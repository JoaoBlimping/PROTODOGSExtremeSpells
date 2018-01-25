extends Panel

signal said

var face = null
var expression

func _ready():
	get_node("sample").play("next")

func setFace(face):
	self.face = face
	expression = face.get_frame()

func destroy(arg):
	queue_free()
	var room = get_node("/root/room")
	room.value = arg
	room.gui = false
	if (face != null): face.set_frame(expression)
	emit_signal("said")
	