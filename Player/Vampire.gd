extends "res://Player/Player.gd"

#change
onready var batSpawnPoints = $BatSpawnPoints
onready var AttackSound2 = $AttackSound2

func _ready():
	motion.x = sign(sprite.scale.x) * 0
	pass # Replace with function body.

func _physics_process(delta):
	var input_vector_x = 0
	if state != "Attack":
		input_vector_x = get_x_direction_input_vector()
	x_direction_calculate(input_vector_x, delta)
	add_gravity(delta)
	jump_input_check()
	attack_input_check()
	dash_input_check()
	update_animation()
	move()

#change
func jump_input_check():
	if Input.is_action_just_pressed("jump") and state != "Attack"  and is_on_floor():
		Utils.instance_scene_on_main(JumpEffect, self.global_position)
		motion.y -= JUMP_FORCE
	
func attack_input_check():
	if Input.is_action_just_pressed("attack") and is_on_floor(): #change
		attack()
		
func attack():
	if state != "Attack":
		state = "Attack"
		if attack_count == 0:
			animator.play("Attack1")
			attackTimer.start()

func dash_input_check():
	if Input.is_action_just_pressed("dash") and state == "Idle":
		motion.x = sign(sprite.scale.x) * 0
		state = "Attack"
		animator.play("Bite")
	
func spawnBats():
	var spawnArray = batSpawnPoints.get_children()
	for i in spawnArray.size():
		var currentBat = Utils.instance_scene_on_main(Bat, spawnArray[i].global_position)
		currentBat.set_damage(base_dmg/2)
		currentBat.set_direct(sign(sprite.scale.x))
		
func play_vambite():
	AttackSound2.play()
	pass
	
func stop_vambite():
	AttackSound2.stop()
	pass
