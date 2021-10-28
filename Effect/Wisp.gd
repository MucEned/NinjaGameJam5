extends Node2D

func _ready():
	pass # Replace with function body.
func _on_Lifetime_timeout():
	$AnimationPlayer.play("Out")
	pass # Replace with function body.
