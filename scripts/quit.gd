extends Control

# Nodes
onready var audio = $Audio

# Private functions
func _quit():
	get_tree().quit()

# Node functions
func _ready():
	get_tree().set_auto_accept_quit(true)
	audio.connect("finished", self, "_quit")
