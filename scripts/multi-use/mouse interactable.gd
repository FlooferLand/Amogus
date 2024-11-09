extends Area2D

onready var sound = $Sound

func _ready():
	input_pickable = true
	$Selected.visible = false
	connect("mouse_entered", self, "_mouse_entered")
	connect("mouse_exited",  self, "_mouse_exited")

func _mouse_entered():
	$Selected.visible = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _mouse_exited():
	$Selected.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		sound.play()
