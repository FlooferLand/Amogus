extends Control

# Nodes
onready var info = $Info
onready var btn_back = $BackBtn

# Private functions
func _back_btn_pressed():
	get_tree().change_scene("res://levels/Main Menu.tscn")

func _meta_clicked(meta):
	if typeof(meta) == TYPE_STRING:
		if meta.length() > 0:
			if OS.shell_open(meta) != OK:
				OS.alert("uhh, \"error\", as the computers say")
		else:
			OS.alert("Empty path, the directory/file probably wasn't created yet or something")

# Node functions
func _ready():
	btn_back.connect("pressed", self, "_back_btn_pressed")
	info.connect("meta_clicked", self, "_meta_clicked")
	parse_changelog()
	
# Public functions
func parse_changelog():
	var changelog_keys := GameInfo.changelog.keys()
	changelog_keys.invert()
	var final_text := ""
	for key in changelog_keys:
		var version = GameInfo.changelog[key]
		
		var changes := ""
		for change in version.changes:
			changes += "[color=white]-[/color] [color=silver]%s\n[/color]" % change 
		final_text += "[b]%s  -  %s[/b]\n%s\n\n" % [key, version.name, changes]
	info.bbcode_text = final_text
