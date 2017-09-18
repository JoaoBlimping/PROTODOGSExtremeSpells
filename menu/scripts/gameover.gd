extends Button


func _on_CheckBox_toggled(pressed):
	set_disabled(!pressed)


func _on_Button_button_down():
	get_tree().change_scene("res://overworld/scenes/level.tscn")
