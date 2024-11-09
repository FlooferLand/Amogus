extends RichTextLabel

# Nodes
onready var vis = $Visibility

# Node functions
func _ready():
	vis.connect("screen_exited", self, "_delete")
	bbcode_text += _crossplatform(
		"Press R to restart if you get stuck",
		"Press the button in the top right to restart"
	) + '\n'
	bbcode_text += "Your speed is [wave freq=12]momentum-based[/wave],\nThe faster you're running, the higher you can jump.\nThe longer you hold the jump button the higher you'll jump.\nDon't spam buttons, it'll do the opposite of helping.\n"
	bbcode_text += _crossplatform(
		"Hold CTRL or S, to crouch",
		"Move the joystick down to crouch"
	) + "[i](crouching makes you small, and tapping crouch stops you from sliding)[/i]"
	if Global.dababy_mode:
		bbcode_text += "Press C or Enter to place down a checkpoint"
	

# Private functions
func _delete():
	queue_free()

func _crossplatform(general: String, touchscreen: String) -> String:
	if not Global.device_has_touchscreen():
		return general + '\n'
	else:
		return touchscreen + '\n'
