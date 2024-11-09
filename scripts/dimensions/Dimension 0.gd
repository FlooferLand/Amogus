extends Node2D

# Nodes
onready var playerus = $Playerus

# Node functions
func _ready():
	playerus.can_jump = false
	playerus.can_crouch = false
	playerus.starting_position = Vector2(385, 200)

func _process(delta):
	if playerus.attempts == 1:
		playerus.can_move = false
	elif playerus.attempts >= 6:
		get_tree().change_scene("res://levels/dimensions/Dimension 0 Jumpscare.tscn")
