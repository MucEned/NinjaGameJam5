extends Particles2D

var current_style = 0
var color_array = [Color("ffe2b5"), Color("dff9aa"), Color("ffffff"), Color("ff9090"), Color("7bff6c"), Color("a0ffed")]
var last_style = 0

onready var tween = $Tween

func _ready():
# warning-ignore:return_value_discarded
	Utils.connect("change_style", self, "_player_changed_style")
	pass # Replace with function body.
	
# warning-ignore:unused_argument
func _process(delta):
#	set_current_style(Utils.current_style)
	pass
	
func _player_changed_style(style):
	last_style = current_style
	current_style = style
	modulate = color_array[current_style]
#	tween.interpolate_property(self, "modulate", color_array[last_style], color_array[current_style], 1, Tween.TRANS_BACK, Tween.EASE_IN)
