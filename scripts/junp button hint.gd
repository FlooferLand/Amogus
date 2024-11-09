extends Area2D

# Nodes
onready var bruh  := $Bruh
onready var label := $Label

# Variables
var falls := -1

# Public functions
func set_text(text: String):
	label.bbcode_text = ("[center]" + text)

# Node functions
func _ready():
	connect("body_entered", self, "_body_entered")
	
func _physics_process(delta):
	if falls > -1:
		if Input.is_action_just_pressed("player_jump"):
			set_text("good.")
		if Input.is_action_just_released("player_jump"):
			queue_free()

func _body_entered(node: Node):
	if node == Global.player:
		Global.player.reset()
		bruh.play()
		visible = true
		falls += 1
		
		match falls:
			0:
				set_text("just press the jump button it's not that hard")
			1:
				set_text("oh come on")
			2:
				set_text("not againnn")
			3:
				if not Global.device_has_touchscreen():
					set_text("use the key with the \"W\" written on it")
				else:
					set_text("use the button in the bottom right")
			3:
				set_text(".......")
			4:
				#OS.alert("your game is gonna crash now due to your excess trollololololing", "")
				# rickroll
				if OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ") != OK:
					OS.alert("Hold up uhh.... I tried rickrolling you and that gave out an error..", "")
					OS.alert("Your PC is quite literally rickroll proof", "")
					OS.alert("welp, I'm gonna crash your game since I'm too lazy to work on a system to make the text below you disappear lmao", "")
					OS.alert("see ya", "")
				get_tree().quit(69)
