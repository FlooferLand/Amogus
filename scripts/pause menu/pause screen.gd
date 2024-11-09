extends Node

# Nodes
onready var parent = get_parent()
onready var title = $Title
onready var resume = $"Buttons/Resume"
onready var settings = $"Buttons/Settings"
onready var quit = $"Buttons/Quit to menu"


##################
# Node functions #
##################
func _ready():
	# Buttons
	resume.connect("pressed", self, "_resume_pressed")
	settings.connect("pressed", self, "_settings_pressed")
	quit.connect("pressed", self, "_quit_pressed")
	
	# Dababy mode
	if Global.dababy_mode:
		title.text = "PAUSED (lets gooo)"


#####################
# Private functions #
#####################
func _resume_pressed():
	parent.toggle()

func _settings_pressed():
	self.visible = false
	parent.settings_screen.visible = true

func _quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://levels/Main Menu.tscn")

