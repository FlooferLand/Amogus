extends Control

func _ready():
	if not Global.device_has_touchscreen():
		hide()
