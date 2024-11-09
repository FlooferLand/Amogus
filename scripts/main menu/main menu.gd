extends Control

# Nodes
onready var lb_title := $Title
onready var lb_name := $Leaderboard/Name
onready var lb_btn := $Leaderboard/AddBtn
onready var lb_label := $Leaderboard/Label
onready var btn_dababy := $"Dababy Button"
onready var info := $Info
onready var version := $Version


# Variables
onready var original_title = lb_title.bbcode_text


# Private functions
func _set_name():
	Global.set_player_name(lb_name.text)

func _dababy_btn_toggled(on):
	if on:
		lb_title.bbcode_text = "[center][color=gray][s]amogus[/s][/color]  [wave]dababy rage game[/wave]"
	else:
		lb_title.bbcode_text = original_title
		

# Node functions
func _ready():
	lb_btn.connect("pressed", self, "_set_name")
	btn_dababy.connect("toggled", self, "_dababy_btn_toggled")
	version.text = "v%s" % GameInfo.version + '\n' + GameInfo.version_name
	
	# idk why i added this
	Global.dababy_mode = false
	
	# yes
	lb_title.bbcode_text += " (developer build)" if Global.debug_mode() else ""
	
	# Telling the user if they're signed into the leaderboard or not
	if SaveFile.data.player_name != "":
		lb_name.text = SaveFile.data.player_name
		lb_label.text = "Leaderboard (signed in)"
	
	
	########################
	# Info (warnings, etc) #
	########################
	info.bbcode_text += "Leaderboard system not implemented [wave amp=10 freq=3]yet[/wave]!\n"
	if Global.device_has_touchscreen():
		info.bbcode_text += "WARNING: Touchscreen controls may be a bit scuffed!"

