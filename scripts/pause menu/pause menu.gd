extends Node

# Nodes
onready var settings_screen := $"Settings Screen"
onready var pause_screen    := $"Pause Screen"
onready var btn_pause       := get_parent().get_node("Touchscreen/Pause Button/Button")


# Variables
var paused := false


##################
# Node functions #
##################
func _ready():
	btn_pause.connect("pressed", self, "toggle")
	
	# Hiding menu in case it's left visible in the editor
	self.visible = false
	get_tree().paused = false

func _input(event):
	if Input.is_action_just_pressed("pause_game"):
		toggle()


####################
# Public functions #
####################
func toggle():
	paused = !paused
	self.visible = paused
	get_tree().paused = paused
	settings_screen.visible = false
	pause_screen.visible = true
