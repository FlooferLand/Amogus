extends Node2D

# Variables
export(String) var location: String
onready var collision_area := $Collision

# Node functions
func _ready():
	collision_area.connect("body_entered", self, "_portal_entered")

# Private functions
func _portal_entered(node):
	if node.is_in_group("player"):
		get_tree().change_scene(location)
