extends "res://Player/Player.gd"

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

func attack_input_check():
	if Input.is_action_just_pressed("attack"):# and is_on_floor():
		attack()
		
func attack():
	if state != "Attack":
		state = "Attack"
		if attack_count == 0:
			animator.play("Attack1")
			attackTimer.start()
			
	elif attackTimer.time_left <= 0.2 and attack_count == 0:
		attackTimer.set_wait_time(0) 
		attack_count = 1
		attack_queue = true
		
	elif attackTimer.time_left <= 0.2 and attack_count == 1:
		attackTimer.set_wait_time(0) 
		attack_count = 2
		attack_queue = true

func next_animation():
	if attack_count == 2:
		animator.play("Attack3")
		attackTimer.start()
		attack_queue = false
	elif attack_count == 1:
		animator.play("Attack2")
		attackTimer.start()
		attack_queue = false
	else:
		attack_count = 0
		state = "Idle"
		animator.play("Idle")
		attack_queue = false

func _on_Lantern_timeout():
	if attack_queue == false:
		attack_count = 0

func dash_input_check():
	if Input.is_action_just_pressed("dash") and state == "Idle":
		motion.x = 0
		animator.play("Dash")
		state = "Dash"

func dash():
	motion.x = sprite.scale.x * 320

