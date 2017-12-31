tool
extends Position2D

const SEGMENTS = 9
const SEGMENT_LENGTH = 14
const TICK = 0.1

var offset
var timer = 0
var angles = []

func _ready():
	set_process(true)
	var offsetNode = get_node("../offset")
	if (offsetNode != null): offset = offsetNode.get_pos()
	else: offset = Vector2()
	for i in range(SEGMENTS): angles.append(randf() * PI * 2)

func _process(delta):
	timer += delta
	if (timer >= TICK):
		for i in range(SEGMENTS): angles[i] += (randf() - 0.5)
		timer -= TICK
		update()

func _draw():
	var pos = Vector2()
	var totalAngle = 0
	for i in range(SEGMENTS):
		totalAngle += angles[i]
		var nextPos = pos + Vector2(sin(totalAngle) * SEGMENT_LENGTH,cos(totalAngle) * SEGMENT_LENGTH ) + offset
		draw_line(pos,nextPos,0x000000e0,9 - i)
		pos = nextPos
