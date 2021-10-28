extends Area2D

export (int) var style

const DeadEffect = preload("res://Effect/DeadEffect.tscn")

func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_Candy_body_entered(body):
	Utils.change_style(style)
	dead_effect()

func dead_effect():
	Utils.instance_scene_on_main(DeadEffect, $CollisionShape2D.global_position)
	queue_free()
