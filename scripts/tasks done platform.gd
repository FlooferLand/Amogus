extends Area2D

func _on_body_entered(node):
	if node.is_in_group("player"):
		Global.final_time = Global.speedrun_timer.time - 0.01
		Global.final_attempts = Global.player.attempts
		Global.player_dead_while_finished = Global.player.dead
		get_tree().change_scene("res://levels/Finished.tscn")

func _ready():
	connect("body_entered", self, "_on_body_entered")
