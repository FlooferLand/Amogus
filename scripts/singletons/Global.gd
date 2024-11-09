extends Node

# Resources
const tileset: TileSet = preload("res://tileset.tres")
const tiles: Texture   = preload("res://sprites/other/tilemap.png")

# Nodes
var player
var speedrun_timer
var UI

# Enums
enum Trolls   { WindowMover, Bouncer }
enum Features { Pogo, WallJump }

# Active features / trolls
var we_do_a_little_bit_of_trolling := [Trolls.Bouncer]
var features := [ Features.Pogo ]

# General variables
const tile_size := 64
var final_time: float
var final_attempts: int
var score_id: String
var leaderboard := []
var forced_title := ""
var dababy_mode := false
var player_dead_while_finished := false
var update_title := 0
var quiting := false
var engine_version = ""

##################
# Node functions #
##################
func _ready():	
	randomize()
	OS.min_window_size = Vector2(
		ProjectSettings.get("display/window/size/Minimum Width"),
		ProjectSettings.get("display/window/size/Minimum Height")
	)
	#OS.window_maximized = true
	engine_version = Engine.get_version_info()
	engine_version = "%s.%s.%s-%s" % [engine_version.major, engine_version.minor, engine_version.patch, engine_version.status]

var _bounce_flip := false
func _process(delta):
	if forced_title.length() == 0:
		OS.set_window_title(
			"amogus rage game"
			+ " (v%s)" % GameInfo.version
			+ (" (DEBUG)" if debug_mode() else "")
			+ ("  |  FPS: %s" % Engine.get_frames_per_second())
			#+ ("  |  Godot Engine v%s" % engine_version)
		)
	else:
		OS.set_window_title(forced_title)
	
	if Trolls.WindowMover in we_do_a_little_bit_of_trolling and is_instance_valid(player) and player.camera != null:
		if OS.window_maximized or OS.window_fullscreen:
			OS.window_maximized = false
			OS.window_fullscreen = false
		
		if OS.window_position.x + OS.window_size.x == OS.get_screen_size().x \
		or OS.window_position.x == 0:
			_bounce_flip = not _bounce_flip
		
		if _bounce_flip:
			OS.window_position.x += 1
			player.camera.position.x += 1
		else :
			OS.window_position.x -= 1
			player.camera.position.x -= 1

func _input(event):
	if not event is InputEventKey:
		return
	if Input.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _notification(what):
	match what:
		MainLoop.NOTIFICATION_CRASH:
			OS.alert("error game crashed haha, get better computer")
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			if not debug_mode() and randi() % 1000 == 52:
				OS.alert("this message has a 1 out of 1000 chance of showing up, i hope being lucky enough to see this completely off-topic meaningless message makes your day better")
			
			# Jumpscare and stuff lmao
			if SaveFile.data["impostor_quit_jumpscare"]:
				get_tree().change_scene("res://levels/Quit.tscn")
			else:
				get_tree().quit(0)

####################
# Public functions #
####################
func device_has_touchscreen() -> bool:
	return OS.has_touchscreen_ui_hint()

func debug_mode() -> bool:
	return OS.is_debug_build()

func set_audio_bus_volume(id: String, volume: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(id.to_lower()),
		volume
	)

func get_audio_bus_volume(id: String):
	return AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index(id.to_lower())
	)

func get_tile_texture(tile_name: String) -> AtlasTexture:
	var tex: AtlasTexture = AtlasTexture.new()
	tex.atlas = tiles
	tex.region = tileset.tile_get_region(tileset.find_tile_by_name(tile_name))
	return tex

# BBCode stuff
func bb_link(link: String, text: String = "") -> String:
	if text == "":
		text = link
	return "[color=aqua][url={link}]{text}[/url][/color]".format({"link": link, "text": text})

func bb_emoji(id: String, link: String = "") -> String:
	var yes := "[img=18x18]%s[/img]"
	if link == "":
		match id.to_lower():
			"skull":
				return yes % "res://sprites/emoji/skull emoji.png"
			"flushed":
				return yes % "res://sprites/emoji/flushed.png"
			"kekw":
				return yes % "res://sprites/emoji/kekw.png"
			"tpose", "t pose", "stare":
				return yes % "res://sprites/emoji/tpose.png"
			_:
				OS.alert("Couldn't find emoji '%s'. Yes, the game gave out an error because of an emoji shut up-" % id, "EMOJI ERROR (cleary important)")
				return "<EMOJI '%s'>" % id
	else:
		return yes % link

# Setters
func set_player_name(_name: String):
	SaveFile.save_setting("player_name", _name.strip_edges())

# Highscores
func set_score():
	if SaveFile.data.player_name == "":
		return
	print("SET_SCORE: ", final_time)
func refresh_leaderboard():
	pass # Get high scores here!
func get_highscores() -> Array:
	if leaderboard.size() == 0:
		refresh_leaderboard()
	print("HIGHSCORES: ", leaderboard)
	return leaderboard
