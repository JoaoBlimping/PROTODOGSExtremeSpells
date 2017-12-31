extends Button


func _ready():
	get_node("/root/global").playSong("dead")

func _on_CheckBox_toggled(pressed):
	set_disabled(!pressed)

func _on_Button_button_down():
	global.loadGame()
	global.enterAdventure(global.area)
