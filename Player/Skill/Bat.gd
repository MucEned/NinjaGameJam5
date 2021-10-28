extends KinematicBody2D

var motion = Vector2.ZERO
var direction = 1
export (int) var A = 64
export (int) var MAX_SPEED

onready var hitBox = $HitBox

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	motion.x += delta * direction * A
	motion = move_and_slide(motion, Vector2.UP)
	
func set_direct(direct):
	direction = direct

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.

func set_damage(value):
	hitBox.damage = value

func _on_HitBox_area_entered(hurtbox):
	if not hurtbox.is_visible:
		queue_free()
