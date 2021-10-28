extends Node

var current_style = 0
const Lantern_S = preload("res://Player/Lantern.tscn")
const Malon_S = preload("res://Player/Malon.tscn")
const Skeleton_S = preload("res://Player/Skeleton.tscn")
const Vampire_S = preload("res://Player/Vampire.tscn")
const Zombie_S = preload("res://Player/Zombie.tscn")
const Ghost_S = preload("res://Player/Ghost.tscn")

const ChangeEffect = preload("res://Effect/ChangeStyle.tscn")
const AtPlus = preload("res://Effect/atplus.tscn")
var style_array = [Lantern_S, Malon_S, Skeleton_S, Vampire_S, Zombie_S, Ghost_S]

var GameController = ResourceLoader.GameController

signal change_style(style)

func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()	
	instance.global_position = position
	main.add_child(instance)
	return instance
	
func delete_player():
	GameController.Player.queue_free()

func change_style(value):
	if current_style != value:
		current_style = value
		emit_signal("change_style", current_style)
		var player_position = GameController.Player.global_position
		var player_diret = GameController.Player.sprite.scale.x
		instance_scene_on_main(ChangeEffect, player_position)
		delete_player()
		var this_player = instance_scene_on_main(style_array[current_style], player_position)
		this_player.sprite.scale.x = player_diret
		current_style = current_style
	else: 
		var player_position = GameController.Player.global_position
		instance_scene_on_main(ChangeEffect, player_position)
		instance_scene_on_main(AtPlus, player_position)
		var player_hp = GameController.Player.HP
		player_hp += 1
		player_hp = clamp(player_hp, 0, GameController.PlayerMaxhp)
		GameController.PlayerBaseDmg += 1
		GameController.Player.HP = player_hp
		GameController.set_player_hp(player_hp)
