extends KinematicBody2D

const DeadEffect = preload("res://Effect/DeadEffect.tscn")
const VCreep = preload("res://Player/Skill/VCreep.tscn")

export var Candy = preload("res://Candy/Candy.tscn")
export var type = 0

var motion = Vector2.ZERO
export (int) var MAX_SPEED = 20
var current_speed = MAX_SPEED
export (int) var A = 32
var direction = 1

onready var animator = $AnimationPlayer
onready var sprite = $Sprite
onready var playerCast = $Sprite/RayCast2D
onready var attackDecide = $Attack
onready var hitSound = $HitSound
onready var hitSoundCount = $HitSoundCount

onready var attackSound = $AttackSound

var GameController = ResourceLoader.GameController
var speed_increase = [0,0,1,1,1,2,2,2,3,3]

var counting = false
var dead = false

func _ready():
	var rand = rand_range(-3, 3)
	MAX_SPEED += speed_increase[GameController.wave] + rand
	current_speed = MAX_SPEED
	pass

func _physics_process(delta):
	if playerCast.is_colliding() and not counting:
		counting = true
		attackDecide.start()
	motion.x += A * delta * direction
	motion.x = clamp(motion.x, -current_speed, current_speed)
	motion = move_and_slide(motion, Vector2.UP)
	
func set_direction(value):
	direction = value
	sprite.scale.x = value
	pass

func _on_EnemyStat_dead(is_bite):
	var rand
	if type == Utils.current_style:
		rand = rand_range(0,6)
	elif type != Utils.current_style:
		rand = rand_range(0,4)
	if rand < 1:
		spawn_candy()
	GameController.killcount += 1
	dead = true
	animator.play("Dead")
	if is_bite:
		spawn_mini_vampire()
	Utils.instance_scene_on_main(DeadEffect, get_node("Center").global_position)
	pass # Replace with function body.

func _on_EnemyStat_gethit():
	hitSoundCount.start()
	hitSound.play()
	motion.x = 0
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_SpellCheck_area_entered(area):
	if current_speed == MAX_SPEED:
		current_speed *= 0.3

# warning-ignore:unused_argument
func _on_SpellCheck_area_exited(area):
	current_speed = MAX_SPEED
	
func spawn_mini_vampire():
	var vcreep = Utils.instance_scene_on_main(VCreep, self.global_position)
	vcreep.set_direction(direction * -1)
	pass

func _on_Attack_timeout():
	var decide = rand_range(0,1.9999)
	counting = false
	if int(decide < 1):
		attack()

func attack():
	current_speed = 0
	if not dead:
		animator.play("Attack")
	pass

func continue_to_move():
	animator.play("Animate")
	current_speed = MAX_SPEED
	pass

func _on_HitSoundCount_timeout():
	hitSound.stop()
	pass # Replace with function body.

func play_attack_sound():
	attackSound.play()

func stop_attack_sound():
	attackSound.stop()

func spawn_candy():
	Utils.instance_scene_on_main(Candy, self.global_position)
	pass
