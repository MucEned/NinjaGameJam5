extends "res://Player/Player.gd"

onready var acidPoint = $Sprite/Acidpoint

func _ready():
	
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
	if Input.is_action_just_pressed("jump") and state != "Attack" and is_on_floor():
		Utils.instance_scene_on_main(JumpEffect, self.global_position)
		motion.y -= JUMP_FORCE
	
func attack_input_check(): #change
	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack()
		
func attack():
	if state != "Attack":
		state = "Attack"
		if attack_count == 0:
			animator.play("Attack1")
			attackTimer.start()
		
func dash_input_check():
	if Input.is_action_just_pressed("dash") and state == "Idle":
		if state != "Attack":
			state = "Attack"
		if attack_count == 0:
			animator.play("Attack2")
			attackTimer.start()

func acid_spawn():
	Utils.instance_scene_on_main(Acid, acidPoint.global_position)
