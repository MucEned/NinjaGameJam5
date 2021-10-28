extends Control

func _on_Start_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")

func _on_HowToPlay_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/HTP.tscn")

func _on_Info_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/About.tscn")
