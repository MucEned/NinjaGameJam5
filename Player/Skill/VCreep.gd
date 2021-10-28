extends KinematicBody2D

var motion = Vector2.ZERO
export (int) var MAX_SPEED = 10
var current_speed = MAX_SPEED
export (int) var A = 32
var direction = 1

onready var animator = $AnimationPlayer
onready var sprite = $Sprite

onready var enemyCast = $Sprite/RayCast2D
onready var attackDecide = $Attack

var GameController = ResourceLoader.GameController
var speed_increase = [0,0,2,2,4,4,6,6,7,7]

var counting = false

func _ready():
	MAX_SPEED += speed_increase[GameController.wave]
	pass

func _physics_process(delta):
	if enemyCast.is_colliding() and not counting:
		counting = true
		attackDecide.start()
	motion.x += A * delta * direction
	motion.x = clamp(motion.x, -current_speed, current_speed)
	motion = move_and_slide(motion, Vector2.UP)
	
func set_direction(value):
	direction = value
	sprite.scale.x = value
	pass

func _on_Attack_timeout():
	counting = false
	attack()
		
func attack():
	current_speed = 0
	animator.play("Attack")
	pass

# warning-ignore:unused_argument
func _on_Delete_area_entered(area):
	queue_free()
	pass # Replace with function body.

func to_idle():
	current_speed = MAX_SPEED
	animator.play("Animate")
