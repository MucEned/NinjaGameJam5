extends Resource
class_name GameController

var Player = null
var Playerhp = 10
var PlayerMaxhp = 10
var PlayerBaseDmg = 2
var PlayerMaxSpeed = 100

var wave = 0
var killcount = 0
var phase = "Starting"

# warning-ignore:unused_signal
signal starting()
# warning-ignore:unused_signal
signal ending()
# warning-ignore:unused_signal
signal peak_choice(message)
# warning-ignore:unused_signal
signal say_tot()
# warning-ignore:unused_signal
signal end_claim_phase()

var warning_left = false
var warning_right = false

func set_phase(value):
	phase = value
	
func set_player_hp(value):
	Playerhp = value
	
func set_player_maxhp(value):
	PlayerMaxhp = value

func set_player_base_dmg(value):
	PlayerBaseDmg = value

func set_player_max_speed(value):
	PlayerMaxSpeed = value

func reset():
	Player = null
	Playerhp = 10
	PlayerMaxhp = 10
	PlayerBaseDmg = 1
	PlayerMaxSpeed = 100
	wave = 0
	killcount = 0
	Utils.current_style = 0
	phase = "Starting"
