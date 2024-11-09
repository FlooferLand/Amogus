extends Area2D

func _on_body_entered(node):
	if node.is_in_group("player"):
		node.die()

func _ready():
	connect("body_entered", self, "_on_body_entered")
