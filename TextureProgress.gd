extends TextureProgress

var GameController = ResourceLoader.GameController

func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _process(delta):
	max_value = GameController.PlayerMaxhp
	value = GameController.Playerhp
