extends VBoxContainer

onready var label = $Label
onready var btn1 = $HBoxContainer/Button1
onready var btn2 = $HBoxContainer/Button2

var GameController = ResourceLoader.GameController

var peakCanChoice = 3
const PeakArray = ["At", "Max", "Half", "Sp", "Full", "Slow", "Drain"]

func _ready():
	GameController.connect("say_tot", self, "_on_say_tot")
	GameController.connect("end_claim_phase", self, "_on_end_claim_phase")

func _on_say_tot():
	btn1.set_val(roll_random_peak())
	btn2.set_val(roll_random_peak())
	
	visible = true

func _on_end_claim_phase():
	visible = false
	
func roll_random_peak():
	var ran = rand_range(0, peakCanChoice + 0.999999)
	ran = int(ran)
	return PeakArray[ran]
