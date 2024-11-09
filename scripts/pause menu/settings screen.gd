extends Control

# Nodes
onready var parent           := get_parent()
onready var btn_back         := $BackBtn
onready var s_fullscreen     := $"Background/Scroll/Settings/Fullscreen"
onready var s_quit_jumpscare := $"Background/Scroll/Settings/Quit Jumpscare"
onready var s_update_title   := $"Background/Scroll/Settings/Auto-update title"
onready var s_music_volume   := $"Background/Scroll/Settings/Music Volume/Slider"
onready var s_sfx_volume   := $"Background/Scroll/Settings/SFX Volume/Slider"
var user_modified = false

# Private functions
func _back_button():
	self.visible = false
	parent.pause_screen.visible = true

# Node functions
func _ready():
	visible = false
	btn_back.connect("pressed", self, "_back_button")
