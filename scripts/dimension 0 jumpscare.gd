extends Node2D

onready var exit_timer := $ExitTimer

func _exit():
	get_tree().quit()

func _ready():
	exit_timer.connect("timeout", self, "_exit")
	Global.forced_title = " "
	
	var icon := Image.new()
	icon.lock()
	icon.fill(Color(0, 0, 0, 0))
	icon.unlock()
	OS.set_icon(icon)
