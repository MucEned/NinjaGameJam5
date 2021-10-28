extends Node

export (int) var HP = 10

onready var invisibleTimer = $InvisibleTime
onready var flash = $FlashTime

var is_invisible = false
var HP_increase = [0,0,1,1,3,3,4,5,5,6]
var gameController = ResourceLoader.GameController
var bite = false

onready var hurtBox = get_parent().get_node("HurtBox")

const SlashEffect = preload("res://Effect/SlashEffect.tscn")

signal dead(was_bite)
signal gethit()

func _ready():
	HP += HP_increase[gameController.wave]
	pass # Replace with function body.

func _on_HurtBox_hit(damage):
	if not is_invisible:
		emit_signal("gethit")
		hurtBox.is_visible = true
		HP -= damage
		Utils.instance_scene_on_main(SlashEffect, get_parent().get_node("Center").global_position)
		get_parent().get_node("Sprite").material.set_shader_param("flash_modifier", 1)
		invisibleTimer.start()
		flash.start()
		is_invisible = true
		var shake = damage * 0.05
		shake = clamp(shake, 0, 0.5)
		Events.emit_signal("add_screenshake", damage * 0.05, 0.5)
		if HP <= 0:
			emit_signal("dead", bite)
			
func _on_InvisibleTime_timeout():
	hurtBox.is_visible = false
	is_invisible = false
	pass # Replace with function body.

func _on_FlashTime_timeout():
	get_parent().get_node("Sprite").material.set_shader_param("flash_modifier", 0)
	pass # Replace with function body.

func _on_HurtBox_area_entered(Hitbox):
	if Hitbox.collision_layer == 80:
		bite = true
	pass # Replace with function body.
