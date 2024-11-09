extends Control

# Nodes
onready var button := $"Button"

# Variables
var just_pressed := false
var just_released := false
var holding := false

func _pressed():
	if not holding:
		holding = true
		just_pressed = true

func _released():
	if holding:
		holding = false
		just_released = true

func _ready():
	button.connect("pressed",  self, "_pressed")
	button.connect("released", self, "_released")

func _physics_process(delta):
	if holding:
		just_pressed = false
	else:
		just_released = false
