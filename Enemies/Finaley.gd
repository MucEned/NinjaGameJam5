extends "res://Enemies/Enemy.gd"

onready var backEye = $Sprite/BackEye

var backEyeColliding = false

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if backEye.is_colliding() and not counting:
		backEyeColliding = true
		counting = true
		attackDecide.start()
	elif playerCast.is_colliding() and not counting:
		backEyeColliding = false
		counting = true
		attackDecide.start()
	
func attack():
	is_attacking = true
	var ran = rand_range(-1, 1)
	if ran < 0:
		basic_attack()
	else:
		skill()

func continue_to_move():
	is_attacking = true
	sprite.scale.x = direction
	animator.play("Animate")
	current_speed = MAX_SPEED
	pass

func basic_attack():
	if backEyeColliding:
		sprite.scale.x = -direction
	current_speed = 0
	if not dead:
		animator.play("Attack")
	pass

func skill():
	is_attacking = true
	current_speed = 0
	if not dead:
		animator.play("Skill")
	pass
