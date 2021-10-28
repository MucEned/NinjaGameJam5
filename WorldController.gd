extends Node

const Elantern = preload("res://Enemies/Elantern.tscn")
const Emalon = preload("res://Enemies/EMalon.tscn")
const Ezombie = preload("res://Enemies/EZombie.tscn") 
const Eghost = preload("res://Enemies/EGhost.tscn")
const Eskeleton = preload("res://Enemies/ESkeleton.tscn")
const Evampire = preload("res://Enemies/EVampire.tscn")
const EFinaley = preload("res://Enemies/Finaley.tscn")

const Hint = preload("res://Effect/Hint.tscn")
const EnemiesArray = [Elantern, Emalon, Ezombie, Eghost, Eskeleton, Evampire, EFinaley]

onready var breathTime = $BreathTime

var wave_start = true
var spawncount = 0
var max_type_spawn = 2

var GameController = ResourceLoader.GameController
var wave = GameController.wave
var killcount = GameController.killcount

onready var posLeft = $SpawnLeft
onready var posRight = $SpawnRight
onready var spawnCooldown = $SpawnCooldown
onready var notiLabel = $CanvasLayer/Message

onready var warning_left = $CanvasLayer/WarningLeft
onready var warning_right = $CanvasLayer/WarningRight

var pos

var spawnQuantityArray = [10, 12, 14, 18, 20, 22, 24, 26, 30, 1]
var spawnQualityArray = [2, 3, 3, 4, 4, 5, 5, 6, 6, 6]

var howManyEnemiesISpawn = 0

var phase = "Starting"

func _ready():
	pos = [posLeft, posRight]
	pass # Replace with function body.
	
# warning-ignore:unused_argument
func _process(delta):
#	if Input.is_action_just_pressed("Debug"):
#		wave = 9
#		GameController.wave = 9
	if GameController.Player != null:
		warning_left.visible = GameController.warning_left and GameController.Player.global_position.x > 800
		warning_right.visible = GameController.warning_right  and GameController.Player.global_position.x < 800
	
	phase = GameController.phase
	killcount = GameController.killcount
	
	if phase == "Waving":
		notiLabel.text = "Wave: "+ str(wave + 1) + "\nEnemy count: " + str(spawncount - killcount)
		
	if killcount == spawncount and killcount != 0:
		GameController.set_phase("Ending")
		GameController.emit_signal("ending")
		notiLabel.text = "Clear!\nBack to the house to\nclaim candies"
		end_wave()
	if wave_start:
		wave_start = false
		breathTime.start()
	pass

func _on_BreathTime_timeout():
	GameController.emit_signal("starting")
	wave = GameController.wave
	next_wave()
	pass # Replace with function body.

func next_wave():
	GameController.emit_signal("end_claim_phase")
	GameController.set_phase("Waving")
	spawncount = spawnQuantityArray[wave]
	max_type_spawn = spawnQualityArray[wave]
	spawn()
	pass
	
func spawn():
	if howManyEnemiesISpawn < spawncount:
		if wave < 9:
			howManyEnemiesISpawn += 1
			var rand_position_spawn = rand_range(0, 1.99999)
			rand_position_spawn = int(rand_position_spawn)
			
			var rand_type_spawn = rand_range(0, max_type_spawn - 0.000001)
			rand_type_spawn = int(rand_type_spawn)
			var current_enemy = Utils.instance_scene_on_main(EnemiesArray[rand_type_spawn], pos[rand_position_spawn].global_position)
			if rand_position_spawn == 1:
				current_enemy.set_direction(-1)
			var rand = rand_range(0.5, 2)
			spawnCooldown.wait_time = rand
			spawnCooldown.start()
		else:
			spawn_boss()
	else:
		howManyEnemiesISpawn = 0

func end_wave():
	wave_start = true
	if GameController.wave <= 9:
		GameController.wave += 1
		GameController.killcount = 0
		killcount = GameController.killcount
		spawncount = 0
	if GameController.wave == 10:
		to_end_screen()

func _on_SpawnCooldown_timeout():
	spawn()
	pass # Replace with function body.
	
func to_end_screen():
	GameController.reset()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/WinScene.tscn")
	pass

func _on_FirstStart_timeout():
	notiLabel.text = "Arrow to left/right"
	pass # Replace with function body.

func _on_Guide1_timeout():
	notiLabel.text = "Z,X,C to actions"
	pass # Replace with function body.
 
func _on_Guide2_timeout():
	notiLabel.text = "A to interact"
	pass # Replace with function body.

func _on_Guide3_timeout():
	notiLabel.text = "Defend the house\nfrom enemies"
	Utils.instance_scene_on_main(Hint, $RightHint.global_position)
	var rh = Utils.instance_scene_on_main(Hint, $LeftHint.global_position)
	rh.scale.x = -1
	pass # Replace with function body.

func spawn_boss():
	howManyEnemiesISpawn += 1
	var rand_position_spawn = rand_range(0, 1.99999)
	rand_position_spawn = int(rand_position_spawn)
	var current_enemy = Utils.instance_scene_on_main(EnemiesArray[6], pos[rand_position_spawn].global_position)
	if rand_position_spawn == 1:
		current_enemy.set_direction(-1)
		Utils.instance_scene_on_main(Hint, $RightHint.global_position)
	else:
		var rh = Utils.instance_scene_on_main(Hint, $LeftHint.global_position)
		rh.scale.x = -1
	pass
