extends CheckButton

# Nodes
onready var ico := get_parent().get_node("Icon")
onready var audio := $"Audio"

# Images
const img_amogus := preload("res://sprites/other/impostor.png")
const img_dababy := preload("res://sprites/other/dababy.png")

# Sound
const sfx_amogus := preload("res://audio/Sus Song.mp3")
const sfx_dababy := preload("res://audio/DaBaby Lets Go.mp3")

func _toggled(on):
	audio.stop()
	Global.dababy_mode = on
	if on:
		audio.stream = sfx_dababy
		ico.texture = img_dababy
	else:
		audio.stream = sfx_amogus
		ico.texture = img_amogus
	audio.play()
