extends KinematicBody2D

const JumpEffect = preload("res://Effect/EffectJump.tscn")
const Wisp = preload("res://Effect/Wisp.tscn")
const Bat = preload("res://Player/Skill/Bat.tscn")
const Acid = preload("res://Effect/Acid.tscn")
const SlashEffect = preload("res://Effect/SlashEffect.tscn")

onready var sprite = $Sprite
onready var animator = $Animator
onready var invisibleAnimator = $InvisibleAnimator
onready var attackTimer = $Timer
onready var camRemote = $RemoteTransform2D
onready var hurtBox = $HurtBox
onready var flash = $Flash

onready var hitBox = $Sprite/HitBox
onready var attackSound = $AttackSound
onready var hitSound = $HitSound
onready var jumpSound = $JumpSound
onready var hitSoundCount = $HitSoundCount
onready var deadCount = $DeadCount
onready var deadSound = $DeadSound

export (int) var MAX_SPEED = 100
export (int) var A = 512
export (float) var FRICTION = 0.3
export (int) var GRAVITY = 512
export (int) var JUMP_FORCE = 128
export (int) var MAX_DASH_SPEED = 320

var motion = Vector2.ZERO
var state = "Idle"
var attack_count = 0
var attack_queue = false

var GameController = ResourceLoader.GameController

var MaxHP = 10
var HP = 10
var is_invisible = false

var base_dmg = 3
var dead = false

func _ready():
	deadCount.connect("timeout", self, "_on_deadCount_timeout")
	
	get_node("Sprite").material.set_shader_param("flash_modifier", 0)
	base_dmg = GameController.PlayerBaseDmg
	MAX_SPEED = GameController.PlayerMaxSpeed
	MaxHP = GameController.PlayerMaxhp
	HP = GameController.Playerhp
	
	hitSoundCount.connect("timeout", self, "_on_HitSoundCount_out")
	GameController.connect("peak_choice", self, "_on_peak_choice")
	hitBox.damage = base_dmg
	flash.connect("timeout", self, "_on_flash_out")
	hurtBox.connect("hit", self, "_on_get_hit")
	GameController.Player = self
	camRemote.remote_path = get_parent().get_node("MainCamera").get_path()
	pass # Replace with function body.

# warning-ignore:unused_argument
func _physics_process(delta):
	base_dmg = GameController.PlayerBaseDmg
	if HP <= 0 and not dead:
		dying()

func get_x_direction_input_vector():
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func x_direction_calculate(input_vector_x, delta):
	motion.x += input_vector_x * A * delta
	if state != "BackStep" and state != "Dash":
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	else:
		motion.x = clamp(motion.x, -MAX_DASH_SPEED, MAX_DASH_SPEED)
	if input_vector_x == 0 and is_on_floor():
		motion.x = lerp(motion.x, 0, FRICTION)
	if motion.x != 0 and state != "BackStep": #Change
		sprite.scale.x = sign(motion.x)

func add_gravity(delta):
	motion.y += GRAVITY * delta

func jump_input_check():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		Utils.instance_scene_on_main(JumpEffect, self.global_position)
		motion.y -= JUMP_FORCE

func update_animation():
	if state != "Attack" and state != "Dash" and state != "Bite"  and state != "BackStep"  and state != "StartRoll" and state != "Roll" and state != "Recover"  and state != "Tele":
		if is_on_floor():
			state = "Idle"
			animator.play("Idle")
		if not is_on_floor():
			state = "Jump"
			animator.play("Jump")

func next_animation():
	state = "Idle"
	animator.play("Idle")
	attack_queue = false
	base_dmg()

func back_to_idle():
	state = "Idle"
	animator.play("Idle")
	base_dmg()

func move():
	motion = move_and_slide(motion, Vector2.UP)

func _on_get_hit(damage):
	if not is_invisible:
		play_hit_sound()
		Utils.instance_scene_on_main(SlashEffect, get_node("Center").global_position)
		invisibleAnimator.play("Invisible")
		get_node("Sprite").material.set_shader_param("flash_modifier", 1)
		var shake = damage * 0.05
		shake = clamp(shake, 0, 0.6)
		Events.emit_signal("add_screenshake", damage * 0.05, 0.5)
		if HP > 0:
			flash.start()
		is_invisible = true
		HP -= damage
		GameController.set_player_hp(HP)
	pass

func _on_flash_out():
	get_node("Sprite").material.set_shader_param("flash_modifier", 0)

func end_invisible():
	invisibleAnimator.play("Idle")
	is_invisible = false

# warning-ignore:function_conflicts_variable
func dead():
	GameController.reset()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/EndScene.tscn")
	pass

func dying():
	dead = true
	deadSound.play()
	deadCount.start()
	get_node("Sprite").material.set_shader_param("flash_modifier", 1)
	pass

func increase_dmg(value):
	hitBox.damage += value
	
# warning-ignore:function_conflicts_variable
func base_dmg():
	hitBox.damage = base_dmg

func _on_peak_choice(type):
	match type:
		"Full":
			HP = MaxHP
			HP = clamp(HP, 0, MaxHP)
			GameController.set_player_hp(HP)
		"At":
			var new_dmg = base_dmg + 1
			GameController.set_player_base_dmg(new_dmg)
		"Max":
			MaxHP += 2
			GameController.set_player_maxhp(MaxHP)
			HP += 2
			HP = clamp(HP, 0, MaxHP)
			GameController.set_player_hp(HP)
		"Sp":
			MAX_SPEED += 30
			GameController.set_player_max_speed(MAX_SPEED)
			pass
		"Slow":
			pass
		"Half":
			HP += MaxHP / 2
			HP = clamp(HP, 0, MaxHP)
			GameController.set_player_hp(HP)
			pass
			
	
func play_attack_sound():
	attackSound.play()
	pass
	
func stop_attack_sound():
	attackSound.stop()

func play_hit_sound():
	hitSound.play()
	pass
	
func stop_hit_sound():
	hitSound.stop()

func play_jump_sound():
	jumpSound.play()
	pass
	
func stop_jump_sound():
	jumpSound.stop()

func _on_HitSoundCount_out():
	stop_hit_sound()

func _on_deadCount_timeout():
	dead()
	pass
