extends Node

# Constants
const savefile_path := "user://game.save"
const disable_file_storage := false

# Variables
var data := {
	# Settings
	"fullscreen": false,
	"fps_cap": true,
	"impostor_quit_jumpscare": true,
	"music_volume": 0,
	"sfx_volume": 0,
	
	# Game stuff
	"version": GameInfo.version,
	"enable_logger": false,
	"player_name": "",
}


##################
# Node functions #
##################
func _ready():
	load_settings()
	apply_settings()


####################
# Public functions #
####################
func write_settings_to_disk():
	if disable_file_storage:
		return
	var file := File.new()
	file.open(savefile_path, File.WRITE)
	file.store_string(var2str(data))
	file.close()

func save_setting(key: String, value):
	if disable_file_storage:
		return
	data[key] = value
	apply_setting(key, value)

func load_settings():
	if disable_file_storage:
		return
	var file := File.new()
	if file.file_exists(savefile_path):
		file.open(savefile_path, File.READ)
		data = str2var(file.get_as_text())
		file.close()
		apply_settings()

# Runs a bunch of code to actually use the values saved in the settings file
func apply_settings():
	for key in data.keys():
		var value = data[key]
		apply_setting(key, value)
func apply_setting(key, value):
	match key:
		"fullscreen":
			OS.window_fullscreen = value
		"fps_cap":
			if value:
				Engine.target_fps = 150
			else:
				Engine.target_fps = 0
		"music_volume":
			Global.set_audio_bus_volume("music", value)
		"sfx_volume":
			Global.set_audio_bus_volume("sfx", value)
		_:
			print("[apply_setting] Setting \"%s\" wasn't handled." % key)
		#_:
		#	Global.set(key, value)
