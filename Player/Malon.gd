extends "res://Player/Player.gd"

var is_rolling = false
onready var AttackSound2 = $AttackSound2

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

func x_direction_calculate(input_vector_x, delta):
	motion.x += input_vector_x * A * delta
	if state == "Roll":
		motion.x = clamp(motion.x, -MAX_DASH_SPEED, MAX_DASH_SPEED)
	else:
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	if input_vector_x == 0 and is_on_floor():
		motion.x = lerp(motion.x, 0, FRICTION)
	if motion.x != 0:
		sprite.scale.x = sign(motion.x)

func attack_input_check():
	if Input.is_action_just_pressed("attack"):# and is_on_floor() and state != "Roll" and state != "StartRoll" and state != "Recover":
		attack()
		
func attack():
	if state != "Attack":
		state = "Attack"
		if attack_count == 0:
			is_rolling = false
			animator.play("Attack1")
			attackTimer.start()
			
	elif attackTimer.time_left <= 0.25 and attack_count == 0:
		attackTimer.set_wait_time(0)
		attack_count = 1
		attack_queue = true
		
func next_animation():
	if attack_count == 1:
		animator.play("Attack2")
		attackTimer.wait_time = 0.8
		attackTimer.start()
		attack_queue = false
	else:
		attack_count = 0
		attackTimer.wait_time = 0.7
		state = "Idle"
		animator.play("Idle")
		attack_queue = false

func back_to_idle():
	state = "Idle"
	animator.play("Idle")
	is_rolling = false

func dash_input_check():
	if Input.is_action_just_pressed("dash") and state == "Idle" and is_rolling == false:
		state = "StartRoll"
		animator.play("StartRoll")
	if Input.is_action_just_pressed("dash") and state == "Roll" and is_rolling == true:
		state = "Recover"
		animator.play("Recover")

func roll():
	state = "Roll"
	is_rolling = true
	animator.play("Roll")

func _on_Malon_timeout():
	if attack_queue == false:
		attack_count = 0
		
func play_malon_attack_sound():
	AttackSound2.play()
	
func stop_malon_attack_sound():
	AttackSound2.stop()
