extends Control


func _ready():
	pass # Replace with function body.

func _on_MainMenu_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")
	pass # Replace with function body.

func _on_Restart_pressed():
	get_tree().change_scene("res://World.tscn")
	pass # Replace with function body.
