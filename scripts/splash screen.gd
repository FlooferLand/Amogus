extends VideoPlayer

func _next():
	get_tree().change_scene("res://levels/Main Menu.tscn")

func _finished():
	OS.delay_msec(400)
	_next()

func _ready():
	_next() # Skipping this because of audio stuttering and easier debugging
	OS.delay_msec(70)
	if Global.device_has_touchscreen():
		_next()
	else:
		connect("finished", self, "_finished")
