extends TextureButton

const FullTexture = preload("res://UI/Full.png")
const AtTexture = preload("res://UI/Atbtn.png")
const MaxTexture = preload("res://UI/Healbtn.png")
const SpTexture = preload("res://UI/Spbtn.png")
const SlowTexture = preload("res://UI/Slowbtn.png")
const HalfTexture = preload("res://UI/half.png")

onready var soundStop = $SoundStop
onready var sound = $Sound

var state = ""

var GameController = ResourceLoader.GameController

func _ready():
	pass # Replace with function body.

func set_val(btn_type: String):
	state = btn_type
	match btn_type:
		"Full":
			texture_normal = FullTexture
			hint_tooltip = "Heal full hp"
			pass
		"At":
			texture_normal = AtTexture
			hint_tooltip = "+1 Att dmg"
			pass
		"Max":
			texture_normal = MaxTexture
			hint_tooltip = "+2 Max HP"
			pass
		"Sp":
			texture_normal = SpTexture
			hint_tooltip = "+1 Speed"
			pass
		"Slow":
			texture_normal = SlowTexture
			hint_tooltip = "Heal full hp"
			pass
		"Half":
			texture_normal = HalfTexture
			hint_tooltip = "Heal half of max hp"
			pass
	pass

func _on_PeakBtn_pressed():
	sound.play()
	soundStop.start()
	GameController.emit_signal("peak_choice", state)
	GameController.emit_signal("end_claim_phase")
	pass # Replace with function body.

func _on_SoundStop_timeout():
	sound.stop()
	pass # Replace with function body.
