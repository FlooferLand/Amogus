extends StaticBody2D

# Nodes
onready var interior := $Inside
onready var panel  := $Panel

# Variables
var is_inside := false

func _ready():
	interior.connect("body_entered", self, "_body_entered")
	interior.connect("body_exited", self, "_body_exited")

func _process(delta):
	if is_inside and panel.modulate.a != 0:
		panel.modulate.a = lerp(panel.modulate.a, 0, 0.05 + delta)
	if (not is_inside) and panel.modulate.a != 1:
		panel.modulate.a = lerp(panel.modulate.a, 1.0, 0.05 + delta)

func _body_entered(body: Node2D):
	if body == Global.player:
		is_inside = true
func _body_exited(body: Node2D):
	if body == Global.player:
		is_inside = false
