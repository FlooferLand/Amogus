extends Button

func _ready():
	# Disable button if it's not a dev build
	if not Global.debug_mode():
		queue_free()

func _process(_delta):
	disabled = Global.device_has_touchscreen()
	visible = !disabled

func _pressed():
	get_tree().change_scene("res://levels/Level Editor.tscn")
