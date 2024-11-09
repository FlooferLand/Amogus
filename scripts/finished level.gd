extends Control

# Nodes
onready var info = $Info
onready var btn_main_menu = $"Main Menu button"
onready var leaderboard = $Leaderboard

# Node functions
func _ready():
	btn_main_menu.connect("pressed", self, "_on_main_menu_press")
	_add_info("Final time: " + str(Global.final_time) + "s")
	_add_info("Attempts: " + str(Global.final_attempts))
	_add_info("Dababy mode was " + ("on" if Global.dababy_mode else "off"))
	_add_info("Version: v%s" % GameInfo.version)
	
	if Global.player_dead_while_finished:
		_add_info("Kinda exploded tbh")
	
	Global.set_score()
	for score in Global.get_highscores():
		leaderboard.add_item(
			"%s: %ss" % [score.player_name, score.score]
		)

# Private functions
func _on_main_menu_press():
	get_tree().change_scene("res://levels/Main Menu.tscn")

func _add_info(text: String):
	info.bbcode_text += text + '\n'
