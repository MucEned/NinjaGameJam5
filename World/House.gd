extends Sprite

var GameController = ResourceLoader.GameController
var phase = GameController.phase

onready var animator = $AnimationPlayer
onready var label = $Label

onready var castLeft = $CastLeft
onready var castRight = $CastRight

var last_style = 9

var can_interact = false
var said = false

var hint = false

func _ready():
	GameController.connect("starting", self, "_on_starting_wave")
	GameController.connect("ending", self, "_on_ending_wave")
	pass # Replace with function body.

func _on_starting_wave():
	said = false
	close_the_door()
	
func _on_ending_wave():
	open_the_door()

# warning-ignore:unused_argument
func _process(delta):
	GameController.warning_left = castLeft.is_colliding()
	GameController.warning_right = castRight.is_colliding()
	
	phase = GameController.phase
	if Utils.current_style == last_style and not hint and not said:
		label.text = "You again?"
	elif Utils.current_style != last_style and not hint and not said:
		label.text = "Press A to say:\nTrick-or-treat"
	elif said:
		label.text = "Have a\ngood night!"
	if Input.is_action_just_pressed("tot") and can_interact and not said and Utils.current_style != last_style:
		GameController.emit_signal("say_tot")
		last_style = Utils.current_style
		said = true
		pass
	elif Input.is_action_just_pressed("tot") and can_interact and not said and Utils.current_style == last_style:
		hint = true
		label.text = "(I need change\nmy outfit)"

func open_the_door():
	animator.play("open")
	pass
	
func close_the_door():
	animator.play("close")
	pass
	
func show_candies():
	pass

# warning-ignore:unused_argument
func _on_ClaimCandiesArea_body_entered(body):
	can_interact = true
	label.visible = true
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_ClaimCandiesArea_body_exited(body):
	hint = false
	can_interact = false
	label.visible = false
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_EndPoint_body_entered(body):
	GameController.reset()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/EndScene.tscn")
	pass # Replace with function body.
