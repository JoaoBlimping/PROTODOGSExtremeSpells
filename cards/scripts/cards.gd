extends Node2D

onready var global = get_node("/root/global")

func _ready():
	global.playSong("chess")
	
	var TODO = """
	ok so the way that this is going to work for when I feel like doing
	some programming is that when a card starts getting dragged it
	starts following the mouse and that, and then when you release if
	the mouse is inside another card the two find each other somehow,
	and then the new card takes over the old card and you randomly get
	a new card.
	Also I have to keep in mind that all of this stuff can only happen
	on your turn.
	To be honest it will probably be best to keep the whole thing straight
	in some internal state that keeps track of the game, and just use the
	ui for actual ui stuff."""
